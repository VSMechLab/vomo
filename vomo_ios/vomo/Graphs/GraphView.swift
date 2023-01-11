//
//  GraphView.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/26/22.
//

import SwiftUI

struct GraphView: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var settings: Settings
    
    @Binding var showVHI: Bool
    @Binding var showVE: Bool
    
    @State private var hChartData = ChartData([("Recordings", 7.0), ("Surveys", 10.0), ("Journals", 10.0)])
    @State private var vhiData = ChartData()
    @State private var veData = ChartData()
    static let vhiStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.BRIGHT_PURPLE, .BRIGHT_PURPLE), ColorGradient(.clear, .clear)])
    static let veStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .TEAL), ColorGradient(.TEAL, .DARK_PURPLE)])
    static let chartStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .DARK_PURPLE)])
    @State private var index1 = 0
    @State private var index2 = 0
    let svm = SharedViewModel()
    let index: Int
    var body: some View {
        VStack {
            if index == 0 {
                ZStack {
                    HBarChart(chartData: hChartData, style: GraphView.chartStyle)
                    Color.gray.opacity(0.00001)
                }
                .frame(width: svm.content_width, height: 145)
            } else if index == 4 && settings.surveyEntered != 0 {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("50")
                        Spacer()
                        Text("0")
                    }
                    .font(._bodyCopy)
                    .foregroundColor(Color.white)
                    .frame(width: svm.content_width * 0.05, height: 155)
                    VStack(spacing: 0) {
                        ZStack {
                            if self.showVHI {
                                VStack {
                                    Spacer()
                                    /// VHI
                                    LineChart(index: $index1)
                                        .data(vhiData.data)
                                        .chartStyle(GraphView.vhiStyle)
                                        .onAppear() {
                                            print("VHI: \(vhiData.data)")
                                        }
                                }
                            }
                            if self.showVE {
                                VStack {
                                    Spacer()
                                    /// VE
                                    LineChart(index: $index2)
                                        .data(veData.data)
                                        .chartStyle(GraphView.veStyle)
                                        .onAppear() {
                                            print("VE: \(veData.data)")
                                        }
                                }
                            }
                        }
                        .onAppear() {
                            print("vhi: \(showVHI)")
                            print("ve: \(showVE)")
                        }
                        .frame(width: svm.content_width * 0.95, height: 155)
                    }
                }
               } else if index == 4 {
                Text("Log a goal for surveys and record some to see metrics about surveys you take")
                    .foregroundColor(Color.white)
                    .font(._bodyCopy)
                Spacer()
               }
        }
        .onAppear() {
            self.vhiData.data = vhiSurveyScores
            self.veData.data = veSurveyScores
            self.hChartData = ChartData([("Recordings", settings.recordProgress), ("Surveys", settings.surveyProgress), ("Journals", settings.journalProgress)])
        }
    }
    
    /// Returns surveys recorded in a given time frame
    /// vhi only
    var vhiSurveyScores: [(String, Double)] {
        var ret: [(String, Double)] = []
        
        for survey in entries.questionnaires {
            if survey.score.0 != -1 {
                ret += [("\(survey.createdAt)", survey.score.0 / 40)]
            }
        }
        return ret
    }
    
    /// Returns surveys recorded in a given time frame
    /// ve only
    var veSurveyScores: [(String, Double)] {
        var ret: [(String, Double)] = []
        
        for survey in entries.questionnaires {
            if survey.score.1 != -1 {
                ret += [("\(survey.createdAt)", survey.score.1 / 50)]
            }
        }
        return ret
    }
}
/*
struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
*/
