//
//  SwiftUIView.swift
//
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct TextBalloon: View {
    let text: String
    let invertBalloon: Bool
    
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
                )
                
        }
    }
}
