//
//  HomeView.swift
//  VoMo
//
//  Created by Neil McGrogan on 1/20/22.
//

import SwiftUI
import simd
import Foundation
import Combine
import AVFoundation

struct HomeView: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var svm = SharedViewModel()
    @State private var vm = HomeViewModel()
    
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var retrieve: Retrieve
    @EnvironmentObject var recordingState: RecordState
    
    @State private var focusSelection = UserDefaults.standard.integer(forKey: "focus_selection")
    @State private var visitPopup = false
    
    let edited_before = UserDefaults.standard.bool(forKey: "edited_before")
    let username = UserDefaults.standard.string(forKey: "first_name") ?? ""
    let prompt = ["a custom", "the Spasmodic Dysphonia", "the Recurrent Respiratory Pappiloma", "the Parkinson's Disease", "the Gender-Affirming Voice Care", "the Vocal Fold/Paresis", "the default"]
    let forwardArrow = "VoMo-App-Assets_2_arrow-gif"
    let background_img = "VM_7-cover-waves-gfx"
    
    var body: some View {
        ZStack {
            HomeBackground()
            
            ScrollView(showsIndicators: false) {
                ProfileButton()
                
                HStack(spacing: 0) {
                    Text("Hi, ")
                    Button(action: {
                        viewRouter.currentPage = .playground
                    }) {
                        Text(username)
                    }
                        .foregroundColor(Color.DARK_PURPLE)
                    Spacer()
                }
                .font(._headline)
                .frame(width: svm.content_width)
                
                HStack(spacing: 0) {
                    Text("You are on \(prompt[focusSelection]) track ")
                        .foregroundColor(Color.BODY_COPY)
                    Button(action: {
                        viewRouter.currentPage = .voiceQuestionView
                    }) {
                        Text("Edit.")
                            .underline()
                            .foregroundColor(Color.DARK_PURPLE)
                    }
                    Spacer()
                }
                .font(._bodyCopy)
                .frame(width: svm.content_width)
                
                HomeWidget()
                    .frame(width: svm.content_width)
                
                totalGoalsSection
                
                entriesSection
                
                scoresSection
                
                demoSection
                
                .padding(.bottom, 100)
            }
            
            ZStack {
                if visitPopup {
                    Color.white.opacity(0.1).edgesIgnoringSafeArea(.all)
                    HomePopup(visitPopup: self.$visitPopup)
                        .shadow(color: Color.gray.opacity(0.2), radius: 1, x: 0, y: 0)
                        .shadow(radius: 1)
                }
            }
            .transition(.scale)
        }.onAppear() {
            entries.getItems()
        }
    }
}

extension HomeView {
    private var totalGoalsSection: some View {
        Group {
            HStack(spacing: 0) {
                Text("Total Goals")
                    .font(._subHeadline)
                Spacer()
                /*
                Button(action: {
                    viewRouter.currentPage = .activityView
                }) {
                    HStack(spacing: 1) {
                        Text("Adjust Goals")
                        Image(forwardArrow)
                            .resizable()
                            .frame(width: 17.5, height: 5)
                    }
                    .font(._CTALink)
                    .foregroundColor(Color.DARK_PURPLE)
                }
                */
            }
            TotalGoalsRow(audioRecorder: AudioRecorder(), visitPopup: self.$visitPopup)
        }.frame(width: svm.content_width)
    }
    
    private var entriesSection: some View {
        Group {
            HStack(spacing: 0) {
                Text("Entries")
                    .font(._subHeadline)
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 1) {
                        Button(action: {
                            if !audioRecorder.recordings.isEmpty {
                                viewRouter.currentPage = .entryView
                                self.recordingState.selectedEntry = entries.recordings.last?.createdAt ?? .now
                            }
                        }) {
                            Text("Details")
                        }
                        Image(forwardArrow)
                            .resizable()
                            .frame(width: 17.5, height: 5)
                    }
                    .font(._CTALink)
                    .foregroundColor(Color.DARK_PURPLE)
                }
            }.frame(width: svm.content_width)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    Color.white.frame(width: (UIScreen.main.bounds.width - svm.content_width) / 2)
                    /*ForEach(entries.uniqueDays().reversed(), id: \.self) { entry in
                        Button(action: {
                            viewRouter.currentPage = .entryView
                            recordingState.selectedEntry = entry
                        }) {
                            RecordingsTile(date: entry)
                        }
                    }*/
                    if audioRecorder.recordings.count == 0 {
                        Button(action: {
                            self.viewRouter.currentPage = .recordView
                        }) {
                            EmptyTile()
                        }
                    } else {
                        ForEach(audioRecorder.uniqueDays().reversed(), id: \.self) { day in
                            Button(action: {
                                self.retrieve.focusDay = day
                                viewRouter.currentPage = .entryView
                            }) {
                                RecordingsTile(date: day)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var scoresSection: some View {
        Group {
            if !audioRecorder.recordings.isEmpty {
                HStack(spacing: 0) {
                    Text("Scores")
                        .font(._subHeadline)
                    
                    Spacer()
                }.frame(width: svm.content_width)
                
                HStack(alignment: .top, spacing: 5) {
                    Button(action: {
                        self.viewRouter.currentPage = .scoresView
                    }) {
                        HomePitchGraph()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // CHANGED: fixed destination to activity/goals page
                        self.viewRouter.currentPage = .activityView
                    }) {
                        HomeActivityGraph()
                    }
                }
                .font(._fieldLabel)
                .foregroundColor(.white)
                .frame(width: svm.content_width)
            }
        }
    }
    
    private var demoSection: some View {
        VStack {
            Spacer()
            //Button("dev view") { self.viewRouter.currentPage = .playground }
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AudioRecorder())
            .environmentObject(Entries())
    }
}
