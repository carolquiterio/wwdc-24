//
//  File.swift
//
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI
import AVFoundation

struct LiveCameraView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: LiveCameraViewModel? = nil
    @State private var isCameraAccessGranted: Bool = false
    
    var body: some View {
        VStack {
            //        CustomBackButton() {
            //            dismiss()
            //        }
            
            if(isCameraAccessGranted) {
                if let viewModel = viewModel, let operation = viewModel.operationChain {
                    VideoPreview(operation: operation)
                        .onAppear {
                            viewModel.camera.startCapture()
                        }
                        .onDisappear {
                            viewModel.camera.stopCapture()
                        }
                } else {
                    CustomText(
                        text: "Preparing...",
                        textSize: 16
                    )
                }
            } else {
                CustomText(
                    text: "Please, give the App access to camera to use this feature.",
                    textSize: 16
                )
                .padding()
            }
            
        }.onAppear {
            checkCameraAuthorization()
            if(isCameraAccessGranted) {
                viewModel = LiveCameraViewModel()
            }
        }
    }
    
    func checkCameraAuthorization() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            isCameraAccessGranted = true
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                isCameraAccessGranted = granted
            }
            break
        case .denied, .restricted:
            isCameraAccessGranted = false
            break
        @unknown default:
            isCameraAccessGranted = false
        }
    }
}

public struct VideoPreview: UIViewRepresentable {
    let prevChain: OperationChain
    public init(operation: OperationChain) {
        prevChain = operation
    }
    
    public func makeUIView(context: Context) -> MetalVideoView {
        let view = MetalVideoView()
        prevChain.addTarget(view)
        return view
    }
    
    public func updateUIView(_ uiView: MetalVideoView, context: Context) {
        prevChain.addTarget(uiView)
    }
}

class LiveCameraViewModel: ObservableObject {
    let camera = try! MetalCamera(videoOrientation: .portrait)
    
    let redAndGreenFilter = RedAndGreenFilter()
    
    @Published var operationChain: OperationChain?
    var currentIndex = 0
    
    init() {
        camera-->redAndGreenFilter
        operationChain = redAndGreenFilter
    }
}
