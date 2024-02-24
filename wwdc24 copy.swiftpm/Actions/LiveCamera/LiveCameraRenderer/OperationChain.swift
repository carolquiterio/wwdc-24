//
//  File.swift
//  
//
//  Created by Carol Quiterio on 20/02/24.
//

import Foundation
import AVFoundation

public protocol OperationChain: AnyObject {
    var targets: TargetContainer<OperationChain> { get }
    func newTextureAvailable(_ texture: Texture)
    func operationFinished(_ texture: Texture)
}

extension OperationChain {
    func addTarget(_ target: OperationChain) {
        targets.append(target)
    }

    public func removeTarget(_ target: OperationChain) {
        targets.remove(target)
    }

    public func removeAllTargets() {
        targets.removeAll()
    }

    public func operationFinished(_ texture: Texture) {
        for target in targets {
            target?.newTextureAvailable(texture)
        }
    }
}

public protocol CMSampleChain: OperationChain {
    func newBufferAvailable(_ sampleBuffer: CMSampleBuffer)
}

infix operator --> : AdditionPrecedence
infix operator ==> : AdditionPrecedence

@discardableResult public func --><T: OperationChain>(source: OperationChain, destination: T) -> T {
    source.addTarget(destination)
    return destination
}

public class TargetContainer<T>: Sequence {
    var targets = [T]()
    var count: Int { get { return targets.count }}
    let dispatchQueue = DispatchQueue(label:"MetalCamera.targetContainerQueue", attributes: [])

    public init() {
    }

    public func append(_ target: T) {
        dispatchQueue.async{
            self.targets.append(target)
        }
    }

    public func remove(_ target: T) {
        dispatchQueue.async {
            self.targets.removeAll {
                $0 as AnyObject === target as AnyObject
            }
        }
    }

    public func makeIterator() -> AnyIterator<T?> {
        var index = 0

        return AnyIterator { () -> T? in
            return self.dispatchQueue.sync{
                if (index >= self.targets.count) {
                    return nil
                }

                index += 1
                return self.targets[index - 1]
            }
        }
    }

    public func removeAll() {
        dispatchQueue.async{
            self.targets.removeAll()
        }
    }
}

