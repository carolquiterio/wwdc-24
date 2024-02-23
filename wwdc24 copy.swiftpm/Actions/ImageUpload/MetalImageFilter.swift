import MetalKit

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
        let ciImage = CIImage(mtlTexture: texture, options: nil)!
  
        let flipped = ciImage.transformed(by: CGAffineTransform(scaleX: 1, y: -1))
        
            let context = CIContext()
        
        let cgImage = context.createCGImage(flipped, from: flipped.extent, format: CIFormat.RGBA8, colorSpace: CGColorSpace(name:CGColorSpace.linearSRGB))!
        
          //  let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
            return UIImage(cgImage: cgImage)
        }
}
