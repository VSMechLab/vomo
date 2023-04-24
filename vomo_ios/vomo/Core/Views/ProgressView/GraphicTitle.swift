//
//  GraphicTitle.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

struct GraphicTitle: View {
    let titles = ["Summary", "Pitch", "Duration", "Quality", "Survey"]
    let index: Int
    let title: String
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { cur in
                Text(titles[cur])
                    .font(cur == index ? Font._tabTitleBold : Font._tabTitle)
                    .padding(.vertical, 2.25)
                    .padding(.horizontal, 5.75)
                    .foregroundColor(Color.black)
                    .background(cur == index ? Color.white : Color.clear)
                    .cornerRadius(10)
            }
        }
        .background(Color.INPUT_FIELDS.opacity(0.9))
        .cornerRadius(10)
    }
}

struct GraphicTitle_Previews: PreviewProvider {
    static var previews: some View {
        GraphicTitle(index: 0, title: "title")
    }
}
