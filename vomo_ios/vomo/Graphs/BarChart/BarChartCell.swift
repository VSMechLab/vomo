//
//  BarChartCell.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/9/22.
//

import SwiftUI

/// A single vertical bar in a `BarChart`
public struct BarChartCell: View {
    var value: Double
    var index: Int = 0
    var gradientColor: ColorGradient
    var touchLocation: CGFloat

    @State private var didCellAppear: Bool = false

    public init( value: Double,
                 index: Int = 0,
                 gradientColor: ColorGradient,
                 touchLocation: CGFloat) {
        self.value = value
        self.index = index
        self.gradientColor = gradientColor
        self.touchLocation = touchLocation
    }

    /// The content and behavior of the `BarChartCell`.
    ///
    /// Animated when first displayed, using the `firstDisplay` variable, with an increasing delay through the data set.
    public var body: some View {
        BarChartCellShape(value: didCellAppear ? value : 0.0)
        .fill(gradientColor.linearGradient(from: .bottom, to: .top))        .onAppear {
            self.didCellAppear = true
        }
        .onDisappear {
            self.didCellAppear = false
        }
        .transition(.slide)
        .animation(Animation.spring().delay(self.touchLocation < 0 || !didCellAppear ? Double(self.index) * 0.04 : 0), value: 1.0)
    }
}

struct BarChartCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                BarChartCell(value: 0, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat())

                BarChartCell(value: 0.5, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat())
                BarChartCell(value: 0.75, gradientColor: ColorGradient.whiteBlack, touchLocation: CGFloat())
                BarChartCell(value: 1, gradientColor: ColorGradient(.purple), touchLocation: CGFloat())
            }

            Group {
                BarChartCell(value: 1, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat())
                BarChartCell(value: 1, gradientColor: ColorGradient.whiteBlack, touchLocation: CGFloat())
                BarChartCell(value: 1, gradientColor: ColorGradient(.purple), touchLocation: CGFloat())
            }.environment(\.colorScheme, .dark)
        }
    }
}
