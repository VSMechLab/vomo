//
//  VocalEffort.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

struct VocalEffort: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var entries: Entries
    
    let button_img = "VM_Gradient-Btn"
    
    @State private var q1 = -1
    @State private var q2 = -1
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ProfileButton()
            
            HStack {
                Text("Vocal Effort Rating")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            HStack {
                Text("Questionnaire")
                    .foregroundColor(.black)
                    .font(._headline)
                
                Spacer()
            }
            
            HStack {
                Text("Please rate the ammount of physical effort and mental effort it takes you to make a voice")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Group {
                Group {
                    EffortScale(position: self.$q1, prompt: 1)
                    EffortScale(position: self.$q2, prompt: 2)
                }
            }
            
            Button(action: {
                self.entries.questionnairesEffort.append(QuestionnaireEffortModel(createdAt: .now, q1: self.q1, q2: self.q2))
            }) {
                ZStack {
                    Image(button_img)
                        .resizable()
                        .frame(width: 225, height: 40)
                    
                    Text("Submit")
                        .font(._BTNCopy)
                        .foregroundColor(Color.white)
                }
            }
            .padding(.bottom, 100)
        }
    }
}

