//
//  IndicatorPoint.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/6/22.
//

import SwiftUI

/// A dot representing a single data point as user moves finger over line in `LineChart`
struct IndicatorPoint: View {
    /// The content and behavior of the `IndicatorPoint`.
    ///
    /// A filled circle with a thick white outline and a shadow
    public var body: some View {
        ZStack {
            Color.white.frame(width:5, height: 5)
            
            //Circle()
                //.fill(ChartColors.indicatorKnob)
            Circle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 4))
                .frame(width: 6, height: 6)
        }
        //.shadow(color: ChartColors.legendColor, radius: 2, x: 0, y: 1)
    }
}

struct IndicatorPoint_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPoint()
    }
}
