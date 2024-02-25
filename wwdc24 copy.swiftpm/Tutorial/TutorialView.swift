//
//  SwiftUIView.swift
//
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentTutorialIndex = 0
    
    let tutorials: [Tutorial] = [
        Tutorial(text: "Hey! Nice to meet you! My name is Green, and this is Red. We're here to talk to you about color blindness!", imageName: "GreenTalks", invertBalloon: false),
        Tutorial(text: "Today, we're delving into a type of color blindness known as \"green-red.\" ", imageName: "GreenTalksRedThinks", invertBalloon: false),
        Tutorial(text: "People with this condition live in a world where greens and reds appear as the same color.", imageName: "RedIsGreen", invertBalloon: false),
        Tutorial(text: "Okay, but why does this happen?", imageName: "RedTalksRight", invertBalloon: true),
        Tutorial(text: "Picture this – your eye has 3 color cones, but 2 of them get a little confused due to a genetic mutation in the retina.", imageName: "GreenAndCones", invertBalloon: false),
        Tutorial(text: "Oooh! Looks like colors are playing hide and seek! But… why does it matter?", imageName: "RedTalksRight", invertBalloon: true),
        Tutorial(text: "Well, imagine the daily challenges these individuals face, like seeing traffic lights on the street.", imageName: "GreenTalksWithSemaphore", invertBalloon: false),
        Tutorial(text: "If there were something we could do to help these people identify different colors...", imageName: "RedThinksWithInterrogation", invertBalloon: false),
        Tutorial(text: "OOOOps, I think I have an idea! What if we created a machine to transform colors into shapes?", imageName: "GreenTalksWithShapes", invertBalloon: false),
        Tutorial(text: "Wow! That would be amazing!", imageName: "RedHappyWithShapes", invertBalloon: false)
    ]
    
    
    @State private var text: String = "Hey! Nice to meet you! My name is Green, and this is Red. We're here to talk to you about color blindness!"
    @State private var imageName: String = "GreenTalks"
    @State private var invertBalloon: Bool = false
    
    var body: some View {
        
        if(currentTutorialIndex == 6) {
            VStack {
                Spacer()
                CustomText(text: "This is what a person with normal vision sees at traffic lights:", textSize: 16)
                    .padding(.horizontal)
                    .padding(.top)
                
                Image("Semaphore")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 40)
                    .padding(.bottom, 16)
                
                CustomText(text: "And this is how a person with green-red color blindness sees it:", textSize: 16)
                    .padding(.horizontal)
                    .padding(.top)
                
                Image("SemaphoreColorBlind")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 40)
                    .padding(.bottom, 16)
                
                CustomText(text: "A person with color blindness can't distinguish between the red and green lights.", textSize: 16)
                    .padding(.horizontal)
                Spacer()
                HStack {
                    Group {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Colors.primary)
                        
                        CustomText(text: "Back", textSize: 20, color: Colors.primary)
                    }.onTapGesture {
                        backIndice()
                    }
                    
                    Spacer()
                    
                    Group {
                        CustomBoldText(text: "Next", textSize: 20, color: Colors.primary)
                        Image(systemName: "chevron.right")
                            .foregroundColor(Colors.primary)
                            .fontWeight(.bold)
                    }.onTapGesture {
                        nextIndice()
                    }
                }.padding(.horizontal)
                    .padding(.bottom, 4)
                
                    .navigationBarBackButtonHidden(true)
            }.padding()
        }
        else {
            ZStack {
                if(currentTutorialIndex != 4) {
                    AnimatedImageView(imageNames: generateImageNames(startIndex: 1, endIndex: 2, name: tutorials[currentTutorialIndex].imageName), frameCount: 2, frameDuration: 0.4)
                        .scaledToFill()
                } else {
                    AnimatedImageView(imageNames: generateImageNames(startIndex: 1, endIndex: 4, name: tutorials[currentTutorialIndex].imageName), frameCount: 4, frameDuration: 0.4)
                        .scaledToFill()
                }
                
                VStack {
                    TextBalloon(text: text, invertBalloon: invertBalloon).frame(maxWidth: 360)
                        .padding(.top, 80)
                        .padding()
                    Spacer()
                }
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Group {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Colors.primary)
                            
                            CustomText(text: "Back", textSize: 20, color: Colors.primary)
                        }.onTapGesture {
                            if(currentTutorialIndex == 0) {
                                dismiss()
                            } else {
                                backIndice()
                            }
                        }
                        
                        Spacer()
                        
                        if(currentTutorialIndex >= 8) {
                            NavigationLink(destination:
                                            MachineView())
                            {
                                CustomBoldText(text: "Machine", textSize: 20, color: Colors.primary)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Colors.primary)
                                    .fontWeight(.bold)
                            }
                        } else {
                            Group {
                                CustomBoldText(text: "Next", textSize: 20, color: Colors.primary)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Colors.primary)
                                    .fontWeight(.bold)
                                
                            }.onTapGesture {
                                nextIndice()
                            }
                        }
                        
                        
                    }.padding()
                        .padding(.bottom, 36)
                    
                }.padding()
                    .navigationBarBackButtonHidden()
            }.background(.white)
        }
    }
    
    func nextIndice() {
        if(currentTutorialIndex >= 9) {
            currentTutorialIndex = 9
        } else {
            currentTutorialIndex+=1
            text = tutorials[currentTutorialIndex].text
            imageName = tutorials[currentTutorialIndex].imageName
            invertBalloon = tutorials[currentTutorialIndex].invertBalloon
        }
        
    }
    
    func backIndice() {
        if(currentTutorialIndex <= 0) {
            currentTutorialIndex = 0
        } else {
            currentTutorialIndex-=1
        }
        text = tutorials[currentTutorialIndex].text
        imageName = tutorials[currentTutorialIndex].imageName
        invertBalloon = tutorials[currentTutorialIndex].invertBalloon
    }
}

struct Tutorial {
    let text: String
    let imageName: String
    let invertBalloon: Bool
}

#Preview {
    TutorialView()
}
