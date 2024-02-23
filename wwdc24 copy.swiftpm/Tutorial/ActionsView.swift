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
            Spacer()
            
            Image("Machine")
                .resizable()
                .scaledToFit()
                .padding(.bottom, 22)
                .frame(maxWidth: 280)
            
            CustomButton(
                title: "Use example images",
                destinationView: ImageUploadView()
            ).padding()

            CustomButton(
                title: "Upload image from camera",
                destinationView: ImageUploadView()
            ).padding()
            
            CustomButton(
                title: "Use live camera",
                destinationView: ImageUploadView()
            ).padding(.horizontal)
                .padding(.top)
            
            CustomText(
                text: "To use live camera you need to be using a physical device.",
                textSize: 16
            )
            .padding()
            .navigationBarBackButtonHidden(true)
        }.background(.white)
    }
}

#Preview {
    ActionsView()
}
