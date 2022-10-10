//
//  QuestionnaireView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

/// to do fix view
/// on appear define an integer of a fixed size that the index of each question will be saved at the scale level
///


struct QuestionnaireView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var entries: Entries
    //@State private var vm = RecordingViewModel()
    @State private var svm = SharedViewModel()
    @State private var submitAnimation = false
    @State private var responses: [Int] = []
    let button_img = "VM_Gradient-Btn"
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(svm.questions.first ?? "Choose a questionnaire selection in settings")
                        .font(._subTitle)
                        .foregroundColor(Color.BODY_COPY)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 6)
                    
                    Text("Questionnaire")
                        .foregroundColor(.black)
                        .font(._title)
                        .padding(.leading, 6)
                    
                    Text("These are statements that many people have used to describe their voices and effects of their voices on their lives. Circle the response that indicates how frequently you have the same experience.")
                        .font(._subTitle)
                        .foregroundColor(Color.BODY_COPY)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 6)
                    
                    ForEach(Array(svm.questions.enumerated()), id: \.element) { index, element in
                        if index == svm.questions.count - 1 {
                            EmptyScale(responses: self.$responses, prompt: element, index: index)
                        } else if index != 0 {
                            Scale(responses: self.$responses, prompt: element, index: index)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.entries.questionnaires.append(QuestionnaireModel(createdAt: .now, responses: self.responses))
                            responses = []
                            submitAnimation = true
                        }) {
                            SubmissionButton(label: "Submit")
                        }
                        Spacer()
                    }
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
            self.responses = Array(repeating: 0, count: svm.questions.count)
        }
    }
}

struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireView()
    }
}
