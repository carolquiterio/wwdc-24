//
//  SwiftUIView.swift
//  
//
//  Created by Carol Quiterio on 25/02/24.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            CustomBoldText(text: "História", textSize: 16)
            CustomText(text: "Shaping integrates accessibility, technology, and iOS to help individuals, like my grandmother, in distinguishing colors.", textSize: 16).padding(.bottom)
            
            CustomBoldText(text: "Autor", textSize: 16)
            CustomText(text: "Shaping was made with love by me, Carol, a Brazilian student in Campinas who loves accessibility and colors <3.", textSize: 16)
                .padding(.bottom)
            CustomBoldText(text: "Technology", textSize: 16)
            CustomText(text: "Shapping was made with SwiftUI, Metal and UIKit.", textSize: 16)
                .padding(.bottom)
            CustomBoldText(text: "Goals", textSize: 16)
            CustomText(text: "Shaping goal is to help color blind people around the world in their daily lives.", textSize: 16)
            Spacer()
                
        }
        .padding()
        .background(.white)
        .navigationBarTitleDisplayMode(.inline).navigationTitle("About the app")
    }
}

#Preview {
    CreditsView()
}
