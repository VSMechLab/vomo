//
//  TabIcons.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/8/22.
//

import SwiftUI

struct TabIcons: ButtonStyle {
    let image: String
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            Spacer()
            Image(image)
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .padding(.top, -10)
            Spacer()
        }
    }
}
