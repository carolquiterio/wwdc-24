//
//  File.swift
//  
//
//  Created by Carol Quiterio on 20/02/24.
//

import AVFoundation

enum MetalCameraError: Error {
    case noVideoDevice
    case deviceInputInitialize
}

public class MetalCamera: NSObject, OperationChain {
    public var runBenchmark = false
    public var logFPS = false

    public let captureSession: AVCaptureSession
    public var inputCamera: AVCaptureDevice!

    var videoInput: AVCaptureDeviceInput!
    let videoOutput: AVCaptureVideoDataOutput!
    var videoTextureCache: CVMetalTextureCache?

    let cameraProcessingQueue = DispatchQueue.global()
    let cameraFrameProcessingQueue = DispatchQueue(label: "MetalCamera.cameraFrameProcessingQueue", attributes: [])

    let frameRenderingSemaphore = DispatchSemaphore(value: 1)

    var numberOfFramesCaptured = 0
    var totalFrameTimeDuringCapture: Double = 0.0
    var framesSinceLastCheck = 0
    var lastCheckTime = CFAbsoluteTimeGetCurrent()

    public let sourceKey: String
    public var targets = TargetContainer<OperationChain>()

    var currentPosition = AVCaptureDevice.Position.back
    var videoOrientation: AVCaptureVideoOrientation?

    public init(sessionPreset: AVCaptureSession.Preset = .hd1280x720,
                position: AVCaptureDevice.Position = .back,
                sourceKey: String = "camera",
                videoOrientation: AVCaptureVideoOrientation? = nil) throws {
        self.sourceKey = sourceKey

        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()

        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferMetalCompatibilityKey as String: true,
                                     kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        self.videoOrientation = videoOrientation

        super.init()

        defer {
            captureSession.commitConfiguration()
        }

        try updateVideoInput(position: position)

        captureSession.sessionPreset = sessionPreset
        captureSession.commitConfiguration()

        CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, sharedMetalRenderingDevice.device, nil, &videoTextureCache)

        videoOutput.setSampleBufferDelegate(self, queue: cameraProcessingQueue)
    }

    deinit {
        cameraFrameProcessingQueue.sync {
            stopCapture()
            videoOutput?.setSampleBufferDelegate(nil, queue:nil)
        }
    }

    public func startCapture() {
        guard captureSession.isRunning == false else { return }

        let _ = frameRenderingSemaphore.wait(timeout:DispatchTime.distantFuture)
        numberOfFramesCaptured = 0
        totalFrameTimeDuringCapture = 0
        frameRenderingSemaphore.signal()

        captureSession.startRunning()
    }

    public func stopCapture() {
        guard captureSession.isRunning else { return }

        let _ = frameRenderingSemaphore.wait(timeout:DispatchTime.distantFuture)
        captureSession.stopRunning()
        self.frameRenderingSemaphore.signal()
    }

    private func updateVideoInput(position: AVCaptureDevice.Position) throws {
        guard let device = position.device() else {
            throw MetalCameraError.noVideoDevice
        }

        inputCamera = device

        if videoInput != nil {
            captureSession.removeInput(videoInput)
        }

        do {
            self.videoInput = try AVCaptureDeviceInput(device: inputCamera)
        } catch {
            throw MetalCameraError.deviceInputInitialize
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }

        if let orientation = videoOrientation {
            videoOutput.connection(with: .video)?.videoOrientation = orientation
        }

        currentPosition = position
    }

    public func newTextureAvailable(_ texture: Texture) {}
}

extension MetalCamera: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if connection == videoOutput?.connection(with: .video) {
            for target in targets {
                if let target = target as? CMSampleChain {
                    target.newBufferAvailable(sampleBuffer)
                }
            }

            handleVideo(sampleBuffer)

        }
    }

    private func handleVideo(_ sampleBuffer: CMSampleBuffer) {
        guard (frameRenderingSemaphore.wait(timeout:DispatchTime.now()) == DispatchTimeoutResult.success) else { return }
        guard let cameraFrame = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let videoTextureCache = videoTextureCache else { return }

        let startTime = CFAbsoluteTimeGetCurrent()
        let bufferWidth = CVPixelBufferGetWidth(cameraFrame)
        let bufferHeight = CVPixelBufferGetHeight(cameraFrame)
        let currentTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)

        CVPixelBufferLockBaseAddress(cameraFrame, CVPixelBufferLockFlags(rawValue:CVOptionFlags(0)))

        cameraFrameProcessingQueue.async {
            CVPixelBufferUnlockBaseAddress(cameraFrame, CVPixelBufferLockFlags(rawValue:CVOptionFlags(0)))

            let texture: Texture?

            var textureRef: CVMetalTexture? = nil
            let _ = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, videoTextureCache, cameraFrame, nil, .bgra8Unorm, bufferWidth, bufferHeight, 0, &textureRef)
            if let concreteTexture = textureRef,
                let cameraTexture = CVMetalTextureGetTexture(concreteTexture) {
                texture = Texture(texture: cameraTexture, timestamp: currentTime, textureKey: self.sourceKey)
            } else {
                texture = nil
            }

            if let texture = texture {
                self.operationFinished(texture)
            }

            if self.runBenchmark {
                self.numberOfFramesCaptured += 1

                let currentFrameTime = (CFAbsoluteTimeGetCurrent() - startTime)
                self.totalFrameTimeDuringCapture += currentFrameTime
            }

            if self.logFPS {
                if ((CFAbsoluteTimeGetCurrent() - self.lastCheckTime) > 1.0) {
                    self.lastCheckTime = CFAbsoluteTimeGetCurrent()
                    self.framesSinceLastCheck = 0
                }
                self.framesSinceLastCheck += 1
            }

            self.frameRenderingSemaphore.signal()
        }
    }
}

extension AVCaptureDevice.Position {
    func device() -> AVCaptureDevice? {
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                           mediaType: .video,
                                                                           position: self)

        for device in deviceDescoverySession.devices where device.position == self {
            return device
        }

        return nil
    }
}

