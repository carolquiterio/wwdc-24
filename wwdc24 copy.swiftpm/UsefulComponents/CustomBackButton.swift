//
//  SwiftUIView.swift
//
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct CustomBackButton : View {
    let action: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                Button {
                    action()
                } label: {
                    HStack (alignment: .center, content: {
                        CustomText(
                            text: "Back",
                            textSize: 16,
                            color: .white
                        ).bold()
                    })
                    .frame(maxWidth: 100, maxHeight: 30)
                    .padding()
                    .background(Colors.primary)
                    .cornerRadius(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.black, lineWidth: 2)
                            .offset(x: 4, y: -8)
                    )
                    .offset(CGSize(width: -20.0, height: 16.0))
                }
                Spacer()
            }
        }
    }
}

struct CustomBackButtonWithNavigation<DestinationView: View> : View {
    let destination: DestinationView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                HStack {
                    HStack (alignment: .center, content: {
                        CustomText(
                            text: "Back",
                            textSize: 16,
                            color: .white
                        ).bold()
                    })
                    .frame(maxWidth: 100, maxHeight: 30)
                    .padding()
                    .background(Colors.primary)
                    .cornerRadius(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.black, lineWidth: 2)
                            .offset(x: 4, y: -8)
                    )
                    .offset(CGSize(width: -20.0, height: 0.0))
                }
                Spacer()
            }
        }
    }
}
