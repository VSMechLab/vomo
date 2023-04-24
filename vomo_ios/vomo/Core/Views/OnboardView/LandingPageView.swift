//
//  LandingPageView.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/1/22.
//

import SwiftUI

struct LandingPageView: View {
    let svm = SharedViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ZStack {
                    Wave(color: Color.DARK_BLUE, offset: 1.5, recording: .constant(false))
                    Wave(color: Color.TEAL, offset: 1.0, recording: .constant(false))
                    Wave(color: Color.DARK_PURPLE, offset: 2.0, recording: .constant(false))
                }
                Spacer()
            }
            
            VStack {
                HStack(spacing: 0) {
                    Spacer()
                    Text("Welcome to ")
                    Text("VoMo")
                        .foregroundColor(Color.DARK_PURPLE)
                    Text(".")
                        .foregroundColor(Color.TEAL)
                    Spacer()
                }
                .font(._title)
                .padding(.top, 100)
                .padding(.bottom, 10)
                
                Text("Track your voice over time and share vocal health information with your clinical provider all in one place")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .frame(width: svm.content_width)
                
                Spacer()
                
                 //CHANGE: added more padding
            } // End VStack
            .onAppear {
                UserDefaults.standard.set(false, forKey: "edited_before")
            }
        }
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}
