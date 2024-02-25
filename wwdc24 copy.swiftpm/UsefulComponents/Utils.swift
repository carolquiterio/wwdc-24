//
//  File.swift
//  
//
//  Created by Carol Quiterio on 20/02/24.
//

import SwiftUI

struct Colors {
    static let primary = Color(red: 186/255, green: 82/255, blue: 251/255)
}

func generateImageNames(startIndex: Int, endIndex: Int, name: String) -> [String] {
    var imageNames = [String]()
    for i in startIndex...endIndex {
        imageNames.append("\(name)\(i)")
    }
    return imageNames
}
