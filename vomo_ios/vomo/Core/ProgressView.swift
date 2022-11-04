//
//  ProgressView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI
import Foundation

struct ProgressView: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    @State private var chartData = ChartData()
    @State private var hChartData = ChartData([("Recordings", 7.0), ("Surveys", 10.0), ("Journals", 10.0)])
    @State private var filteredList: [Element] = []
    @State private var showFilter = false
    @State private var filters: [String] = []
    @State private var toggle = 0
    let backColor = [Color.BLUE, Color.BRIGHT_PURPLE, Color.BLUE, Color.BRIGHT_PURPLE, Color.BLUE]
    let foreColor = [Color.TEAL, Color.DARK_PURPLE, Color.DARK_BLUE, Color.DARK_PURPLE, Color.DARK_BLUE]
    let title = ["Summary", "Pitch", "Duration", "Quality", "Survey"]
    let svm = SharedViewModel()
    
    static let chartStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .DARK_PURPLE)])
    
    var vhiData = ChartData()
    var veData = ChartData()
    static let vhiStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.BRIGHT_PURPLE, .BRIGHT_PURPLE), ColorGradient(.clear, .clear)])
    static let veStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .TEAL), ColorGradient(.TEAL, .DARK_PURPLE)])
    
    @State private var index1 = 0
    @State private var index2 = 0
    
    @State private var pitchPopUp = false
    @State private var durationPopUp = false
    @State private var qualityPopUp = false
    
    @State private var reset = false
    
    var body: some View {
        ZStack {
            VStack {
                graphSection
                
                if showFilter {
                    VStack(spacing: 0) {
                        Filter(filters: $filters, showFilter: $showFilter)
                            .frame(height: UIScreen.main.bounds.height * 0.4)
                        Spacer()
                    }.transition(.slide)
                } else {
                    bodySection
                }
                Spacer()
            }
            .frame(width: svm.content_width)
            .onAppear() {
                refilter()
                self.hChartData = ChartData([("Recordings", settings.recordProgress), ("Surveys", settings.surveyProgress), ("Journals", settings.journalProgress)])
                
                self.vhiData.data = vhiSurveyScores
                self.veData.data = veSurveyScores
                
                /// test to see if data appears for vhi & ve surveys
                //print("VHI Data: \(vhiSurveyScores)\nVE Data: \(veSurveyScores)")
            }
            .onChange(of: reset) { _ in
                refilter()
                self.reset = false
            }
            if pitchPopUp && settings.pitchThreshold.count != 0 {
                SetThreshold(popUp: $pitchPopUp, selection: $settings.pitchThreshold[0], min: $settings.pitchThreshold[1], max: $settings.pitchThreshold[2])
            } else if durationPopUp && settings.durationThreshold.count != 0 {
                SetThreshold(popUp: $durationPopUp, selection: $settings.durationThreshold[0], min: $settings.durationThreshold[1], max: $settings.durationThreshold[2])
            } else if qualityPopUp && settings.qualityThreshold.count != 0 {
                SetThreshold(popUp: $qualityPopUp, selection: $settings.qualityThreshold[0], min: $settings.qualityThreshold[1], max: $settings.qualityThreshold[2])
            }
        }
        .onAppear() {
            if settings.pitchThreshold.count == 0 {
                settings.pitchThreshold = [0, 0, 0, 0]
            }
            if settings.durationThreshold.count == 0 {
                settings.durationThreshold = [0, 0, 0, 0]
            }
            if settings.qualityThreshold.count == 0 {
                settings.qualityThreshold = [0, 0, 0, 0]
            }
        }
        .onChange(of: showFilter) { _ in
            refilter()
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

/// Views
extension ProgressView {
    private var graphSection: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack(spacing: 0) {
                    ForEach(0..<5) { index in
                        Button(action: {
                            withAnimation() {
                                toggle = index
                            }
                        }) {
                            Text(title[index])
                                .font(Font._tabTitle)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 2.5)
                                .foregroundColor(Color.black)
                                .background(toggle == index ? Color.white : Color.clear)
                                .cornerRadius(10)
                        }
                    }
                }
                .background(Color.INPUT_FIELDS)
                .cornerRadius(10)
                
                Spacer()
                
                Button(action: {
                    viewRouter.currentPage = .settings
                }) {
                    Image(svm.home_settings_img)
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }
            HStack {
                Text(title[toggle])
                    .font(Font._title1)
                    .foregroundColor(foreColor[toggle])
                
                if toggle == 0 {
                    Spacer()
                    Text("Weekly Goal")
                        .foregroundColor(Color.white)
                        .font(._bodyCopyMedium)
                } else if toggle == 1 {
                    Spacer()
                    Button("Set Threshold") {
                        self.pitchPopUp.toggle()
                    }
                    .foregroundColor(Color.white)
                    .font(._bodyCopyMedium)
                } else if toggle == 2 {
                    Spacer()
                    Button("Set Threshold") {
                        self.durationPopUp.toggle()
                    }
                    .foregroundColor(Color.white)
                    .font(._bodyCopyMedium)
                } else if toggle == 3 {
                    Spacer()
                    Button("Set Threshold") {
                        self.qualityPopUp.toggle()
                    }
                    .foregroundColor(Color.white)
                    .font(._bodyCopyMedium)
                } else if toggle == 4 {
                    Spacer()
                    HStack(spacing: 0) {
                        VStack(alignment: .trailing) {
                            Text("VHI ").font(._bodyCopy).foregroundColor(Color.BRIGHT_PURPLE)
                            Text("Vocal Effort ").font(._bodyCopy).foregroundColor(Color.TEAL)
                        }
                    }
                }
            }
            
            
            if toggle == 0 {
                HBarChart(chartData: hChartData, style: ProgressView.chartStyle)
                    .frame(width: svm.content_width, height: 145)
            }
            
            if toggle == 4 && settings.surveyEntered != 0 {
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
                            VStack {
                                Spacer()
                                /// VHI
                                LineChart(index: $index1)
                                    .data(vhiData.data)
                                    .chartStyle(ProgressView.vhiStyle)
                            }
                            VStack {
                                Spacer()
                                /// VE
                                LineChart(index: $index2)
                                    .data(veData.data)
                                    .chartStyle(ProgressView.veStyle)
                            }
                                
                        }.frame(width: svm.content_width * 0.95, height: 155)
                    }
                }
            } else if toggle == 4 {
                Text("Log a goal for surveys and record some to see metrics about surveys you take")
                    .foregroundColor(Color.white)
                    .font(._bodyCopy)
                Spacer()
            }
            
            Spacer()
            
            HStack (spacing: 5) {
                Spacer()
                ForEach(0..<5) { index in
                    Button(action: {
                        withAnimation() {
                            toggle = index
                            self.pitchPopUp = false
                            self.qualityPopUp = false
                            self.durationPopUp = false
                        }
                    }) {
                        Circle()
                            .frame(width: 8.5, height: 8.5)
                            .padding(7.5)
                            .foregroundColor(toggle == index ?
                                             foreColor[toggle] : Color.INPUT_FIELDS)
                            .padding(.bottom, 4)
                    }
                }
                Spacer()
            }
            .padding(5)
        }
        .transition(.opacity)
        .frame(width: svm.content_width)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(backColor[toggle])
    }
    
    private var bodySection: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Last week")
                    .font(._title1)
                Spacer()
                Button(action: {
                    self.showFilter.toggle()
                }) {
                    FilterButton()
                }
            }
            
            if filters.count != 0 {
                HStack {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            delete(element: filter)
                            refilter()
                        }) {
                            HStack {
                                Text(filter)
                                    .font(._CTALink)
                                Image(svm.exit_button)
                                    .resizable()
                                    .frame(width: 7.5, height: 7.5)
                                    .padding(.leading, 2)
                            }
                            .padding(2.5)
                            .background(Color.INPUT_FIELDS)
                        }
                    }
                    
                    Button(action: {
                        filters.removeAll()
                        refilter()
                    }) {
                        Text("Clear All")
                            .font(._CTALink)
                            .underline()
                    }
                    
                    Spacer()
                }
            }
            
            ScrollView(showsIndicators: false) {
                if filters.isEmpty {
                    if !filteredList.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(filteredList.reversed(), id: \.self) { item in
                                Color.BODY_COPY.frame(height: 1).opacity(0.6)
                                ListItem(element: item, reset: $reset)
                            }
                        }
                    }
                } else {
                    if !filteredList.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(filteredList.reversed(), id: \.self) { item in
                                Color.BODY_COPY.frame(height: 1).opacity(0.6)
                                ExpandedListItem(element: item, reset: $reset)
                            }
                        }
                    }
                }
            }
        }
        .frame(width: svm.content_width)
    }
}

/// Functions
extension ProgressView {
    /*
    func startDate() -> Date {
        let start: Date = Date(timeInterval: 0, since: startDate.toDate() ?? .now)
        return start as! Date
    }
    */
    
    func refilter() {
        print("Refiltering")
        entries.getItems()
        print(filters)
        
        if filters.isEmpty {
            filteredList = []
            var usedDates: [String] = []
            for index in 0..<audioRecorder.recordings.count {
                usedDates.append(audioRecorder.recordings[index].createdAt.toDay())
            }
            for index in 0..<entries.questionnaires.count {
                usedDates.append(entries.questionnaires[index].createdAt.toDay())
            }
            for index in 0..<entries.journals.count {
                usedDates.append(entries.journals[index].createdAt.toDay())
            }
            usedDates = usedDates.uniqued()
            
            for day in usedDates {
                var date: Date = .now
                var strs: [String] = []
                var preciseDates: [Date] = []
                
                for audio in audioRecorder.recordings {
                    if day == audio.createdAt.toDay() {
                        if filters.isEmpty || filters.contains(audioRecorder.taskNum(file: audio.fileURL)) {
                            strs.append(audioRecorder.viewableTask(file: audio.fileURL))
                            preciseDates.append(audio.createdAt)
                            date = audio.createdAt
                        }
                    }
                }
                for quest in entries.questionnaires {
                    if day == quest.createdAt.toDay() {
                        if filters.isEmpty || filters.contains("Survey") {
                            strs.append("Survey")
                            preciseDates.append(quest.createdAt)
                            date = quest.createdAt
                        }
                    }
                }
                for journ in entries.journals {
                    if day == journ.createdAt.toDay() {
                        if filters.isEmpty || filters.contains("Journal") {
                            strs.append("Journal")
                            preciseDates.append(journ.createdAt)
                            date = journ.createdAt
                        }
                    }
                }
                
                if strs.count > 0 {
                    filteredList.append(Element(date: date, preciseDate: preciseDates, str: strs))
                }
                date = .now
                strs.removeAll()
            }
        } else {
            print("showing filtered list")
            filteredList = []
            var usedDates: [String] = []
            for index in 0..<audioRecorder.recordings.count {
                if filters.contains("vowel") && audioRecorder.taskNum(selection: 1, file: audioRecorder.recordings[index].fileURL) {
                    usedDates.append(audioRecorder.recordings[index].createdAt.toDay())
                }
                if filters.contains("mpt") && audioRecorder.taskNum(selection: 2, file: audioRecorder.recordings[index].fileURL) {
                    usedDates.append(audioRecorder.recordings[index].createdAt.toDay())
                }
                if filters.contains("rainbow") && audioRecorder.taskNum(selection: 3, file: audioRecorder.recordings[index].fileURL) {
                    usedDates.append(audioRecorder.recordings[index].createdAt.toDay())
                }
                if filters.contains("Star") {
                    usedDates.append(audioRecorder.recordings[index].createdAt.toDay())
                }
            }
            for index in 0..<entries.questionnaires.count {
                usedDates.append(entries.questionnaires[index].createdAt.toDay())
            }
            for index in 0..<entries.journals.count {
                usedDates.append(entries.journals[index].createdAt.toDay())
            }
            usedDates = usedDates.uniqued()
            
            for day in usedDates {
                var date: Date = .now
                var strs: [String] = []
                var preciseDates: [Date] = []
                
                for audio in audioRecorder.recordings {
                    if day == audio.createdAt.toDay() {
                        if filters.contains(audioRecorder.taskNum(file: audio.fileURL)) {
                            strs.append(audioRecorder.viewableTask(file: audio.fileURL))
                            preciseDates.append(audio.createdAt)
                            date = audio.createdAt
                        } else if filters.contains("Star") {
                            print("level 1")
                            
                            for process in audioRecorder.processedData {
                                print("level 2")
                                if (process.createdAt == audio.createdAt) && process.star {
                                    
                                    print("level 3")
                                    
                                    strs.append(audioRecorder.viewableTask(file: audio.fileURL))
                                    preciseDates.append(audio.createdAt)
                                    date = audio.createdAt
                               }
                            }
                        }
                    }
                }
                for quest in entries.questionnaires {
                    if day == quest.createdAt.toDay() {
                        if filters.contains("Survey") || (filters.contains("Star") && quest.star) {
                            print(quest.createdAt)
                            strs.append("Survey")
                            preciseDates.append(quest.createdAt)
                            date = quest.createdAt
                        }
                    }
                }
                for journ in entries.journals {
                    if day == journ.createdAt.toDay() {
                        if (filters.contains("Journal") || journ.star ) || (filters.contains("Star") && journ.star) {
                            print(journ.star)
                            strs.append("Journal")
                            preciseDates.append(journ.createdAt)
                            date = journ.createdAt
                        }
                    }
                }
                
                if strs.count > 0 {
                    filteredList.append(Element(date: date, preciseDate: preciseDates, str: strs))
                }
                date = .now
                strs.removeAll()
            }
        }
    }
    
    func delete(element: String) {
        filters = filters.filter({ $0 != element })
    }
}

struct Element: Hashable {
    var date: Date
    var preciseDate: [Date]
    var str: [String]
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .environmentObject(AudioRecorder())
            .environmentObject(Entries())
            .environmentObject(ViewRouter())
            .environmentObject(Settings())
    }
}
