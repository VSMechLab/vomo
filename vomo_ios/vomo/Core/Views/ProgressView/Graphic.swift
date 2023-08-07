//
//  Graphic.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// tabs
var tabs = ["Summary", "Pitch", "Duration", "Quality", "Survey"]

struct Graphic: View {
    @Binding var thresholdPopUps: (Bool, Bool, Bool)
    @Binding var tappedRecording: Date
    @Binding var showBaseline: (Bool, Int)
    @Binding var deletionTarget: (Date, String)
    
    @State var selectedTab = "Summary"
    
    @State var edge = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .first(where: { $0 is UIWindowScene })
        .flatMap({ $0 as? UIWindowScene })?.windows
        .first(where: \.isKeyWindow)!.safeAreaInsets
    
    @State private var showTitle = true
    
    @State private var time: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            if selectedTab == "Summary" {
                Color.BLUE.edgesIgnoringSafeArea(.top)
            } else if selectedTab == "Pitch" {
                Color.DARK_PURPLE.edgesIgnoringSafeArea(.top)
            } else if selectedTab == "Duration" {
                Color.DARK_PURPLE.edgesIgnoringSafeArea(.top)
            } else if selectedTab == "Quality" {
                Color.DARK_PURPLE.edgesIgnoringSafeArea(.top)
            } else if selectedTab == "Survey" {
                Color.DARK_BLUE.edgesIgnoringSafeArea(.top)
            }
            
            // Flip through views
            // Using swipe gesture
            TabView(selection: $selectedTab) {
                SummaryTab(showTitle: $showTitle)
                    .tag("Summary")
                
                PitchTab(showTitle: $showTitle, thresholdPopUps: $thresholdPopUps, tappedRecording: $tappedRecording, showBaseline: self.$showBaseline, deletionTarget: $deletionTarget)
                    .tag("Pitch")
                
                DurationTab(showTitle: $showTitle, thresholdPopUps: $thresholdPopUps, tappedRecording: $tappedRecording, showBaseline: self.$showBaseline, deletionTarget: $deletionTarget)
                    .tag("Duration")
                
                QualityTab(showTitle: $showTitle, thresholdPopUps: $thresholdPopUps, tappedRecording: $tappedRecording, showBaseline: $showBaseline, deletionTarget: $deletionTarget)
                    .tag("Quality")
                
                SurveyTab(showTitle: $showTitle, tappedRecording: $tappedRecording, deletionTarget: $deletionTarget)
                    .tag("Survey")
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all, edges: .bottom)
            .edgesIgnoringSafeArea(.top)
            
            
            VStack(spacing: 0) {
                if showTitle {
                    // Flip through bars using a tap
                    HStack(spacing: 0) {
                        ForEach(tabs, id: \.self) { image in
                            Spacer()
                            TabButton(image: image, selectedTab: $selectedTab)
                            if image == tabs.last {
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 0.5)
                    .padding(.vertical, 5)
                    .background(.white)
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
                    .padding(5)
                    /// for smaller phones
                    .padding(.bottom, edge!.bottom == 0 ? 20 : 0)
                    .transition(.slideDown)
                } else {
                    Button(action: {
                        withAnimation() {
                            self.showTitle = true
                            self.time = 0
                        }
                    }) {
                        Color.INPUT_FIELDS.opacity(0.00001)
                            .frame(height: 10)
                            .padding(.horizontal)
                    }.transition(.slideUp)
                }
                
                Spacer()
            }
            
            HStack {
                ForEach(0...4, id: \.self) { step in
                    Circle()
                        .foregroundColor(tabs[step] == selectedTab ? Color.white : Color.INPUT_FIELDS)
                        .frame(width: tabs[step] == selectedTab ? 8.5 : 6, height: tabs[step] == selectedTab ? 8.5 : 6, alignment: .center)
                }
            }
            .padding(.bottom, 5.5)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .onReceive(timer) { _ in
            time += 1
            if time > 1 {
                withAnimation() {
                    self.showTitle = false
                }
            }
        }
        // Reset the title if dragged at all
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    withAnimation() {
                        self.showTitle = true
                        self.time = 0
                    }
                }
                .onEnded { _ in
                    withAnimation() {
                        self.showTitle = true
                        self.time = 0
                    }
                }
        )
    }
}

struct SummaryTab: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var entries: Entries
    @ObservedObject var audioRecorder = AudioRecorder.shared
    @Binding var showTitle: Bool
    @State var showInformation = false
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Summary") {
                        self.showInformation = true
                    }
                    .font(Font._title1)
                    Spacer()
                }
                .padding(.top, showTitle ? 15 : -20)
                
                HStack {
                    Spacer()
                    Text("Weekly Goal")
                        .foregroundColor(Color.white)
                        .font(._bodyCopyMedium)
                }
                
                VStack {
                    Group {
                        Spacer()
                        
                        HStack {
                            Text("**Recordings** (\(settings.recordEntered) total / \(settings.currentWeekRecordings(recordings: audioRecorder.recordings)) this week)")
                            Spacer()
                            Text("\(settings.recordProgress, specifier: "%.0f")%")
                        }
                        
                        Spacer()
                    }
                    
                    dottedLine
                    
                    Group {
                        Spacer()
                        
                        HStack {
                            Text("**Surveys** (\(settings.surveyEntered) total / \(settings.currentWeekSurveys(surveys: entries.questionnaires)) this week)")
                            Spacer()
                            Text("\(settings.surveyProgress, specifier: "%.0f")%")
                        }
                        
                        Spacer()
                    }
                    
                    dottedLine
                    
                    Group {
                        Spacer()
                        
                        HStack {
                            Text("**Journals** (\(settings.journalEntered) total / \(settings.currentWeekJournals(journals: entries.journals)) this week)")
                            Spacer()
                            Text("\(settings.journalProgress, specifier: "%.0f")%")
                        }
                        
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                
                /*
                 self.hChartData = ChartData([("Recordings", settings.recordProgress), ("Surveys", settings.surveyProgress), ("Journals", settings.journalProgress)])
                GraphView(showVHI: .constant(false), showVE: .constant(false), index: 0)
                */
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
            .foregroundColor(.TEAL)
            .edgesIgnoringSafeArea(.all)
            
            if showInformation {
                Button(action: {
                    self.showInformation = false
                }) {
                    VStack {
                        Text("This is your summary page where you will find basic information about your progress towards your goals.")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .background(
                        Color.white
                            .cornerRadius(12)
                            .shadow(color: Color.gray, radius: 5)
                    )
                    .padding(50)
                }
                .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var dottedLine: some View {
        HStack(spacing: 0) {
            ForEach(0..<15) { index in
                if index % 2 == 0 {
                    Color.white.frame(height: 2)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
        }
    }
}

struct PitchTab: View {
    @EnvironmentObject var settings: Settings
    
    @Binding var showTitle: Bool
    
    @Binding var thresholdPopUps: (Bool, Bool, Bool)
    
    @Binding var tappedRecording: Date
    
    @Binding var showBaseline: (Bool, Int)
    
    @Binding var deletionTarget: (Date, String)
    
    @State var showInformation = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Pitch") {
                        self.showInformation = true
                    }
                    .font(Font._title1)
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Spacer()
                        
                        Color.indigo.opacity(0.5)
                            .frame(width: 14, height: 14)
                            .background(Color.DARK_PURPLE)
                            .cornerRadius(2.5)
                            .padding(1)
                            .background(Color.white)
                            .cornerRadius(2.5)
                        
                        // Typical female range
                        // Typical male range
                        // target range if trans
                        if settings.focusSelection == 1 {
                            if settings.gender == "Male" {
                                Text("Target Male Range")
                            } else if settings.gender == "Female" {
                                Text("Target Female Range")
                            } else {
                                Text("Target Range")
                            }
                        } else {
                            if settings.gender == "Male" {
                                Text("Typical Male Range")
                            } else if settings.gender == "Female" {
                                Text("Typical Female Range")
                            } else {
                                Text("Typical Range")
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .font(._fieldCopyRegular)
                    .offset(y: 10)
                }
                .padding(.top, showTitle ? 15 : -20)
                
                HStack {
                    if settings.focusSelection == 4 {
                        switch settings.gender {
                        case "Male":
                            Button("Set to Male") {
                                self.settings.gender = "Female"
                            }
                        case "Female":
                            Button("Set to Female") {
                                self.settings.gender = "Non-binary"
                            }
                        case "Non-binary":
                            Button("Set to Non-Binary") {
                                self.settings.gender = "Male"
                            }
                        default:
                            Button("No threshold set") {
                                self.settings.gender = "Male"
                            }
                        }
                    }
                }
                .foregroundColor(Color.white)
                .font(._bodyCopyMedium)
                
                PitchGraph(tappedRecording: $tappedRecording, showBaseline: self.$showBaseline, deletionTarget: $deletionTarget)
                
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
            .foregroundColor(.BRIGHT_PURPLE)
            .edgesIgnoringSafeArea(.all)
            
            if showInformation {
                Button(action: {
                    self.showInformation = false
                }) {
                    VStack {
                        Text("Displays a graph of the average pitch of your voice. The data for this graph comes from the recorded (Rainbow) sentences that you have provided.")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .background(
                        Color.white
                            .cornerRadius(12)
                            .shadow(color: Color.gray, radius: 5)
                    )
                    .padding(50)
                }
                .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
        .edgesIgnoringSafeArea(.all)
    }
}

struct DurationTab: View {
    @EnvironmentObject var settings: Settings
    
    @Binding var showTitle: Bool
    
    @Binding var thresholdPopUps: (Bool, Bool, Bool)
    
    @Binding var tappedRecording: Date
    
    @Binding var showBaseline: (Bool, Int)
    
    @Binding var deletionTarget: (Date, String)
    
    @State var showInformation = false
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Maximum Duration") {
                        self.showInformation = true
                    }
                    .font(Font._title1)
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Color.indigo.opacity(0.5)
                            .frame(width: 14, height: 14)
                            .background(Color.DARK_PURPLE)
                            .cornerRadius(2.5)
                            .padding(1)
                            .background(Color.white)
                            .cornerRadius(2.5)
                        
                        // Typical female range
                        // Typical male range
                        // target range if trans
                        if settings.focusSelection == 1 {
                            if settings.gender == "Male" {
                                Text("Target Male Range")
                            } else if settings.gender == "Female" {
                                Text("Target Female Range")
                            } else {
                                Text("Target Range")
                            }
                        } else {
                            if settings.gender == "Male" {
                                Text("Typical Male Range")
                            } else if settings.gender == "Female" {
                                Text("Typical Female Range")
                            } else {
                                Text("Typical Range")
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .font(._fieldCopyRegular)
                    .offset(y: 10)
                }
                .padding(.top, showTitle ? 15 : -20)
                
                DurationGraph(tappedRecording: $tappedRecording, showBaseline: self.$showBaseline, deletionTarget: $deletionTarget)
                
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
            .foregroundColor(.BRIGHT_PURPLE)
            .edgesIgnoringSafeArea(.all)
            
            if showInformation {
                Button(action: {
                    self.showInformation = false
                }) {
                    VStack {
                        Text("Displays a graph of the maximum time you can hold an \"ahh\" sound. The data for this graph comes from the recording task that asks you to make a vowel sound for as long as possible.")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .background(
                        Color.white
                            .cornerRadius(12)
                            .shadow(color: Color.gray, radius: 5)
                    )
                    .padding(50)
                }
                .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
        .edgesIgnoringSafeArea(.all)
    }
}

struct QualityTab: View {
    @EnvironmentObject var settings: Settings
    
    @Binding var showTitle: Bool
    
    @Binding var thresholdPopUps: (Bool, Bool, Bool)
    
    @Binding var tappedRecording: Date
    
    @Binding var showBaseline: (Bool, Int)
    
    @Binding var deletionTarget: (Date, String)
    
    @State var showInformation = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Voice Quality") {
                        self.showInformation = true
                    }
                    .font(Font._title1)
                    Spacer()
                }
                .padding(.top, showTitle ? 15 : -20)
                
                QualityGraph(tappedRecording: $tappedRecording, showBaseline: self.$showBaseline, deletionTarget: $deletionTarget)
                
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
            .foregroundColor(.BRIGHT_PURPLE)
            .edgesIgnoringSafeArea(.all)
            
            if showInformation {
                Button(action: {
                    self.showInformation = false
                }) {
                    VStack {
                        Text("Displays a graph of the quality of your voice. The data for this graph comes from the recorded (Rainbow) sentences that you provided.")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .background(
                        Color.white
                            .cornerRadius(12)
                            .shadow(color: Color.gray, radius: 5)
                    )
                    .padding(50)
                }
                .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SurveyTab: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Binding var showTitle: Bool
    
    @Binding var tappedRecording: Date
    
    @Binding var deletionTarget: (Date, String)
    
    /// if 0 show vhi-10
    /// if 1 show vocal effort
    /// if 2 show bi
    @State private var surveySelection: Int = -1
    
    @State var showInformation = false
    
    /// Iterate between four different graph types
    /// "Showing VHI-10", "Showing Vocal Effort (Physical)", "Showing Vocal Effort (Mental)", "Showing Current % of Vocal Function"
    /// Use buttons action bellow to determine when to move between different graphs
    let surveyName = ["Showing VHI-10", "Showing Current Vocal **Effort**", "Showing Current Vocal **Function**"]
    @State var availableSurveys: [Int] = []
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Survey") {
                        self.showInformation = true
                    }
                    .font(Font._title1)
                    Spacer()
                    Button(action: {
                        var indexOfSurveys = -1
                        
                        for index in 0..<availableSurveys.count {
                            if surveySelection == availableSurveys[index] {
                                indexOfSurveys = index
                            }
                        }
                        
                        if availableSurveys.count > 0 {
                            if indexOfSurveys + 1 < availableSurveys.endIndex {
                                surveySelection = availableSurveys[indexOfSurveys+1]
                            } else {
                                surveySelection = availableSurveys[0]
                            }
                        }
                    }) {
                        Text(surveySelection != -1 ? .init(surveyName[surveySelection]) : "")
                            .font(._bodyCopy)
                    }
                }
                .padding(.top, showTitle ? 15 : -20)
                
                Spacer()
                
                if surveySelection != -1 {
                    SurveyGraph(surveySelection: $surveySelection, tappedRecording: $tappedRecording, deletionTarget: $deletionTarget)
                } else {
                    Button(action: {
                        viewRouter.currentPage = .questionnaire
                    }) {
                        Text("Take a voice survey")
                            .underline()
                            .font(._bodyCopy)
                             + Text(" to see this graph")
                            .font(._bodyCopy)
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
            .foregroundColor(.TEAL)
            .edgesIgnoringSafeArea(.all)
            
            if showInformation {
                Button(action: {
                    self.showInformation = false
                }) {
                    VStack {
                        Text("Displays graphs of your voice survey results. If multiple types of surveys have been answered, toggle between different survey graphs by clicking on survey name in top right corner.")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .background(
                        Color.white
                            .cornerRadius(12)
                            .shadow(color: Color.gray, radius: 5)
                    )
                    .padding(50)
                }
                .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.345)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            refreshSurveys()
        }
        .onChange(of: entries.questionnaires.count) { _ in
            print("refreshing surveys")
            refreshSurveys()
        }
    }
    
    func refreshSurveys() {
        surveySelection = -1
        availableSurveys.removeAll()
        
        if surveyTotals().0 != 0 {
            availableSurveys += [0]
        }
        if surveyTotals().1 != 0 {
            availableSurveys += [1]
        }
        if surveyTotals().2 != 0 {
            availableSurveys += [2]
        }
        surveySelection = availableSurveys.first ?? -1
    }
    
    func surveyTotals() -> (Double, Double, Double) {
        var one = 0.0
        var two = 0.0
        var three = 0.0
        
        for survey in entries.questionnaires {
            if survey.score.0 != -1 {
                one += 1
            }
            if survey.score.1 != -1 || survey.score.2 != -1 {
                two += 1
            }
            if survey.score.3 != -1 {
                three += 1
            }
        }
        
        return (one, two, three)
    }
}

struct TabButton: View {
    
    var image: String
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: { selectedTab = image }) {
            Text(image)
                .font(selectedTab == image ? Font._tabTitleBold : Font._tabTitle)
                .foregroundColor(selectedTab == image ? .black : .gray.opacity(0.7))
        }
    }
}

struct Graphic_Previews: PreviewProvider {
    static var previews: some View {
        Graphic(thresholdPopUps: .constant((false, false, false)), tappedRecording: .constant(.now), showBaseline: .constant((false, 0)), deletionTarget: .constant((Date.now, String("string"))))
    }
}
