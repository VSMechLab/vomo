//
//  HBarChartCell.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/30/22.
//

import SwiftUI

/// A single vertical bar in a `BarChart`
public struct HBarChartCell: View {
    var value: Double
    var index: Int = 0
    var gradientColor: ColorGradient
    var touchLocation: CGFloat
    var fullValue: Double
    var label: String

    @State private var didCellAppear: Bool = false

    public init( value: Double,
                 index: Int = 0,
                 gradientColor: ColorGradient,
                 touchLocation: CGFloat,
                 fullValue: Double,
                 label: String) {
        self.value = value
        self.index = index
        self.gradientColor = gradientColor
        self.touchLocation = touchLocation
        self.fullValue = fullValue
        self.label = label
    }

    /// The content and behavior of the `BarChartCell`.
    ///
    /// Animated when first displayed, using the `firstDisplay` variable, with an increasing delay through the data set.
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(label)
                        .foregroundColor(Color.white)
                        .font(Font._barLabelBold)
                        //.padding(.leading, 3)
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.40)
                
                HBarChartCellShape(value: didCellAppear ? value : 0.0)
                    .fill(gradientColor.linearGradient(from: .leading, to: .trailing))
                    .onAppear {
                        self.didCellAppear = true
                    }
                    .onDisappear {
                        self.didCellAppear = false
                    }
                    .transition(.slide)
                    .animation(Animation.spring().delay(self.touchLocation < 0 || !didCellAppear ? Double(self.index) * 0.04 : 0), value: 1.0)
                    .padding(.trailing, 3)
                    .frame(width: geometry.size.width * 0.45)
                
                HStack {
                    Spacer()
                    Text("\(fullValue, specifier: "%.0f")%")
                        .foregroundColor(Color.white)
                }
                .frame(width: geometry.size.width * 0.15)
            }
            
            
            
            
            
            
            
            
            /*
             GeometryReader { geometry in
                 VStack(spacing: 0) {
                     Spacer()
                     
                     HStack {
                         Text("\(label): \(fullValue, specifier: "%.0f")")
                             .foregroundColor(Color.white)
                             .font(Font._barLabelBold)
                             .padding(.leading, 3)
                         Spacer()
                     }
                     .frame(width: geometry.size.width * (value))
                     /*
                     ZStack {
                         Color.clear
                     }
                     */
                     
                     Spacer()
                 }
                 .frame(width: geometry.size.width * (value))
             }
             */
            
        }
    }
}

struct HBarChartCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                HBarChartCell(value: 0.75, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat(), fullValue: 0.4, label: "Surveys")
                    .background(Color.HEADLINE_COPY)

                HBarChartCell(value: 0.5, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat(), fullValue: 1.7, label: "Surveys")
                    .background(Color.HEADLINE_COPY)
                HBarChartCell(value: 0.75, gradientColor: ColorGradient.whiteBlack, touchLocation: CGFloat(), fullValue: 1.9, label: "Surveys")
                    .background(Color.HEADLINE_COPY)
                HBarChartCell(value: 0.1, gradientColor: ColorGradient(.purple), touchLocation: CGFloat(), fullValue: 1.4, label: "Surveys")
                    .background(Color.HEADLINE_COPY)
            }

            Group {
                HBarChartCell(value: 0.1, gradientColor: ColorGradient.greenRed, touchLocation: CGFloat(), fullValue: 2.3, label: "Surveys")
                    .background(Color.HEADLINE_COPY)
                HBarChartCell(value: 0.1, gradientColor: ColorGradient.whiteBlack, touchLocation: CGFloat(), fullValue: 2.0, label: "Surveys")
                    .background(Color.HEADLINE_COPY)
                HBarChartCell(value: 0.1, gradientColor: ColorGradient(.purple), touchLocation: CGFloat(), fullValue: 2.0, label: "Surveys")
                    .background(Color.HEADLINE_COPY)
            }.environment(\.colorScheme, .dark)
        }
    }
}
