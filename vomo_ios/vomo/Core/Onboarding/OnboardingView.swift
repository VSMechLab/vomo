//
//  OnboardingView.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/6/22.
//

import SwiftUI

/*
 make sure audio recording works
 finalize UI
 */

struct OnboardingView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    let recording_background_img = "VM_Waves-Gfx"
    let logo = "VM_VoMo-Logo-WhBG"
    let button_img = "VM_Gradient-Btn"
    
    let content_width = 317.5
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                
                Text("Welcome to ")
                    .font(._headline)
                
                Text("VoMo")
                    .font(._headline)
                    .foregroundColor(Color.DARK_PURPLE)
                
                Text(".")
                    .font(._headline)
                    .foregroundColor(Color.TEAL)
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text("Track your voice over time and share vocal health information with your clinical provider all in one place")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .frame(width: content_width)
            
            Spacer()
            
            Image(recording_background_img)
                .resizable()
                .padding(.horizontal, -10)
                .frame(width: UIScreen.main.bounds.width + 10, height: 50)
            
            Spacer()
            
            Button(action: {
                viewRouter.currentPage = .personalQuestionView
            }) {
                SubmissionButton(label: "GET STARTED")
            }
            .frame(width: content_width, height: 55, alignment: .center)
            .padding(.top, 30)
            .padding(.bottom)
        }.onAppear {
            UserDefaults.standard.set(false, forKey: "edited_before")
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

/*
 
 HStack {
     Text("skip")
         .foregroundColor(.gray)
     Spacer()
     Button("Next->") {}
 }.padding(.horizontal, 20)
 
 */
