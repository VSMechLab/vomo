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
