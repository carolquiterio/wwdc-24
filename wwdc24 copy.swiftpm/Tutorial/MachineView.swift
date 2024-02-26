//
//  SwiftUIView.swift
//
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct MachineView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            CustomBoldText(
                text: "PLOFT, PLOFT, POW....",
                textSize: 24
            )
            .padding(.top)
            CustomText(
                text: "The ColorShaping machine is ready! Here, all tones of red - like pink and orange - are represented by circles and green by triangles.",
                textSize: 16
            )
                .padding()
            
            Spacer()
            
            AnimatedImageView(imageNames: generateImageNames(startIndex: 8, endIndex: 37, name: "MachineAnimation"), frameCount: 30, frameDuration: 0.2)
                .frame(maxWidth: 340)
            
            Spacer()
            
            CustomText(
                text: "Now is your turn to try the machine!",
                textSize: 16
            ).padding()
            CustomButton(
                title: "Try the machine",
                destinationView: ActionsView()
            ).padding()

        }.background(.white)
    }
}

#Preview {
    MachineView()
}
