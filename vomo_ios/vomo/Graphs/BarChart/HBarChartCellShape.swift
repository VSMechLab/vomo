//
//  HBarChartCellShape.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/30/22.
//

import SwiftUI

struct HBarChartCellShape: Shape, Animatable {
    var value: Double
    var cornerRadius: CGFloat = 6.0
    var animatableData: CGFloat {
        get { CGFloat(value) }
        set { value = Double(newValue) }
    }

    func path(in rect: CGRect) -> Path {
        let adjustedOriginX = rect.width * CGFloat(value)
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: adjustedOriginX, y: 0))
        path.addArc(center: CGPoint(x: adjustedOriginX, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(radians: -Double.pi/2),
                    endAngle: Angle(radians: 0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: adjustedOriginX + cornerRadius, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: adjustedOriginX, y: rect.height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(radians: 0),
                    endAngle: Angle(radians: Double.pi/2),
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        
        /*
        let adjustedOriginY = rect.height - (rect.height * CGFloat(value))
        var path = Path()
        path.move(to: CGPoint(x: 0.0 , y: rect.height))
        path.addLine(to: CGPoint(x: 0.0, y: adjustedOriginY + cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: adjustedOriginY +  cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(radians: Double.pi),
                    endAngle: Angle(radians: -Double.pi/2),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: adjustedOriginY))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: adjustedOriginY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(radians: -Double.pi/2),
                    endAngle: Angle(radians: 0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
         */
        return path
    }
}

struct HBarChartCellShape_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            VStack {
                Text("1000")
                HStack {
                    Text("1000")
                    HBarChartCellShape(value: 0.7)
                        .fill(Color.brown)
                        .padding()
                    Text("0")
                }
                Text("0")
            }
            
            HBarChartCellShape(value: 0.3)
                .fill(Color.blue)
                .padding()

        }
    }
}
