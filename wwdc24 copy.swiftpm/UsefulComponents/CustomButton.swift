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
                    textSize: 18,
                    color: .white
                )
            }
            .frame(maxWidth: 285, maxHeight: 30)
            .padding()
            .background(Colors.primary)
            .cornerRadius(40)
        }.buttonStyle(PlainButtonStyle())
    }
}
