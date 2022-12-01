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
                    .padding(.vertical, 5)
                    .padding(.horizontal, 3.75)
                    .foregroundColor(Color.black)
                    .background(cur == index ? Color.white : Color.clear)
                    .cornerRadius(10)
            }
        }
        .background(Color.INPUT_FIELDS)
        .cornerRadius(10)
    }
}

struct GraphicTitle_Previews: PreviewProvider {
    static var previews: some View {
        GraphicTitle(index: 0, title: "title")
    }
}
