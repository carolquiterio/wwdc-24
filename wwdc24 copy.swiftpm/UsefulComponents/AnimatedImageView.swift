//
//  File.swift
//  
//
//  Created by Carol Quiterio on 23/02/24.
//

import SwiftUI

struct AnimatedImageView: View {
    let imageNames: [String]
    let frameCount: Int
    let frameDuration: Double
    
    @State private var currentFrame: Int = 0
    
    var body: some View {
        Image(imageNames[currentFrame])
            .resizable()
            .scaledToFit()
            .onAppear {
                let timer = Timer.scheduledTimer(withTimeInterval: frameDuration, repeats: true) { _ in
                    currentFrame = (currentFrame + 1) % frameCount
                }
                RunLoop.current.add(timer, forMode: .common)
            }
    }
}

