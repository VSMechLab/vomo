//
//  QuestionnaireView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

struct QuestionnaireView: View {
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
            ScrollView(showsIndicators: true) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 10) {
                        header
                        
                        questionSection
                        
                        submitButton
                    }
                    .frame(width: svm.content_width * 0.975)
                    .padding(.bottom, 100)
                    
                    VStack {
                        Color.clear
                    }
                    .padding(.bottom, 100)
                    .frame(width: svm.content_width * 0.025)
                }
                
            }
            
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
            self.responses = Array(repeating: -1, count: 11)
        }
    }
}

extension QuestionnaireView {
    private var header: some View {
        Group {
            if settings.vhi && settings.vocalEffort {
                Text("VHI & Vocal Effort Rating")
                    .font(._subTitle)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 6)
                
                Text("Vocal Handicap Index (VHI)-10 & Vocal Effort Rating")
                    .foregroundColor(.black)
                    .font(._title)
                    .padding(.leading, 6)
            } else {
                Text(settings.vhi ? "VHI" : "Vocal Effort Rating")
                    .font(._subTitle)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 6)
                
                Text(settings.vhi ? "Vocal Handicap Index (VHI)-10" : "Vocal Effort Rating")
                    .foregroundColor(.black)
                    .font(._title)
                    .padding(.leading, 6)
            }
            
            Text("These are statements that many people have used to describe their voices and effects of their voices on their lives. Choose the response that indicates how frequently you have the same experience.")
                .font(._subTitle)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.leading)
                .padding(.leading, 6)
            
            Image(svm.start_scale_img)
                .resizable()
                .scaledToFit()
        }
    }
    
    private var questionSection: some View {
        ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
            if element == "How much effort did it take to make a voice?" {
                BackupScale(responses: self.$responses, prompt: element)
            } else {
                Scale(responses: self.$responses, prompt: element, index: index)
            }
        }
    }
    
    private var submitButton: some View {
        HStack {
            Spacer()
            Button("Submit") {
                self.entries.questionnaires.append(QuestionnaireModel(createdAt: .now, responses: self.responses, star: false))
                responses = []
                submitAnimation = true
                
                if settings.isActive() { settings.surveyEntered += 1 }
            }.buttonStyle(SubmitButton())
            Spacer()
        }
    }
}

struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireView()
    }
}
