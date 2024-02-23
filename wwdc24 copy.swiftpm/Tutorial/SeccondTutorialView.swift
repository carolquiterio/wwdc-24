//
//  File.swift
//
//
//  Created by Carol Quiterio on 22/02/24.
//

import SwiftUI

struct SeccondTutorialView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentTutorialIndex = 0
    
    let tutorials: [SeccondTutorial] = [
        SeccondTutorial(
            text: "If there were something we could do to help these people identify different colors...",
            imageName: "Question",
            shapeImageName: "Red"),
        SeccondTutorial(
            text: "OOOOps, I think I have an idea! What if we created a machine to transform colors into shapes?",
            imageName: "ArtToShape",
            shapeImageName: "Green"),
        SeccondTutorial(
            text: "OOOOH! That would be amazing!",
            imageName: "ArtToShape",
            shapeImageName: "Red")
    ]
    
    @State private var text: String = "If there were something we could do to help these people identify different colors..."
    @State private var imageName: String = "Question"
    @State private var shapeImageName: String = "Red"
    
    var body: some View {
        VStack {
            CustomBackButton(action: {
                if(currentTutorialIndex > 0) {
                    backIndice()
                    text = tutorials[currentTutorialIndex].text
                    imageName = tutorials[currentTutorialIndex].imageName
                    shapeImageName = tutorials[currentTutorialIndex].shapeImageName
                } else {
                    dismiss()
                }
            })
            TextBalloonWithShape(
                text: text,
                invertBalloon: false,
                imageShapeName: tutorials[currentTutorialIndex].shapeImageName
            )
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300, maxHeight: 300)

            if(currentTutorialIndex != 2) {
                Spacer()
                CustomButtonWithAction(
                    title: "Next",
                    action: {
                        nextIndice()
                        text = tutorials[currentTutorialIndex].text
                        imageName = tutorials[currentTutorialIndex].imageName
                    }
                )
                .padding()
            } else {
                CustomButton(
                    title: "Next",
                    destinationView: MachineView()
                )
                .padding()
            }
            
        }.navigationBarBackButtonHidden()
            .background(.white)
    }
    
    
    func nextIndice() {
        if(currentTutorialIndex == 2) {
            currentTutorialIndex = 2
        } else {
            currentTutorialIndex+=1
        }
    }
    
    func backIndice() {
        if(currentTutorialIndex == 0) {
            currentTutorialIndex = 0
        } else {
            currentTutorialIndex-=1
        }
    }
}

#Preview {
    SeccondTutorialView()
}

struct TextBalloonWithShape: View {
    let text: String
    let invertBalloon: Bool
    let imageShapeName: String
    
    var body: some View {
        ZStack {
            Image("Balloon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .scaleEffect(x: invertBalloon ? -1 : 1, y: 1)
                .overlay(
                    content: {
                        CustomText(text: text, textSize: 16)
                            .padding(.horizontal, 24)
                        
                    }
                ).overlay(
                    Image(imageShapeName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 120, maxHeight: 120)
                        .offset(CGSize(width: -150.0, height: 70.0))
                )
        }
    }
}

struct SeccondTutorial {
    let text: String
    let imageName: String
    let shapeImageName: String
}
