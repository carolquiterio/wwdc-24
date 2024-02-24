//
//  File.swift
//  
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct CustomText: View {
    var text: String
    var textSize: CGFloat
    var color: Color = .black
    var padding: CGFloat = 1
    
    var body: some View {
        Text(text)
            .font(.custom("Poppins-Regular", size: textSize))
            .foregroundColor(color)
            .padding(.horizontal, padding)
            .multilineTextAlignment(.center)
        }
}

struct CustomBoldText: View {
    var text: String
    var textSize: CGFloat
    var color: Color = .black
    var padding: CGFloat = 1
    
    var body: some View {
        Text(text)
            .font(.custom("Poppins-Regular", size: textSize))
            .foregroundColor(color)
            .padding(.horizontal, padding)
            .multilineTextAlignment(.center)
            .fontWeight(.bold)
        }
}
