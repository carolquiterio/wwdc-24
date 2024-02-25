//
//  SwiftUIView.swift
//
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct ActionsView: View {
    var body: some View {
        VStack {
            AnimatedImageView(imageNames: generateImageNames(startIndex: 8, endIndex: 37, name: "MachineAnimation"), frameCount: 30, frameDuration: 0.2)
                .frame(maxWidth: 200)
                .padding(.top, 100)
            
            CustomBoldText(
                text: "Use images",
                textSize: 18,
                color: Colors.primary
            ).padding(.horizontal)
                .padding(.top, 36)
            
            CustomText(
                text: "or",
                textSize: 16
            ).padding(.horizontal)
            
            CustomButton(
                title: "Use live camera",
                destinationView: LiveCameraView()
            ).padding(.horizontal)
            
            CustomText(
                text: "To use live camera you need to be using a physical device.",
                textSize: 14
            )
            .padding(.horizontal)
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: InitialView()) {
                        CustomBoldText(text: "Finish", textSize: 18, color: Colors.primary
                                                               
                                                )
                                            }
            )
            
        }.background(.white)
        
        Spacer().background(.white)
    }
}


#Preview {
    ActionsView()
}
