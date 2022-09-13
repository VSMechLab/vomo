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
    var fullValue: Double

    @State private var didCellAppear: Bool = false

    public init( value: Double,
                 index: Int = 0,
                 gradientColor: ColorGradient,
                 touchLocation: CGFloat,
                 fullValue: Double) {
        self.value = value
        self.index = index
        self.gradientColor = gradientColor
        self.touchLocation = touchLocation
        self.fullValue = fullValue
    }

    /// The content and behavior of the `BarChartCell`.
    ///
    /// Animated when first displayed, using the `firstDisplay` variable, with an increasing delay through the data set.
    public var body: some View {
        ZStack {
            BarChartCellShape(value: didCellAppear ? value : 0.0)
                .fill(gradientColor.linearGradient(from: .bottom, to: .top))
                .onAppear {
                    self.didCellAppear = true
                }
                .onDisappear {
                    self.didCellAppear = false
                }
                .transition(.slide)
                .animation(Animation.spring().delay(self.touchLocation < 0 || !didCellAppear ? Double(self.index) * 0.04 : 0), value: 1.0)
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer()
                    
                    ZStack {
                        Color.clear
                        
                        VStack {
                            Text("\(fullValue, specifier: "%.0f")")
                                .foregroundColor(Color.white)
                                .font(Font._BTNCopyUnbold)
                            Spacer()
                        }
                    }
                    .frame(height: geometry.size.height * (value))
                }
                .frame(height: geometry.size.height)
            }
        }
    }
}

struct BarChartCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                BarChartCell(value: 0.75, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat(), fullValue: 0.4)

                BarChartCell(value: 0.5, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat(), fullValue: 1.7)
                BarChartCell(value: 0.75, gradientColor: ColorGradient.whiteBlack, touchLocation: CGFloat(), fullValue: 1.9)
                BarChartCell(value: 0.1, gradientColor: ColorGradient(.purple), touchLocation: CGFloat(), fullValue: 1.4)
            }

            Group {
                BarChartCell(value: 0.1, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat(), fullValue: 2.3)
                BarChartCell(value: 0.1, gradientColor: ColorGradient.whiteBlack, touchLocation: CGFloat(), fullValue: 2.0)
                BarChartCell(value: 0.1, gradientColor: ColorGradient(.purple), touchLocation: CGFloat(), fullValue: 2.0)
            }.environment(\.colorScheme, .dark)
        }
    }
}
