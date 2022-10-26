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
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading, spacing: 10) {
                    header
                    
                    ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
                        Scale(responses: self.$responses, prompt: element, index: index)
                    }
                    
                    submitButton
                }
                .frame(width: svm.content_width)
                .padding(.bottom, 100)
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
            }
        }
        .onAppear() {
            self.responses = Array(repeating: 0, count: 11)
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
            } else if settings.vhi {
                Text(svm.questions.first ?? "VHI")
                    .font(._subTitle)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 6)
            } else {
                Text("Vocal Effort Rating")
                    .font(._subTitle)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 6)
            }
            
            if settings.vhi && settings.vocalEffort {
                Text("Vocal Handicap Index (VHI)-10 & Vocal Effort Rating")
                    .foregroundColor(.black)
                    .font(._title)
                    .padding(.leading, 6)
            } else if settings.vhi {
                Text("Vocal Handicap Index (VHI)-10")
                    .foregroundColor(.black)
                    .font(._title)
                    .padding(.leading, 6)
            } else {
                Text("Vocal Effort Rating")
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
    
    private var submitButton: some View {
        HStack {
            Spacer()
            Button(action: {
                self.entries.questionnaires.append(QuestionnaireModel(createdAt: .now, responses: self.responses))
                responses = []
                submitAnimation = true
                
                if settings.isActive() { settings.questionnaireEntered += 1 }
            }) {
                SubmissionButton(label: "Submit")
            }
            Spacer()
        }
    }
}

struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireView()
    }
}
