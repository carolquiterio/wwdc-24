//
//  SwiftUIView.swift
//
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct CustomBackButton: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            CustomText(
                text: "Back",
                textSize: 16,
                color: Colors.primary
            ).onTapGesture {
                dismiss()
            }
        }.buttonStyle(PlainButtonStyle())
        
    }
}
