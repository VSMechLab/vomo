//
//  Color.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

extension Color {
    static let TEAL = Color(red: 0/255, green: 215/255, blue: 206/255)
    static let BLUE = Color(red: 40/255, green: 95/255, blue: 200/255)
    static var DARK_BLUE = Color(red: 50/255, green: 40/255, blue: 140/255)
    
    /// Purple colors
    static var BRIGHT_PURPLE = Color(red: 206/255, green: 206/255, blue: 234/255)
    static var MEDIUM_PURPLE = Color(red: 165/255, green: 155/255, blue: 255/255)
    static var SEMI_DARK_PURPLE = Color(red: 135/255, green: 235/255, blue: 225/255)
    static var DARK_PURPLE = Color(red: 128/255, green: 127/255, blue: 196/255)
    
    /// Darkest Gray
    static var HEADLINE_COPY = Color(red: 35/255, green: 35/255, blue: 35/255)
    /// Medium Gray
    static var BODY_COPY = Color(red: 125/255, green: 125/255, blue: 125/255)
    /// Lightest Gray
    static var INPUT_FIELDS = Color(red: 235/255, green: 235/255, blue: 235/255)
}

struct ColorView: View {
    var body: some View {
        VStack(spacing: 1) {
            Color.BRIGHT_PURPLE
            Color.TEAL
            Color.BLUE
            Color.DARK_BLUE
            Color.HEADLINE_COPY
            Color.BODY_COPY
            Color.gray
            Color.INPUT_FIELDS
            Color.DARK_PURPLE
        }
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView()
    }
}
