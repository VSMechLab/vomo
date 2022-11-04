//
//  ProgressBar.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/1/22.
//

import SwiftUI

struct ProgressBar: View {
    var level: Double
    var color: Color
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .foregroundColor(Color.gray)
                    .opacity(0.10)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress(), 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: 1)
                    .opacity(0.90)
            }.frame(width: 110, height: 110, alignment: .center)
        }
    }
    
    func progress() -> CGFloat {
        return CGFloat(CGFloat(level) / CGFloat(100))
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(level: 1, color: Color.TEAL)
    }
}
