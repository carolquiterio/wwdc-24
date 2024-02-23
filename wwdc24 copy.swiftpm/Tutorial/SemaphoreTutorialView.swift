//
//  SwiftUIView.swift
//
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct SemaphoreTutorialView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            CustomBackButton(
                action: {
                    dismiss()
                }
            )
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
            CustomButton(
                title: "Next",
                destinationView: SeccondTutorialView()
            )
            .padding()
            .navigationBarBackButtonHidden(true)
        }.background(.white)
    }
}

#Preview {
    SemaphoreTutorialView()
}
