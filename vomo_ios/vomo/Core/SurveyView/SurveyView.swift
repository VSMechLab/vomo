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
    
    @State var timeRemaining = 2
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                infoSection
                
                ScrollView(showsIndicators: true) {
                    VStack(alignment: .leading) {
                        if settings.vhi || settings.vocalEffort {
                            if settings.vhi {
                                vhiSection
                            }
                            if settings.vocalEffort {
                                veSection
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
            self.responses = Array(repeating: -1, count: 12)
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
            Text("VHI")
                .font(._subTitle)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.leading)
                .padding(.top)
            
            Text("Vocal Handicap Index (VHI)-10")
                .foregroundColor(.black)
                .font(._title)
            
            ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
                if element != "How much physical effort did it take to make a voice?" && element != "How much mental effort did it take to make a voice?" {
                    VHIScale(responses: self.$responses, prompt: element, index: index)
                        .frame(width: svm.content_width * 0.975)
                }
            }
        }
    }
    
    private var veSection: some View {
        Group {
            Text("Vocal Effort Rating")
                .font(._subTitle)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.leading)
                .padding(.top)
            
            Text("Vocal Effort Rating")
                .foregroundColor(.black)
                .font(._title)
            
            ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
                if element == "How much physical effort did it take to make a voice?" || element == "How much mental effort did it take to make a voice?" {
                    VEScale(responses: self.$responses, prompt: element, index: index)
                        .frame(width: svm.content_width * 0.975)
                        .onAppear() {
                            print("responses: \(responses), prompt: \(element)")
                        }
                }
            }
        }
    }
    
    private var submitButton: some View {
        HStack {
            Spacer()
            Button("Submit") {
                self.entries.questionnaires.append(QuestionnaireModel(createdAt: .now, responses: self.responses, favorite: false))
                responses = []
                submitAnimation = true
                
                if settings.isActive() && settings.surveysPerWeek != 0 {
                    settings.surveyEntered += 1
                }
            }.buttonStyle(SubmitButton())
            Spacer()
        }
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
