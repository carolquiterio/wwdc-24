//
//  SwiftUIView.swift
//
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct TutorialView: View {
    
    @State private var currentTutorialIndex = 0
    
    let tutorials: [Tutorial] = [
        Tutorial(text: "Today, we're delving into a type of color blindness known as \"green-red.\" ", imageName: "ShapesWithHand", invertBalloon: false),
        Tutorial(text: "People with this condition live in a world where greens and reds appear as the same color.", imageName: "Shapes", invertBalloon: false),
        Tutorial(text: "Okay, but why does this happen?", imageName: "Shapes", invertBalloon: true),
        Tutorial(text: "Picture this – your eye has 3 color cones, but 2 of them get a little confused due to a genetic mutation in the retina.", imageName: "EyesCones", invertBalloon: false),
        Tutorial(text: "Oooh! Looks like colors are playing hide and seek! But… why does it matter?", imageName: "Shapes", invertBalloon: true),
        Tutorial(text: "Well, imagine the daily challenges these individuals face, like seeing traffic lights on the street.", imageName: "Shapes", invertBalloon: false)
    ]
    
    
    @State private var text: String = "Today, we're delving into a type of color blindness known as \"green-red.\""
    @State private var imageName: String = "ShapesWithHand"
    @State private var invertBalloon: Bool = false
    
    var body: some View {
        VStack {
            if(currentTutorialIndex > 0) {
                CustomBackButton(action: {
                    backIndice()
                    text = tutorials[currentTutorialIndex].text
                    imageName = tutorials[currentTutorialIndex].imageName
                    invertBalloon = tutorials[currentTutorialIndex].invertBalloon
                })
            } else {
                Spacer()
            }
            TextBalloon(text: text, invertBalloon: invertBalloon)
            
            if(currentTutorialIndex == 3) {
                AnimatedImageView(imageNames: ["EyeConeAnimation 0", "EyeConeAnimation 1", "EyeConeAnimation 2", "EyeConeAnimation 3"], frameCount: 4, frameDuration: 0.5)
                    .frame(maxHeight: 280)
            } else {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 380)
            }
            Spacer()
            if(currentTutorialIndex != 5) {
                Spacer()
                CustomButtonWithAction(
                    title: "Next",
                    action: {
                        nextIndice()
                        text = tutorials[currentTutorialIndex].text
                        imageName = tutorials[currentTutorialIndex].imageName
                        invertBalloon = tutorials[currentTutorialIndex].invertBalloon
                    }
                )
                .padding()
            } else {
                Spacer()
                CustomButton(
                    title: "Next",
                    destinationView: SemaphoreTutorialView()
                )
                .padding()
            }
            
        }.background(.white)
        .navigationBarBackButtonHidden()
    }
    
    func nextIndice() {
        if(currentTutorialIndex == 5) {
            currentTutorialIndex = 5
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

struct Tutorial {
    let text: String
    let imageName: String
    let invertBalloon: Bool
}
