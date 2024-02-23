//
//  File.swift
//  
//
//  Created by Carol Quiterio on 22/02/24.
//

import SwiftUI

struct InitialView<Destination: View>: View {
    let destination: Destination
    
    var body: some View {
        VStack {
            Spacer()
            TextBalloon(text: "Hey! HEEEY! Over here! Nice to meet you! My name is Green, and this is Red. We're here to talk to you about color blindness!", invertBalloon: false)
                .frame(maxWidth: 380)
            
            Image("Shapes")
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 380)
            Spacer()
            CustomButton(
                title: "Start",
                destinationView: destination
            )
            .navigationBarBackButtonHidden(true)
            .padding()
        }.background(.white)
    }
}
