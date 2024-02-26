//
//  SwiftUIView.swift
//  
//
//  Created by Carol Quiterio on 25/02/24.
//

import SwiftUI

struct ThankYouView: View {
    var body: some View {
        ZStack {
            AnimatedImageView(imageNames: generateImageNames(startIndex: 1, endIndex: 2, name: "GreenTalksWithWorld"), frameCount: 2, frameDuration: 0.4)
                .scaledToFill()
                .background(.white)
            VStack {
                TextBalloon(text: "Thank you for trying the Color Shaping Machine! Shaping App's goal is to help color blind people around the world in their daily lives.", invertBalloon: false).frame(maxWidth: 360)
                    .padding(.top, 60)
                    .padding()
                Spacer()
                CustomButton(title: "Back to start", destinationView: InitialView())
                    .padding(.bottom, 36)
            }.padding()
                
        }
        
    }
}

#Preview {
    ThankYouView()
}
