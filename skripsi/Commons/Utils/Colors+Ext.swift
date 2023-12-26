//
//  Colors+Ext.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import SwiftUI

extension Color {
    static let primaryColor100 = Color("Primary100")
    static let primaryColor20 = Color("Primary20")
    static let secondaryColor = Color("Secondary100")
    static let tertiaryColor = Color("Tertiary")
    static let quartenaryColor = Color("Quartenary")
    
    struct background {
        static let primary = Color("Background-primary")
        static let base = Color("Background-base")
    }
    
    struct text {
        static let primary100 = Color("Text-primary100")
        static let primary30 = Color("Text-primary30")
        static let white = Color("Text-white")
        static let green = Color("Text-green")
        static let black = Color("Text-black")
        static let titleWatch = Color("Text-title")
    }
    
    struct button {
        static let active = Color("Button-active")
        static let inactive = Color("Button-inactive")
    }
}
