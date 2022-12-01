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

struct ExpandAllButton: View {
    @Binding var expandAll: Bool
    @Binding var reset: Bool
    var body: some View {
        Button(action: {
            self.expandAll.toggle()
            self.reset.toggle()
        }) {
            Text("Expand All")
                .foregroundColor(expandAll ? Color.white : Color.BODY_COPY)
                .font(._CTALink)
                .padding(7)
                .background(expandAll ? Color.BODY_COPY : Color.white)
                .cornerRadius(5)
                .padding(1)
                .background(Color.INPUT_FIELDS)
                .cornerRadius(5)
        }
    }
}
