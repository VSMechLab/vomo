//
//  Graph.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/28/22.
//

import Foundation
import SwiftUI
/*
 
 Add hbar chart
 Add line chart
 
 Fix bar chart - scaling issues
    Algorithm that changes graph on the bases of spacing
    Changes size of text, hides certain texts if needed
 */
struct Graph: View {
    @EnvironmentObject var entries: Entries
    
    @State private var svm = SharedViewModel()
    
    var chartData = ChartData([("8/22/2022", 168.0)])
    var chartStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .BRIGHT_PURPLE), ColorGradient(.DARK_PURPLE, .DARK_PURPLE)])
    
    var hChartData = ChartData([("Recordings", 7.0), ("Questionnaire", 8.0), ("Journals", 10.0)])
    
    var body: some View {
        VStack {
            BarChart(chartData: chartData, style: chartStyle, label: "Recordings")
                .frame(width: svm.content_width, height: 250)
            
            HBarChart(chartData: hChartData, style: chartStyle)
                .frame(width: svm.content_width, height: 250)
            
            Button("Append") {
                chartData.data = entries.weeklyRecordings
            }
            .onAppear() {
                chartData.data = entries.weeklyRecordings
            }
        }
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph()
            .environmentObject(Entries())
            .frame(width: 325.0, height: 300)
    }
}
