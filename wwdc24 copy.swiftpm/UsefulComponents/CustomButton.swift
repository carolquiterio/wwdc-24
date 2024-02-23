//
//  File.swift
//
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct CustomButton<Destination: View>: View {
    let title: String
    let destinationView: Destination
    
    var body: some View {
        NavigationLink (destination: destinationView)
        {
            HStack {
                CustomBoldText(
                    text: title,
                    textSize: 20,
                    color: .white
                )
            }
            .frame(maxWidth: .infinity, maxHeight: 30)
            .padding()
            .background(Colors.primary)
            .cornerRadius(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 2)
                    .offset(x: -6, y: 10)
            )
        }
    }
}


struct CustomButtonWithAction: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
                HStack { 
                    CustomText(
                        text: title,
                        textSize: 20,
                        color: .white
                    ).bold()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 30)
                .padding()
                .background(Colors.primary)
                .cornerRadius(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 2)
                        .offset(x: -6, y: 10)
                )
        }
    }
}
