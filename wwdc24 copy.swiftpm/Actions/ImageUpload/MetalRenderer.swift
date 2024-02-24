//
//  File.swift
//
//
//  Created by Carol Quiterio on 24/02/24.
//

import Foundation
import MetalKit
import Metal
import CoreGraphics

class MetalRenderer: NSObject, MTKViewDelegate {
    var parent: ImageUploadView
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState
    
    init?(_ parent: ImageUploadView) {
        self.parent = parent
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        
        self.metalCommandQueue = self.metalDevice.makeCommandQueue()
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = self.metalDevice.makeDefaultLibrary()
        
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "circleFilter")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .rgba8Unorm
        
        do {
            try self.pipelineState = self.metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            return nil
        }
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        
        guard let drawable = view.currentDrawable else {
            return
        }
        
        let commandBuffer = metalCommandQueue.makeCommandBuffer()
        
        let renderPassDescription = view.currentRenderPassDescriptor
        //renderPassDescription?.colorAttachments
        
        guard let renderPassDescription = renderPassDescription else {
            return
        }
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescription)
        
        renderEncoder?.setViewport(.init(originX: 0, originY: 0, width: view.drawableSize.width, height: view.drawableSize.height, znear: 0, zfar: 1))
        
        
        renderEncoder?.setRenderPipelineState(pipelineState)
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    func applyFilter(to image: UIImage)  {
        
    }
}


class MetalImageFilter {
    private let device: MTLDevice
    private let library: MTLLibrary
    private let pipelineState: MTLComputePipelineState
    
    init?() {
        guard let device = MTLCreateSystemDefaultDevice(),
              let library = device.makeDefaultLibrary(),
              let kernelFunction = library.makeFunction(name: "circleFilter") else {
            return nil
        }
        
        do {
            pipelineState = try device.makeComputePipelineState(function: kernelFunction)
        } catch {
            return nil
        }
        
        self.device = device
        self.library = library
    }
    
    
    func applyFilter(to image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let inputTexture = makeTexture(from: cgImage, device: device)
        let outputTexture = makeEmptyTexture(width: inputTexture.width,
                                             height: inputTexture.height,
                                             device: device)
        
        let commandQueue = device.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        
        encoder.setComputePipelineState(pipelineState)
        encoder.setTexture(inputTexture, index: 0)
        encoder.setTexture(outputTexture, index: 1)
        
        let threadsPerThreadgroup = MTLSize(width: 16, height: 16, depth: 1)
        let threadgroups = MTLSize(width: (inputTexture.width + 15) / 16,
                                   height: (inputTexture.height + 15) / 16,
                                   depth: 1)
        encoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadsPerThreadgroup)
        
        encoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        return makeImage(from: outputTexture)
    }
    
    
    
    /*
     func applyFilter(to image: UIImage) -> UIImage? {
     guard let cgImage = image.cgImage else {
     return nil
     }
     
     let inputTexture = makeTexture(from: cgImage, device: device)
     let outputTexture = makeEmptyTexture(width: inputTexture.width,
     height: inputTexture.height,
     device: device)
     
     let commandQueue = device.makeCommandQueue()!
     let commandBuffer = commandQueue.makeCommandBuffer()!
     let encoder = commandBuffer.makeComputeCommandEncoder()!
     
     encoder.setComputePipelineState(pipelineState)
     encoder.setTexture(inputTexture, index: 0)
     encoder.setTexture(outputTexture, index: 1)
     
     let threadsPerThreadgroup = MTLSize(width: 16, height: 16, depth: 1)
     let threadgroups = MTLSize(width: (inputTexture.width + 15) / 16,
     height: (inputTexture.height + 15) / 16,
     depth: 1)
     encoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadsPerThreadgroup)
     
     encoder.endEncoding()
     commandBuffer.commit()
     commandBuffer.waitUntilCompleted()
     
     return makeImage(from: outputTexture)
     }
     */
    private func makeTexture(from cgImage: CGImage, device: MTLDevice) -> MTLTexture {
        let textureLoader = MTKTextureLoader(device: device)
        do {
            return try textureLoader.newTexture(cgImage: cgImage, options: nil)
        } catch {
            fatalError("Failed to create texture from CGImage: \(error)")
        }
    }
    
    private func makeEmptyTexture(width: Int, height: Int, device: MTLDevice) -> MTLTexture {
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                         width: width,
                                                                         height: height,
                                                                         mipmapped: false)
        textureDescriptor.usage = [.shaderRead, .shaderWrite]
        return device.makeTexture(descriptor: textureDescriptor)!
    }
    
    
    private func makeImage(from texture: MTLTexture) -> UIImage {
    //    let ciImage = CIImage(mtlTexture: texture, options: nil)
        
        let context = CIContext()
        
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
       /* let options: [CIImageOption : Any] = [
                    .colorSpace: colorSpace,
                    .applyOrientationProperty: UIDeviceOrientation.portrait
                    
        ]*/// isso concerta p/ 4:3
        let ciImage = CIImage(mtlTexture: texture, options: nil)
        
        
        guard let cgImage = context.createCGImage(ciImage!, from: ciImage!.extent) else {
            fatalError("Failed to create CGImage from CIImage")
        }

        return UIImage(cgImage: cgImage, scale: 1.0, orientation: UIImage.Orientation.downMirrored)
    }
    
    
}
