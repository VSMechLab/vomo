//
//  Questionnaire.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/11/22.
//

import SwiftUI
import UIKit

struct Questionnaire: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var entries: Entries
    
    let button_img = "VM_Gradient-Btn"
    
    @State private var q1 = -1
    @State private var q2 = -1
    @State private var q3 = -1
    @State private var q4 = -1
    @State private var q5 = -1
    @State private var q6 = -1
    @State private var q7 = -1
    @State private var q8 = -1
    @State private var q9 = -1
    @State private var q10 = -1
    @State private var q11 = -1
    
    let content_width: CGFloat = 317.5
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ProfileButton()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Voice-Related Quality of Life")
                    .font(Font.vomoLightBodyText)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
                
                Text("Questionnaire")
                    .foregroundColor(.black)
                    .font(Font.vomoTitle)
                
                Text("These are statements that many people have used to describe their voices and effects of their voices on their lives. Circle the response that indicates how frequently you have the same experience.")
                    .font(Font.vomoLightBodyText)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
                
                Group {
                    Group {
                        Scale(position: self.$q1, prompt: 0)
                        Scale(position: self.$q2, prompt: 1)
                        Scale(position: self.$q3, prompt: 2)
                        Scale(position: self.$q4, prompt: 3)
                        Scale(position: self.$q5, prompt: 4)
                        Scale(position: self.$q6, prompt: 5)
                    }
                    Scale(position: self.$q7, prompt: 6)
                    Scale(position: self.$q8, prompt: 7)
                    Scale(position: self.$q9, prompt: 8)
                    Scale(position: self.$q10, prompt: 9)
                    Scale(position: self.$q11, prompt: 10)
                }
                
                Button("") {
                    self.entries.questionnaires.append(QuestionnaireModel(createdAt: .now, q1: self.q1, q2: self.q2, q3: self.q3, q4: self.q4, q5: self.q5, q6: self.q6, q7: self.q7, q8: self.q8, q9: self.q9, q10: self.q10, q11: self.q11))
                }.buttonStyle(SubmissionButton(label: "Submit"))
            }
            .frame(width: content_width)
            .padding(.bottom, 100)
        }
    }
}
