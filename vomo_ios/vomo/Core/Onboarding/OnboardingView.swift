//
//  OnboardingView.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/6/22.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    let recording_background_img = "VM_Waves-Gfx"
    let logo = "VM_VoMo-Logo-WhBG"
    let button_img = "VM_Gradient-Btn"
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                
                Text("Welcome to ")
                    .font(._headline)
                
                Text("VoMo.")
                    .font(._headline)
                    .foregroundColor(Color.DARK_PURPLE)
                
                Spacer()
            }
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Excepteur sint occaecat cupidatat non proident, sunt in est laborum.")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            Image(recording_background_img)
                .resizable()
                .padding(.horizontal, -10)
                .frame(width: UIScreen.main.bounds.width + 10, height: 50)
            
            Spacer()
            
            Button(action: {
                viewRouter.currentPage = .personalQuestionView
            }) {
                ZStack {
                    Image(button_img)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 75, height: 55, alignment: .center)
                        .cornerRadius(20)
                    
                    Text("Get Started")
                        .font(._BTNCopy)
                        .foregroundColor(Color.white)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 75, height: 55, alignment: .center)
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
