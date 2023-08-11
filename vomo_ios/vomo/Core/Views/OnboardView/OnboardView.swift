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
    @ObservedObject var settings = Settings.shared
    @EnvironmentObject var audioRecorder: AudioRecorder
    
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
                Spacer()
                GoalEntryView()
                Spacer()
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
                            if stepSwitch == 2 {
                                // For Let's Get Started.
                                if settings.voice_plan == 1 || settings.voice_plan == 2 {
                                    Button("Next") {
                                        stepSwitch += 1
                                    }.buttonStyle(NextButton())
                                } else {
                                    HStack(spacing: 5) {
                                        Text("Next")
                                            .foregroundColor(Color.gray)
                                            .font(._pageNavLink)
                                        GrayArrow()
                                    }
                                }
                            } else if stepSwitch == 3 && self.settings.voice_plan == 1 {
                                // Voice treatment target
                                if settings.focusSelection != 0 {
                                    Button("Next") {
                                        stepSwitch += 1
                                    }.buttonStyle(NextButton())
                                } else {
                                    HStack(spacing: 5) {
                                        Text("Next")
                                            .foregroundColor(Color.gray)
                                            .font(._pageNavLink)
                                        GrayArrow()
                                    }
                                }
                            } else if stepSwitch == 3 && self.settings.voice_plan == 2 {
                                // Custom target
                                if (!self.settings.vowel && !self.settings.mpt && !self.settings.rainbow && !self.settings.vhi && !self.settings.vocalEffort && !self.settings.botulinumInjection) {
                                    HStack(spacing: 5) {
                                        Text("Next")
                                            .foregroundColor(Color.gray)
                                            .font(._pageNavLink)
                                        GrayArrow()
                                    }
                                } else {
                                    Button("Next") {
                                        stepSwitch += 1
                                    }.buttonStyle(NextButton())
                                }
                            } else if stepSwitch == 1 {
                                // Sign up page
                                if settings.firstName != "" && settings.lastName != "" && settings.sexAtBirth != "" && settings.gender != "" {
                                    Button("Next") {
                                        stepSwitch += 1
                                    }.buttonStyle(NextButton())
                                } else {
                                    HStack(spacing: 5) {
                                        Text("Next")
                                            .foregroundColor(Color.gray)
                                            .font(._pageNavLink)
                                        GrayArrow()
                                    }
                                }
                            } else {
                                Button("Next") {
                                    stepSwitch += 1
                                }.buttonStyle(NextButton())
                            }
                        } else if stepSwitch == 4 {
                            if settings.numWeeks != 0 {
                                Button("Done") {
                                    viewRouter.currentPage = .home
                                    settings.edited_before = true
                                }.buttonStyle(NextButton())
                            } else {
                                Button("Skip") {
                                    viewRouter.currentPage = .home
                                    settings.edited_before = true
                                }.buttonStyle(SkipButton())
                            }
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
                    
                    Logging.defaultLog.notice("Recording permission status \(audioRecorder.grantedPermission())")
                    
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
            .environmentObject(ViewRouter.shared)
    }
}
