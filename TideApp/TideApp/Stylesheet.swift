//
//  Stylesheet.swift
//  TideApp
//
//  Created by Sophie Clark on 29/04/2021.
//

import Foundation
import SwiftUI

extension Color {
    /// Custom initialiser to create colors using hex codes
    ///
    /// - Parameter hex: An int value whoch should be a hexadecimal. An example is `0x052F5F`
    init(hex: Int) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}

extension Color {
    static var prussianBlue: Color {
        return Color(hex: 0x052F5F)
    }
    
    static var blueSapphire: Color {
        return Color(hex: 0x005377)
    }
    
    static var honeyYellow: Color {
        return Color(hex: 0xFFB30F)
    }
    
    static var frenchSkyBlue: Color {
        return Color(hex: 0x65AFFF)
    }
    
    static var mintCream: Color {
        return Color(hex: 0xEBF5EE)
    }
}
