//
//  Color.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

extension Color {
    static var BRIGHT_PURPLE = Color(red: 165/255, green: 155/255, blue: 255/255)
    static let TEAL = Color(red: 110/255, green: 255/255, blue: 230/255)
    static let BLUE = Color(red: 40/255, green: 95/255, blue: 200/255)
    static var DARK_BLUE = Color(red: 50/255, green: 40/255, blue: 140/255)
    static var HEADLINE_COPY = Color(red: 35/255, green: 35/255, blue: 35/255)
    static var BODY_COPY = Color(red: 125/255, green: 125/255, blue: 125/255)
    static var INPUT_FIELDS = Color(red: 235/255, green: 235/255, blue: 235/255)
    static var DARK_PURPLE = Color(red: 135/255, green: 130/255, blue: 225/255)
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
