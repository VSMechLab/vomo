//
//  HomeView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        VStack(spacing: 20) {
            Text("Home")
                .bold()
            
            Button("Settings") {
                viewRouter.currentPage = .settings
            }
            
            Button("Record") {
                viewRouter.currentPage = .record
            }
            
            Button("Questionnaire") {
                viewRouter.currentPage = .questionnaire
            }
            
            Button("Journal") {
                viewRouter.currentPage = .journal
            }
            
            Button("My Progress") {
                viewRouter.currentPage = .progress
            }
            
            Button("Intervention Log") {
                viewRouter.currentPage = .intervention
            }
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
/*
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
                    Text("Hi, \(username)")
                    Button(action: {
                        viewRouter.currentPage = .playground
                    }) {
                        //Text(username)
                    }
                        .foregroundColor(Color.DARK_PURPLE)
                    Spacer()
                }
                .font(._headline)
                .frame(width: svm.content_width)
                
                Button("See entries") {
                    print("\n\n\n\nEntries and recordings\n")
                    for entry in entries.recordings {
                        print("Entry: \(entry.createdAt)")
                    }
                    for audio in audioRecorder.recordings {
                        print("Audio: \(audio.createdAt)")
                    }
                    print("\n\n\n\n")
                }
                Button(action: {
                    viewRouter.currentPage = .voiceQuestionView
                }) {
                    HStack(spacing: 0) {
                        Text("You are on \(prompt[focusSelection]) track ")
                        Text("Edit.")
                            .underline()
                        Spacer()
                    }
                    .foregroundColor(Color.DARK_PURPLE)
                }
                .font(._bodyCopy)
                .frame(width: svm.content_width)
                
                Graph()
                
                HomeWidget()
                    .frame(width: svm.content_width)
                
                totalGoalsSection
                
                entriesSection
                
                //demoSection
                
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
            }.frame(width: svm.content_width)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    Color.white.frame(width: (UIScreen.main.bounds.width - svm.content_width) / 2)
                    
                    if audioRecorder.recordings.count == 0 {
                        Button(action: {
                            self.viewRouter.currentPage = .recordView
                        }) {
                            EmptyTile()
                        }
                    } else {
                        ForEach(entries.uniqueDays().reversed(), id: \.self) { entry in
                            Button(action: {
                                viewRouter.currentPage = .entryView
                                entries.focusDay = entry
                            }) {
                                RecordingsTile(date: entry)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var demoSection: some View {
        VStack {
            Spacer()
            Button("dev view") { self.viewRouter.currentPage = .playground }
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
*/
