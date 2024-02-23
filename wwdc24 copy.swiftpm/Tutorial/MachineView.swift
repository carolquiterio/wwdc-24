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
            CustomBackButton(
            action: {
                dismiss()
            })
            CustomText(
                text: "PLOFT, PLOFT, POW....",
                textSize: 24
            ).bold()
            .padding(.top)
            CustomText(
                text: "The ColorShaping machine is ready!",
                textSize: 16
            )
                .padding()
            
            Spacer()
            
            AnimatedImageView(imageNames: generateImageNames(startIndex: 8, endIndex: 37), frameCount: 30, frameDuration: 0.2)
            
            Spacer()
            
            CustomText(
                text: "Now is your turn to try the machine!",
                textSize: 16
            ).padding()
            CustomButton(
                title: "Try the machine",
                destinationView: ActionsView()
            ).padding()
            .navigationBarBackButtonHidden(true)
        }.background(.white)
    }
    
    func generateImageNames(startIndex: Int, endIndex: Int) -> [String] {
        var imageNames = [String]()
        for i in startIndex...endIndex {
            imageNames.append("MachineAnimation\(i)")
        }
        return imageNames
    }
}

#Preview {
    MachineView()
}
