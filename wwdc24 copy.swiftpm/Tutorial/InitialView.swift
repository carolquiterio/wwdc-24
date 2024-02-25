//
//  File.swift
//  
//
//  Created by Carol Quiterio on 22/02/24.
//

import SwiftUI

struct InitialView: View {
    
    var body: some View {
        ZStack {
            AnimatedImageView(imageNames: generateImageNames(startIndex: 1, endIndex: 6, name: "WelcomeAnimation"), frameCount: 6, frameDuration: 0.2)
                .scaledToFill()
            VStack (alignment: .center, content: {
                HStack {
                    Spacer()
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(Colors.primary)
                        .onTapGesture {
                            
                        }
                        .font(.system(size: 24, weight: .bold))
                }.padding()
                
                CustomBoldText(text: "Welcome to Shapping", textSize: 40)
                    .padding()
                Spacer()
                
                CustomButton(
                    title: "Start",
                    destinationView: TutorialView()
                ).padding()
                 .padding(.bottom, 36)
            }).padding()
                .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    InitialView()
}
