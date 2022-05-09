//
//  LineShape.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/6/22.
//

import SwiftUI

struct LineShape: Shape {
    var data: [Double]
    func path(in rect: CGRect) -> Path {
        let path = Path.quadCurvedPathWithPoints(points: data, step: CGPoint(x: 1.0, y: 1.0))
        return path
    }
}

struct LineShape_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeometryReader { geometry in
                LineShape(data: [0, 0.5, 0.8, 0.6, 1])
                    .transform(CGAffineTransform(scaleX: geometry.size.width / 4.0, y: geometry.size.height))
                    .stroke(Color.red)
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
            GeometryReader { geometry in
                LineShape(data: [0, -0.5, 0.8, -0.6, 1])
                    .transform(CGAffineTransform(scaleX: geometry.size.width / 4.0, y: geometry.size.height / 1.6))
                    .stroke(Color.blue)
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
}
