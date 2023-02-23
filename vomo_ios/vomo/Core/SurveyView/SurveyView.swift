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
    @EnvironmentObject var settings: Settings
    //@State private var vm = RecordingViewModel()
    @State private var svm = SharedViewModel()
    @State private var submitAnimation = false
    @State private var responses: [Int] = []
    let button_img = "VM_Gradient-Btn"
    
    @State var timeRemaining = 1
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
    @State private var showMissing = false
    @State private var remainingQuestions: [String] = []
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                infoSection
                
                ScrollView(showsIndicators: true) {
                    VStack(alignment: .leading) {
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
                    .frame(width: svm.content_width * 0.9)
                    .padding(.trailing, 10)
                    .frame(width: svm.content_width)
                }
            }
            .frame(width: svm.content_width * 0.9)
            .padding(.trailing, 10)
            .frame(width: svm.content_width)
            
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
            self.responses = Array(repeating: -1, count: 16)
        }
    }
}

extension SurveyView {
    private var infoSection: some View {
        Group {
            if settings.vhi {
                Image(svm.start_scale_img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: svm.content_width * 0.975)
            }
        }
    }
    
    private var vhiSection: some View {
        Group {
            /*Text("VHI")
                .font(._subTitle)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.leading)
                .padding(.top)
            */
            Text("Vocal Handicap Index (VHI)-10")
                .foregroundColor(.black)
                .font(._title)
            
            ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
                if index <= 9 {
                    VHIScale(responses: self.$responses, prompt: element, index: index)
                        .frame(width: svm.content_width * 0.975)
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
            Text("Vocal Effort Rating")
                .foregroundColor(.black)
                .font(._title)
            
            ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
                if element == "How much physical effort did it take to make a voice?" || element == "How much mental effort did it take to make a voice?" {
                    VEScale(responses: self.$responses, prompt: element, index: index)
                        .frame(width: svm.content_width * 0.975)
                }
            }
        }
    }
    
    private var biSection: some View {
        Group {
            Text("Botulinum Injection")
                .foregroundColor(.black)
                .font(._title)
            
            ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
                if index > 12 {
                    VHIScale(responses: self.$responses, prompt: element, index: index)
                        .frame(width: svm.content_width * 0.975)
                } else if index == 12 {
                    VEScale(responses: self.$responses, prompt: element, index: index)
                        .frame(width: svm.content_width * 0.975)
                }
            }
        }
    }
    
    private var submitButton: some View {
        VStack {
            if showMissing {
                HStack {
                    Text("Please answer the following...")
                        .font(._CTALink)
                        .foregroundColor(Color.red)
                    Spacer()
                }
                
                VStack {
                    ForEach(remainingQuestions, id: \.self) { text in
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
                        
                        
                        /// Separate into three separate sections
                        
                        if settings.vhi {
                            /// newResults just holds what is going to be appended
                            var newResults: [Int] = []
                            // two separate files to submit
                            
                            // first with just the first 10 resp
                            for index in 0..<responses.count {
                                if index == 10 || index == 11 {
                                    newResults.append(-1)
                                } else {
                                    newResults.append(responses[index])
                                }
                            }
                            self.entries.questionnaires.append(QuestionnaireModel(createdAt: .now, responses: newResults, favorite: false))
                        } else if settings.vocalEffort {
                            var newResults: [Int] = []
                            // next with just the last two resp
                            newResults = []
                            for index in 0..<responses.count {
                                if index == 10 || index == 11 {
                                    newResults.append(responses[index])
                                } else {
                                    newResults.append(-1)
                                }
                            }
                            self.entries.questionnaires.append(QuestionnaireModel(createdAt: .now + 5, responses: newResults, favorite: false))
                        } else if settings.botulinumInjection {
                            var newResults: [Int] = []
                            // next with just the last two resp
                            newResults = []
                            for index in 0..<responses.count {
                                if index >= 13 {
                                    newResults.append(responses[index])
                                } else {
                                    newResults.append(-1)
                                }
                            }
                            self.entries.questionnaires.append(QuestionnaireModel(createdAt: .now + 10, responses: newResults, favorite: false))
                        }
                        
                        responses = []
                        submitAnimation = true
                        
                        if settings.isActive() && settings.surveysPerWeek != 0 {
                            settings.surveyEntered += 1
                        }
                    }.buttonStyle(SubmitButton())
                } else {
                    Button("Submit") {
                        self.showMissing = true
                        findRemaining()
                    }.buttonStyle(GraySubmitButton())
                }
                Spacer()
            }
        }
    }
    
    func submitable() -> Bool {
        var ret = true
        print(responses)
        if responses.isNotEmpty {
            if settings.vhi && settings.vocalEffort {
                for resp in responses {
                    if resp == -1 {
                        ret = false
                    }
                }
            } else if settings.vhi && !settings.vocalEffort {
                for index in 0..<10 {
                    if responses[index] == -1 {
                        ret = false
                    }
                }
            } else if !settings.vhi && settings.vocalEffort {
                if responses.count == 12 {
                    print(responses.count)
                    if responses[10] == -1 || responses[11] == -1 {
                        ret = false
                    }
                }
            }
        }
        
        return ret
    }
    
    func findRemaining() {
        self.remainingQuestions.removeAll()
        
        if settings.vhi && settings.vocalEffort {
            for index in 0..<responses.count {
                if responses[index] == -1 {
                    remainingQuestions.append(svm.questions[index])
                }
            }
        } else if settings.vhi && !settings.vocalEffort {
            for index in 0..<10 {
                if responses[index] == -1 {
                    remainingQuestions.append(svm.questions[index])
                }
            }
        } else if !settings.vhi && settings.vocalEffort {
            if responses.count == 12 {
                for index in 10...11 {
                    if responses[index] == -1 {
                        remainingQuestions.append(svm.questions[index])
                    }
                }
            }
        }
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
