//
//  BarChart.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/29/22.
//

import Foundation
import SwiftUI

struct BarChart: View {
    @State private var svm = SharedViewModel()
    @EnvironmentObject var chartValue: ChartValue
    @ObservedObject var chartData: ChartData
    @State private var touchLocation: CGFloat = -1.0

    var style: ChartStyle
    var label: String
    
    var maxValue: Double {
        guard let max = chartData.points.max() else {
            return 1
        }
        return max != 0 ? max : 1
    }

    /// The content and behavior of the `BarChartRow`.
    ///
    /// Shows each `BarChartCell` in an `HStack`; may be scaled up if it's the one currently being touched.
    /// Not using a drawing group for optimizing animation.
    /// As touched (dragged) the `touchLocation` is updated and the current value is highlighted.
    public var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom,
                   spacing: geometry.frame(in: .local).width / CGFloat(chartData.data.count * 3)) {
                ForEach(0..<chartData.data.count, id: \.self) { index in
                    VStack {
                        BarChartCell(value: chartData.normalisedPoints[index],
                                     index: index,
                                     gradientColor: self.style.foregroundColor.rotate(for: index),
                                     touchLocation: self.touchLocation, fullValue: chartData.points[index])
                            .scaleEffect(self.getScaleSize(touchLocation: self.touchLocation, index: index), anchor: .bottom)
                            .animation(Animation.easeInOut(duration: 0.2), value: 0.1)
                        Text(chartData.values[index])
                            .foregroundColor(Color.white)
                            .font(Font._day)
                            .lineLimit(1)
                    }
                }
            }
            .frame(maxHeight: chartData.isInNegativeDomain ? geometry.size.height / 2 : geometry.size.height)
            .gesture(DragGesture()
                .onChanged({ value in
                    let width = geometry.frame(in: .local).width
                    self.touchLocation = value.location.x/width
                    /*if let currentValue = self.getCurrentValue(width: width) {
                        self.chartValue.currentValue = currentValue
                        self.chartValue.interactionInProgress = true
                    }*/
                })
                .onEnded({ value in
                    /*
                    self.chartValue.interactionInProgress = false
                    self.touchLocation = -1
                    */
                })
            )
        }
    }

    /// Size to scale the touch indicator
    /// - Parameters:
    ///   - touchLocation: fraction of width where touch is happening
    ///   - index: index into data array
    /// - Returns: a scale larger than 1.0 if in bounds; 1.0 (unscaled) if not in bounds
    func getScaleSize(touchLocation: CGFloat, index: Int) -> CGSize {
        if touchLocation > CGFloat(index)/CGFloat(chartData.data.count) &&
           touchLocation < CGFloat(index+1)/CGFloat(chartData.data.count) {
            return CGSize(width: 1.1, height: 1.01)
        }
        return CGSize(width: 1, height: 1)
    }

    /// Get data value where touch happened
    /// - Parameter width: width of chart
    /// - Returns: value as `Double` if chart has data
    func getCurrentValue(width: CGFloat) -> Double? {
        guard self.chartData.data.count > 0 else { return nil}
        let index = max(0,min(self.chartData.data.count-1,Int(floor((self.touchLocation*width)/(width/CGFloat(self.chartData.data.count))))))
        return self.chartData.points[index]
    }
}

struct BarChart_Previews: PreviewProvider {
    @State private var svm = SharedViewModel()
    static let chartData = ChartData([("Hello", 166.0), ("Testing", 220.5), ("Words", 2.9), ("Testing", 2.2)])
    //static let chartData = ChartData([6, 2, 5, 18, 6, 0, 4, 5, 5])
    static let chartStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .BRIGHT_PURPLE), ColorGradient(.DARK_PURPLE, .DARK_PURPLE)])
    static var previews: some View {
        BarChart(chartData: chartData, style: chartStyle, label: "Weekly entries")
            .padding()
            .frame(width: 325.0, height: 300)
            .background(Color.BODY_COPY)
    }
}
