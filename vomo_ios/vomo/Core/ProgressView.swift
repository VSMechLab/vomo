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
    let svm = SharedViewModel()
    
    @State private var filteredList: [Element] = []
    
    @State private var showFitler = false
    
    @State private var filters: [String] = []
    
    @State private var toggle = 0
    let backColor = [Color.BLUE, Color.BRIGHT_PURPLE, Color.BLUE, Color.BRIGHT_PURPLE, Color.BLUE]
    let foreColor = [Color.TEAL, Color.DARK_PURPLE, Color.DARK_BLUE, Color.DARK_PURPLE, Color.DARK_BLUE]
    let title = ["Summary", "Pitch", "Duration", "Quality", "Survey"]
    
    @State private var hChartData = ChartData([
        ("Recording", 7.0),
        ("Surveys", 10.0),
        ("Journals", 10.0)
    ])
    
    //static let chartData = ChartData([6, 2, 5, 18, 6, 0, 4, 5, 5])
    static let chartStyle = ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .BRIGHT_PURPLE), ColorGradient(.DARK_PURPLE, .DARK_PURPLE)])
    
    var body: some View {
        VStack {
            graphSection
            
            if showFitler {
                VStack(spacing: 0) {
                    filterMenu
                        .frame(height: UIScreen.main.bounds.height * 0.4)
                    Spacer()
                }.transition(.slide)
            } else {
                bodySection
            }
            
            //accessSection
            
            Spacer()
        }
        .frame(width: svm.content_width)
        .onAppear() {
            entries.getItems()
            
            self.hChartData = ChartData([
                ("Recording", settings.recordProgress()),
                ("Surveys", settings.questProgress()),
                ("Journals", settings.journalProgress())
            ])
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            print(audioRecorder.recordings[index].fileURL)
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        print("Deleting url here: \(urlsToDelete)")
        audioRecorder.deleteRecording(urlToDelete: urlsToDelete.last!)
    }
}

extension ProgressView {
    func totalEntries() -> Int {
        var count = 0
        for _ in audioRecorder.recordings { count += 1 }
        for _ in entries.journals { count += 1 }
        for _ in entries.questionnaires { count += 1 }
        return count
    }
    
    func refilter() {
        filteredList = []
        print(filteredList)
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
        print(usedDates)
        
        
        for day in usedDates {
            var strs: [String] = []
            var date: Date = .now
            
            for audio in audioRecorder.recordings {
                if day == audio.createdAt.toDay() {
                    if filters.isEmpty || filters.contains(audioRecorder.taskNum(file: audio.fileURL)) {
                        strs.append(audioRecorder.taskNum(file: audio.fileURL))
                        date = audio.createdAt
                    }
                }
            }
            for quest in entries.questionnaires {
                if day == quest.createdAt.toDay() {
                    if filters.isEmpty || filters.contains("surveys") {
                        strs.append("surveys")
                        date = quest.createdAt
                    }
                }
            }
            for journ in entries.journals {
                if day == journ.createdAt.toDay() {
                    if filters.isEmpty || filters.contains("journal") {
                        strs.append("journal")
                        date = journ.createdAt
                    }
                }
            }
            
            if strs.count > 0 {
                filteredList.append(Element(date: date, str: strs))
            }
            date = .now
            strs.removeAll()
        }
    }
    
    func delete(element: String) {
        filters = filters.filter({ $0 != element })
    }
    
    private var filterMenu: some View {
        VStack {
            Text("Filter")
                .foregroundColor(Color.BODY_COPY)
                .font(._CTALink)
            Text("\(totalEntries()) entries")
                .foregroundColor(Color.BODY_COPY)
                .font(._CTALink)
            
            Group {
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("vowel") {
                        delete(element: "vowel")
                    } else {
                        self.filters.append("vowel")
                    }
                }) {
                    HStack {
                        Text("Vowel")
                        Spacer()
                        Text("XXX Entries")
                    }
                    .foregroundColor(filters.contains("vowel") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
                
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("mpt") {
                        delete(element: "mpt")
                    } else {
                        self.filters.append("mpt")
                    }
                }) {
                    HStack {
                        Text("MPT")
                        Spacer()
                        Text("XXX Entries")
                    }
                    .foregroundColor(filters.contains("mpt") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
                
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("rainbow") {
                        delete(element: "rainbow")
                    } else {
                        self.filters.append("rainbow")
                    }
                }) {
                    HStack {
                        Text("Rainbow")
                        Spacer()
                        Text("XXX Entries")
                    }
                    .foregroundColor(filters.contains("rainbow") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
                
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("surveys") {
                        delete(element: "surveys")
                    } else {
                        self.filters.append("surveys")
                    }
                }) {
                    HStack {
                        Text("Quests")
                        Spacer()
                        Text("XXX Entries")
                    }
                    .foregroundColor(filters.contains("surveys") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
                
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("journals") {
                        delete(element: "journals")
                    } else {
                        self.filters.append("journals")
                    }
                }) {
                    HStack {
                        Text("Journals")
                        Spacer()
                        Text("XXX Entries")
                    }
                    .foregroundColor(filters.contains("journals") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
            }
            
            VStack(spacing: 0) {
                Color.BODY_COPY.frame(height: 1)
                
                HStack {
                    Button(action: {
                        self.filters.removeAll()
                    }) {
                        ZStack {
                            Image(svm.empty_img)
                                .resizable()
                                .frame(width: 150, height: 35)
                            Text("CLEAR")
                                .foregroundColor(Color.DARK_PURPLE)
                        }
                    }
                    Spacer()
                    Button(action: {
                        self.showFitler.toggle()
                    }) {
                        ZStack {
                            Image(svm.filled_img)
                                .resizable()
                                .frame(width: 150, height: 35)
                            Text("DONE")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .background(Color.INPUT_FIELDS)
            }
        }
        
        
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
        .edgesIgnoringSafeArea(.top)
        .background(Color.white)
    }
    
    
    private var bodySection: some View {
        /*
         
         Title Filter button
         
         filter display section
         
         expandable
         
         */
        VStack(alignment: .center) {
            HStack {
                Text("Last week")
                    .font(._title1)
                Spacer()
                Button(action: {
                    self.showFitler.toggle()
                }) {
                    Text("Filter")
                        .foregroundColor(Color.BODY_COPY)
                        .font(._CTALink)
                        .padding(7)
                        .background(Color.white)
                        .cornerRadius(5)
                        .padding(1)
                        .background(Color.INPUT_FIELDS)
                        .cornerRadius(5)
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
                                Image(svm.exit_button)
                                    .resizable()
                                    .frame(width: 7.5, height: 7.5)
                                    .padding(.leading, 2)
                            }
                            .padding(2)
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
                if !filteredList.isEmpty {
                    ForEach(filteredList.reversed(), id: \.self) { item in
                        ListItem(element: item)
                        Color.INPUT_FIELDS.frame(height: 1.5)
                    }
                }
            }
        }
        .frame(width: svm.content_width)
        .onAppear() {
            refilter()
        }
    }
    
    private var graphSection: some View {
        VStack {
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
                
                Text(title[toggle])
                    .font(Font._title1)
                    .foregroundColor(foreColor[toggle])
                
                if toggle == 0 {
                    HBarChart(chartData: hChartData, style: ProgressView.chartStyle)
                        .frame(width: svm.content_width, height: 155)
                        //.background(Color.gray)
                }
                
                Spacer()
                
                HStack (spacing: 5) {
                    Spacer()
                    ForEach(0..<5) { index in
                        Button(action: {
                            withAnimation() {
                                toggle = index
                            }
                        }) {
                            Circle()
                                .frame(width: 8.5, height: 8.5)
                                .padding(7.5)
                                .foregroundColor(toggle == index ?
                                                 foreColor[toggle] : Color.INPUT_FIELDS)
                        }
                    }
                    Spacer()
                }
                .padding(5)
            }
            .transition(.opacity)
            .frame(width: svm.content_width)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .background(backColor[toggle])
    }
    
    
    
    private var header: some View {
        VStack(alignment: .leading) {
            Text("Progress")
                .bold()
                .font(._title)
            Text("Log some recordings, surveys, journals and interventions and view them bellow. The purpose of this page is to ensure that I am able to pull everything the user saves properly, without items disapearing or getting corrupted.")
                .font(._subTitle)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var accessSection: some View {
        Group {
            Text("Recordings")
                .bold()
            List {
                ForEach(audioRecorder.recordings, id: \.createdAt) { record in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(record.createdAt.toStringDay())")
                                .bold()
                            Text("Duration: \(audioRecorder.returnProcessing(createdAt: record.createdAt).duration, specifier: "%.2f")s, intensity: \(audioRecorder.returnProcessing(createdAt: record.createdAt).intensity, specifier: "%.1f")hz")
                        }
                        Spacer()
                        PlaybackButton(file: record.fileURL)
                            .font(.title)
                    }
                }.onDelete(perform: delete)
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, -10)
            
            Text("Surveys")
                .bold()
            List {
                ForEach(entries.questionnaires) { response in
                    VStack(alignment: .leading) {
                        Text("Date: \(response.createdAt.toStringDay())")
                            .bold()
                        Text("Question 1: \(response.responses[1])")
                        Text("Question 2: \(response.responses[2])")
                        Text("Question 3: \(response.responses[3])")
                    }
                }//.onDelete(perform: nil)
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, -10)
        }
    }
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

struct Element: Hashable {
    var date: Date
    var str: [String]
}

struct ListItem: View {
    @State private var showMore = false
    let element: Element
    var body: some View {
        VStack {
            Button(action: {
                withAnimation() {
                    self.showMore.toggle()
                }
            }) {
                HStack(spacing: 0) {
                    Text("\(element.date.dayOfWeek())  ")
                        .font(._bodyCopyBold)
                    Text(element.date.toDay())
                        .font(._bodyCopyMedium)
                    
                    SmallArrow()
                        .rotationEffect(Angle(degrees: showMore ? 90 : 0))
                    
                    Spacer()
                }
            }
            if showMore {
                ForEach(0..<element.str.count) { index in
                    HStack {
                        Text(element.str[index])
                        if element.str[index] == "vowel" || element.str[index] == "mpt" || element.str[index] == "rainbow" {
                            
                        }
                    }
                }
            }
        }
        .foregroundColor(Color.BODY_COPY)
    }
}
