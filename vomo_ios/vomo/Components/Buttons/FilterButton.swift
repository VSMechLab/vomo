//
//  FilterButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 10/27/22.
//

import SwiftUI

struct FilterButton: View {
    var body: some View {
        Text("Filter")
            .foregroundColor(Color.BODY_COPY)
            .font(._CTALink)
            .padding(7)
            .background(Color.white)
            .cornerRadius(5)
            .padding(1)
            .background(Color.INPUT_FIELDS)
            .cornerRadius(5)
    }
}
