//
//  LineChart.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/6/22.
//

import SwiftUI

/// A type of chart that displays a line connecting the data points
public struct LineChart: View, ChartBase {
    public var chartData = ChartData()

    @EnvironmentObject var data: ChartData
    @EnvironmentObject var style: ChartStyle

    @Binding var index: Int
    
    /// The content and behavior of the `LineChart`.
    ///
    ///
    public var body: some View {
        Line(chartData: data, style: style, index: self.$index, data: data)
    }
    /*
    public init(index: Int) {
        self.index = index
    }
    */
}
/*
struct LineChart_Previews: PreviewProvider {
    @State private var svm = SharedViewModel()
    static let chartData = ChartData([("Hello", 166.0), ("Testing", 220.5), ("Words", 2.9), ("Testing", 2.2)])
    //static let chartData = ChartData([6, 2, 5, 18, 6, 0, 4, 5, 5])
    static let chartStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .BRIGHT_PURPLE), ColorGradient(.DARK_PURPLE, .DARK_PURPLE)])
    
    @State private var index: Int = 0
    
    static var previews: some View {
        LineChart()
            .data([("geoo", 1.0)])
            .padding()
            .frame(width: 325.0, height: 300)
            .background(Color.BODY_COPY)
    }
}
 */
