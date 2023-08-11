//
//  SurveyView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

struct SurveyView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var entries: Entries
    @ObservedObject var settings = Settings.shared
    //@State private var vm = RecordingViewModel()
    @State private var svm = SharedViewModel()
    @State private var submitAnimation = false
    @State private var responses: [Double] = []
    let button_img = "VM_Gradient-Btn"
    
    @State var timeRemaining = 1
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
    @State private var showMissing = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: true) {
                VStack(alignment: .center, spacing: 5) {
                    if settings.vhi || settings.vocalEffort || settings.botulinumInjection {
                        
                        if settings.vhi {
                            vhiSection
                        }
                        if settings.vocalEffort {
                            veSection
                        }
                        if settings.botulinumInjection {
                            biSection
                        }
                        
                        submitButton
                    } else {
                        HStack {
                            Text("No survey selection")
                                .foregroundColor(.black)
                                .font(._title)
                                .padding(.top)
                            Spacer()
                        }
                        HStack {
                            Text("You may edit your voice plan in settings to include an option that asks you to complete surveys.")
                                .font(._subTitle)
                                .foregroundColor(Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                }
                .frame(width: svm.content_width)
                .padding(.trailing)
            }
            .frame(width: svm.content_width * 1.05)
            
            if submitAnimation {
                ZStack {
                    Color.gray
                        .frame(width: 125, height: 125)
                        .cornerRadius(10)
                    
                    VStack {
                        Image(systemName: "checkmark")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding(.vertical)
                        Text("Submitted!")
                            .foregroundColor(Color.white)
                            .font(._BTNCopy)
                            .padding(.bottom)
                    }
                }
                .onAppear() {
                    withAnimation(.easeOut(duration: 2.5)) {
                        submitAnimation.toggle()
                    }
                }
                .opacity(submitAnimation ? 0.6 : 0.0)
                .zIndex(1)
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                    if timeRemaining == 0 {
                        self.viewRouter.currentPage = .home
                    }
                }
            }
        }
        .onAppear() {
            self.settings.setSurveys()
            self.responses = Array(repeating: -1, count: 13)
        }
    }
}

extension SurveyView {
    private var infoSection: some View {
        Image(svm.start_scale_img)
            .resizable()
            .scaledToFit()
    }
    
    private var vhiSection: some View {
        Group {
            HStack {
                Text("Vocal Handicap Index (VHI)-10")
                    .foregroundColor(.black)
                    .font(._title)
                Spacer()
            }
            
            infoSection
            
            ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
                if index <= 9 {
                    if index == 6 {
                        infoSection
                    }
                    VHIScale(responses: self.$responses, prompt: element, index: index)
                }
            }
            
        }
    }
    
    private var veSection: some View {
        Group {
            /*Text("Vocal Effort Rating")
                .font(._subTitle)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.leading)
                .padding(.top)
            */
            HStack {
                Text("Vocal Effort Rating")
                    .foregroundColor(.black)
                    .font(._title)
                Spacer()
            }
            
            ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
                if element == "How much **physical effort** does it take to make a voice?" || element == "How much **mental effort** does it take to make a voice?" {
                    VEScale(responses: self.$responses, prompt: element, index: index)
                }
            }
        }
    }
    
    private var biSection: some View {
        Group {
            HStack {
                Text("Current Percent of Vocal Function")
                    .foregroundColor(.black)
                    .font(._title)
                Spacer()
            }
            
            ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
                if index > 12 {
                    VHIScale(responses: self.$responses, prompt: element, index: index)
                } else if index == 12 {
                    HStack {
                        if lastResponse().responses[12] != -1.0 {
                            Text("Last Response: \(lastResponse().score.3, specifier: "%.0f")% (\(lastResponse().createdAt.dayOfWeek()) \(lastResponse().createdAt.toDay()))")
                                .font(Font._bodyCopyBold)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                    }
                    
                    VEScale(responses: self.$responses, prompt: element, index: index)
                }
            }
        }
    }
    
    func lastResponse() -> SurveyModel {
        var resp = SurveyModel(createdAt: .now, responses: Array(repeating: -1.0, count: 13), favorite: false)
        
        for quest in entries.questionnaires {
            if quest.responses[12] != -1.0 {
                resp = quest
            }
        }
        
        return resp
    }
    
    private var submitButton: some View {
        VStack(alignment: .center) {
            if showMissing && remaining().isNotEmpty {
                HStack {
                    Text("Please answer the following...")
                        .font(._CTALink)
                        .foregroundColor(Color.red)
                    Spacer()
                }
                
                VStack {
                    ForEach(remaining(), id: \.self) { text in
                        HStack {
                            Text(text)
                                .font(._CTALink)
                            Spacer()
                        }
                    }
                }
            }
            
            HStack {
                Spacer()
                if submitable() || settings.allowIncompleteSurvey {
                    Button("Submit") {
                        // editing this to separate the two different surveys to save independently
                        
                        self.showMissing = false
                        
                        print(responses)
                        
                        /// Separate into three separate sections
                        
                        if settings.vhi {
                            /// newResults just holds what is going to be appended
                            var newResults: [Double] = []
                            // two separate files to submit
                            
                            var count = -1
                            
                            // first with just the first 10 resp
                            if responses.count == 13 {
                                for index in 0..<responses.count {
                                    if index >= 10 {
                                        newResults.append(-1)
                                    } else {
                                        newResults.append(responses[index])
                                    }
                                }
                                
                                for i in newResults.indices {
                                    if newResults[i] != -1 {
                                        count = 0
                                    }
                                }
                                
                                if count == 0 {
                                    self.entries.questionnaires.append(SurveyModel(createdAt: .now, responses: newResults, favorite: false))
                                }
                            }
                        }
                        if settings.vocalEffort {
                            var newResults: [Double] = []
                            // next with just the last two resp
                            newResults = []
                            var count = -1
                            for index in 0..<responses.count {
                                if index == 10 || index == 11 {
                                    newResults.append(responses[index])
                                } else {
                                    newResults.append(-1)
                                }
                            }
                            
                            for i in newResults.indices {
                                if newResults[i] != -1 {
                                    count = 0
                                }
                            }
                            
                            if count == 0 {
                                self.entries.questionnaires.append(SurveyModel(createdAt: .now + 5, responses: newResults, favorite: false))
                            }
                        }
                        if settings.botulinumInjection {
                            var newResults: [Double] = []
                            // next with just the last two resp
                            newResults = []
                            var count = -1
                            for index in 0..<responses.count {
                                if index == 12 {
                                    newResults.append(responses[index])
                                } else {
                                    newResults.append(-1)
                                }
                            }
                            
                            for i in newResults.indices {
                                if newResults[i] != -1 {
                                    count = 0
                                }
                            }
                            
                            if count == 0 {
                                self.entries.questionnaires.append(SurveyModel(createdAt: .now + 10, responses: newResults, favorite: false))
                            }
                        }
                        
                        responses = []
                        submitAnimation = true
                        
                        if settings.isActive() && settings.surveysPerWeek != 0 {
                            settings.surveyEntered += 1
                        }
                    }.buttonStyle(SubmitButton())
                    .offset(x: 10)
                } else {
                    Button("Submit") {
                        self.showMissing = true
                    }.buttonStyle(GraySubmitButton())
                    .offset(x: 10)
                }
                Spacer()
            }
        }
    }
    
    func submitable() -> Bool {
        if responses.isNotEmpty {
            if settings.vhi {
                for index in 0...9 {
                    if responses[index] == -1 {
                        return false
                    }
                }
            }
            
            if settings.vocalEffort {
                for index in 10...11 {
                    if responses[index] == -1 {
                        return false
                    }
                }
            }
            
            if settings.botulinumInjection {
                for index in 12...12 {
                    if responses[index] == -1 {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func remaining() -> [String] {
        var returnable: [String] = []
        
        
        if responses.isNotEmpty {
            if settings.vhi {
                for index in 0...9 {
                    if responses[index] == -1 {
                        returnable.append(svm.questions[index])
                    }
                }
            }
            if settings.vocalEffort {
                for index in 10...11 {
                    if responses[index] == -1 {
                        returnable.append(svm.questions[index])
                    }
                }
            }
            if settings.botulinumInjection {
                for index in 12...12 {
                    if responses[index] == -1 {
                        returnable.append(svm.questions[index])
                    }
                }
            }
        }
        
        return returnable
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
