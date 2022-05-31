//
//  ViewController.swift
//  VoMo
//
//  Created by Neil McGrogan on 1/20/22.
//

import SwiftUI
import UIKit

struct ViewController: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var keyboard: Keyboard
    @EnvironmentObject var recordingState: RecordingState
    
    @State private var onboarded = true
    
    let home_img = "VM_home-nav-icon"
    let journal_img = "VM_notes-nav-icon"
    let mic_img = "VM_record-nav-ds-icon"
    let stop_img = "VM_stop-nav-ds-icon"
    let start_img = "VM_record-nav-ds-icon"
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 0) {
                switch viewRouter.currentPage {
                case .onboardView:
                    OnboardingView()
                case .personalQuestionView:
                    PersonalQuestionView()
                case.voiceQuestionView:
                    VoiceQuestionView()
                case .homeView:
                    HomeView()
                case .recordView:
                    ContentView(audioRecorder: AudioRecorder())
                case .journalView:
                    JournalView()
                case .profileView:
                    ProfileView()
                case .playground:
                    APIPlayground()
                case .targetView:
                    TargetView()
                case .customTargetView:
                    CustomTargetView()
                case .entryView:
                    EntryView(audioRecorder: AudioRecorder(), focus: self.recordingState.selectedEntry)
                case .activityView:
                    Activityiew()
                case .scoresView:
                    ScoresView()
                }
                Spacer()
            }
            
            VStack(spacing: 0) {
                Color.white.edgesIgnoringSafeArea(.top).frame(height: 0)
                Spacer()
                
                if (viewRouter.currentPage != .onboardView) && (viewRouter.currentPage != .personalQuestionView) && (viewRouter.currentPage != .voiceQuestionView) && (viewRouter.currentPage != .targetView) && (viewRouter.currentPage != .customTargetView) {
                    Group {
                        Divider()
                        HStack(spacing: 0) {
                            Button("") {
                                viewRouter.currentPage = .homeView
                                self.recordingState.recordingState = 0
                            }.buttonStyle(TabIcons(image: home_img))
                            
                            Button(action: {
                                if viewRouter.currentPage == .recordView {
                                    if recordingState.recordingState == 0 {
                                        self.recordingState.recordingState = 1
                                    } else if recordingState.recordingState == 1 {
                                        self.recordingState.recordingState = 2
                                    }
                                } else {
                                    viewRouter.currentPage = .recordView
                                }
                            }) {
                                ZStack {
                                    Image(recordingState.recordingState == 1 ? stop_img : start_img)
                                        .resizable()
                                        .frame(width: 125, height: 125)
                                        .padding(.top, -50)
                                        .shadow(radius: 1)
                                    
                                    Text("\(self.recordingState.recordingState)").hidden()
                                }
                            }
                            
                            Button("") {
                                viewRouter.currentPage = .journalView
                                self.recordingState.recordingState = 0
                            }.buttonStyle(TabIcons(image: journal_img))
                        }
                    }
                    .background(Color.white)
                    .padding(.bottom, -25)
                    .shadow(radius: 1)
                }
            }.frame(width: UIScreen.main.bounds.width)
        }
    }
}
