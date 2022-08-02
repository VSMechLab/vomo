//
//  VocalEffortView.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

struct VocalEffortView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var entries: Entries
    
    let button_img = "VM_Gradient-Btn"
    
    @State private var q1 = -1
    @State private var q2 = -1
    
    @State private var submitAnimation = false
    
    var body: some View {
        ZStack {
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
                    submitAnimation = true
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
    }
}

