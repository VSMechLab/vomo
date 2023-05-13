//
//  Graph.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/28/22.
//

import Foundation
import SwiftUI

struct Graph: View {
    
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var settings: Settings
    
    @State private var svm = SharedViewModel()
    
    var chartStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .BRIGHT_PURPLE), ColorGradient(.DARK_PURPLE, .DARK_PURPLE)])
    
    var hChartData = ChartData([("Recordings", 7.0), ("Questionnaire", 8.0), ("Journals", 10.0)])
    var lineChartData = ChartData()
    
    var body: some View {
        VStack {
            LineChart(index: .constant(1))
                .data(lineChartData.data)
                .chartStyle(chartStyle)
                .frame(width: svm.content_width, height: 250)
            
            //Text("Supporting information: \()")
            
            HBarChart(chartData: hChartData, style: chartStyle)
                .frame(width: svm.content_width, height: 250)
            
            .onAppear() {
                for week in settings.timelines {
                    lineChartData.data += [("\(week.start.shortDay())-\(week.end.shortDay())", surveysEntered(start: week.start, end: week.end))]
                }
            }
        }
    }
    
    /// Returns surveys recorded in a given time frame
    /// only accounts for vhi for now, vocal effort later
    func surveysEntered(start: Date, end: Date) -> Double {
        //var ret = 0.0
        let fakeData: [SurveyModel] = [
            SurveyModel(createdAt: .now, responses: [0, 1, 2, 3, 4, 5, 6, 7,  8, 9, 10, 22], favorite: false),
            SurveyModel(createdAt: .now, responses: [0, 1, 2, 3, 4, 5, 6, 7,  8, 9, 10, 22], favorite: false),
            SurveyModel(createdAt: .now, responses: [0, 1, 2, 3, 4, 5, 6, 7,  8, 9, 10, 22], favorite: false),
            SurveyModel(createdAt: .now, responses: [0, 1, 2, 3, 4, 5, 6, 7,  8, 9, 10, 22], favorite: false)
        ]
        
//        for _ in fakeData {
//            print("worth")
//        }
        
        return 1.0
        
        /*
        for survey in entries.questionnaires {
            if survey.createdAt > start.startOfDay && survey.createdAt < end.endOfDay {
                ret += 1
            }
        }
        return ret
        */
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph()
            .environmentObject(Settings())
            .environmentObject(Entries())
            .frame(width: 325.0, height: 300)
    }
}
