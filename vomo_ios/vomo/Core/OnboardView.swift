//
//  OnboardView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI
import UserNotifications

/// To do - clean code (later)

struct OnboardView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    
    @State private var svm = SharedViewModel()
    @State private var stepSwitch = 0
    @State private var startIndex = 0
    
    var body: some View {
        VStack {
            switch stepSwitch {
            case 0:
                LandingPageView()
            case 1:
                PersonalQuestionView()
            case 2:
                VoiceQuestionView()
            case 3:
                if self.settings.voice_plan == 1 {
                    TargetView()
                } else if self.settings.voice_plan == 2 {
                    CustomTargetView()
                }
            case 4:
                stepFour
            default:
                Text("error state")
            }
            
            Spacer()
            
            navSection
        }
        
        .onAppear() {
            if settings.edited_before {
                stepSwitch = 2
                startIndex = 2
            } else {
                startIndex = 1
            }
        }
    }
}

extension OnboardView {
    private var stepFour: some View {
        GoalEntryView()
    }
    
    private var navSection: some View {
        VStack {
            Spacer()
            if stepSwitch != 0 {
                ZStack {
                    HStack {
                        if stepSwitch != 1 || startIndex != 2 {
                            Button("Back") {
                                stepSwitch -= 1
                            }.buttonStyle(BackButton())
                        }
                        Spacer()
                        if stepSwitch != 4 {
                            Button("Next") {
                                stepSwitch += 1
                            }.buttonStyle(NextButton())
                        } else if stepSwitch == 4 {
                            Button("Done") {
                                viewRouter.currentPage = .home
                                settings.edited_before = true
                            }.buttonStyle(NextButton())
                        }
                    }
                    
                    HStack {
                        ForEach(startIndex...4, id: \.self) { step in
                            Circle()
                                .foregroundColor(stepSwitch == step ? Color.DARK_PURPLE : Color.gray)
                                .frame(width: stepSwitch == step ? 8.5 : 6, height: stepSwitch == step ? 8.5 : 6, alignment: .center)
                        }
                    }
                }
                
                
            } else {
                Button("GET STARTED") {
                    stepSwitch += 1
                }.buttonStyle(SubmitButton())
            }
        }
        .frame(width: svm.content_width, height: 20, alignment: .center)
        .padding(.vertical, 35)
    }
}

struct OnboardView_Preview: PreviewProvider {
    static var previews: some View {
        OnboardView()
            .environmentObject(ViewRouter())
            .environmentObject(Settings())
    }
}
