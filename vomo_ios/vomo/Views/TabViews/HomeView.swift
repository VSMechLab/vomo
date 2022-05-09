//
//  HomeView.swift
//  VoMo
//
//  Created by Neil McGrogan on 1/20/22.
//

import SwiftUI
import simd
import Foundation

struct HomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var recordingState: RecordingState
    
    let background_img = "VM_7-cover-waves-gfx"
    let content_width = 317.5
    
    @State private var focusSelection = UserDefaults.standard.integer(forKey: "focus_selection")
    let edited_before = UserDefaults.standard.bool(forKey: "edited_before")
    let username = UserDefaults.standard.string(forKey: "name") ?? ""
    
    let prompt = ["a custom", "the Spasmodic Dysphonia", "the Recurrent Pappiloma", "the Parkinson's Disease", "the Gender-Affirming Care", "the Vocal Fold/Paresis", "no"]
    
    @State private var visitPopup = false
    
    var body: some View {
        ZStack {
            HomeBackground()
            
            ScrollView(showsIndicators: false) {
                ProfileButton()
                
                HStack(spacing: 0) {
                    Text("Hi, ")
                    Text(username)
                        .foregroundColor(Color.DARK_PURPLE)
                    Spacer()
                }
                .font(Font.vomoTitle)
                .frame(width: content_width)
                
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
                .font(Font.vomoLightBodyText)
                .frame(width: content_width)
                
                HomeWidget()
                
                Group {
                    HStack(spacing: 0) {
                        Text("Total Goals")
                            .font(Font.vomoHeader)
                        Spacer()
                        Button(action: {}) {
                            HStack {
                                Text("Adjust Goals ->")
                            }
                            .font(Font.vomoActivityRowTitle)
                            .foregroundColor(Color.DARK_PURPLE)
                        }
                    }
                    TotalGoalsRow(audioRecorder: AudioRecorder(), visitPopup: self.$visitPopup)
                }.frame(width: content_width)
                
                Group {
                    HStack(spacing: 0) {
                        Text("Entries")
                            .font(Font.vomoHeader)
                        Spacer()
                        Button(action: {}) {
                            HStack {
                                Text("Details ->")
                            }
                            .font(Font.vomoActivityRowTitle)
                            .foregroundColor(Color.DARK_PURPLE)
                        }
                    }.frame(width: content_width)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            Color.white.frame(width: (UIScreen.main.bounds.width - content_width) / 2)
                            ForEach(entries.uniqueDays().reversed(), id: \.self) { entry in
                                Button(action: {
                                    viewRouter.currentPage = .entryView
                                    recordingState.selectedEntry = entry
                                }) {
                                    RecordingsTile(date: entry)
                                }
                            }
                        }
                    }
                }
                
                Group {
                    HStack(spacing: 0) {
                        Text("Data")
                            .font(Font.vomoHeader)
                        
                        Spacer()
                    }.frame(width: content_width)
                    
                    HStack(alignment: .top, spacing: 5) {
                        AmplitudeGraph()
                        
                        Spacer()
                        
                        PitchGraph()
                    }
                    .font(Font.vomoCardnHeader)
                    .foregroundColor(.white)
                    .frame(width: content_width)
                }
                
                VStack {
                    Spacer()
                    Button("dev view") { self.viewRouter.currentPage = .playground }
                    Spacer()
                }
                .padding(.bottom, 100)
            }
            
            if visitPopup {
                HomePopup(visitPopup: self.$visitPopup)
            }
        }.onAppear() {
            entries.getItems()
        }
    }
}

struct HomePopup: View {
    @Binding var visitPopup: Bool
    
    let button_img = "VM_Gradient-Btn"
    let upcoming = "Upcoming"
    let past = "past"
    
    @State private var selected = "Upcoming"
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                self.visitPopup.toggle()
            }) {
                Color.white.opacity(0)
            }
            HStack(spacing: 0) {
                Button(action: {
                    self.visitPopup.toggle()
                }) {
                    Color.white.opacity(0).frame(height: 450)
                }
                
                ZStack {
                    Color.white.frame(width: 275, height: 450)
                        .background(Color.white)
                        .shadow(color: Color.gray, radius: 0.9)
                    
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                self.visitPopup.toggle()
                            }) {
                                Text("X")
                                    .font(Font.vomoHeader)
                                    .foregroundColor(Color.BODY_COPY)
                            }
                        }
                        
                        HStack(spacing: 0) {
                            Text("Visit Log")
                                .font(Font.vomoHeader)
                            Spacer()
                        }
                        
                        ZStack {
                            Color.INPUT_FIELDS.cornerRadius(10)
                            
                            VStack {
                                Button("") {}
                                    .buttonStyle(SubmissionButton(label: "+ New Visit"))
                                    .padding(.top, 5)
                                
                                HStack(spacing: 0) {
                                    VStack(alignment: .leading) {
                                        Text("Upcoming")
                                            .foregroundColor(selected == upcoming ? Color.black : Color.gray)
                                        if selected == upcoming {
                                            Color.TEAL.frame(width: 120, height: 7)
                                        } else {
                                            Color.gray.frame(width: 120, height: 7)
                                        }
                                    }
                                    .onTapGesture {
                                        if selected != upcoming {
                                            self.selected = upcoming
                                        }
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("Past")
                                            .foregroundColor(selected == past ? Color.black : Color.gray)
                                        if selected == past {
                                            Color.TEAL.frame(width: 120, height: 7)
                                        } else {
                                            Color.gray.frame(width: 120, height: 7)
                                        }
                                    }
                                    .onTapGesture {
                                        if selected != past {
                                            self.selected = past
                                        }
                                    }
                                }
                                .font(Font.vomoSectionHeader)
                                
                                if selected == upcoming {
                                    HStack {
                                        Text("Type of Visit")
                                            .font(Font.vomoSectionHeader)
                                        Spacer()
                                    }
                                    
                                    
                                    ScrollView(showsIndicators: false) {
                                        ForEach(1..<5) { index in
                                            VisitTypeRow(time: .now + TimeInterval(86400 * index * index * index), number: 10/19/2022, text: "Therapy Lorem Ipsorm..", odd: true, img: "highlighter")
                                            VisitTypeRow(time: .now + TimeInterval(86400 * index * index * index + 172800), number: 10/19/2022, text: "Therapy Lorem Ipsorm..", odd: false, img: "highlighter")
                                        }
                                    }
                                    .font(Font.vomoSectionHeader)
                                } else {
                                    ScrollView(showsIndicators: false) {
                                        ForEach(1..<5) { index in
                                            VisitTypeRow(time: .now - TimeInterval(86400 * index * index * index), number: 10/19/2022, text: "Therapy Lorem Ipsorm..", odd: true, img: "plus.square")
                                            VisitTypeRow(time: .now - TimeInterval(86400 * index * index * index + 172800), number: 10/19/2022, text: "Therapy Lorem Ipsorm..", odd: false, img: "plus.square")
                                        }
                                    }
                                    .font(Font.vomoSectionHeader)
                                }
                            }.padding(.horizontal, 3)
                        }
                    }
                    .padding()
                    .frame(width: 275, height: 450)
                }
                
                
                Button(action: {
                    self.visitPopup.toggle()
                }) {
                    Color.white.opacity(0).frame(height: 450)
                }
            }
            Button(action: {
                self.visitPopup.toggle()
            }) {
                Color.white.opacity(0)
            }
        }.padding()
    }
}

struct VisitTypeRow: View {
    let time: Date
    let number: Int
    let text: String
    let odd: Bool
    let img: String
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text("\(time.toStringDay())")
                
                Text("\(time.toStringHour())")
            }
            
            Spacer()
            
            Text("\(number)")
            
            Text("\(text)")
            
            Button(action: {
                
            }) {
                Image(systemName: img)
                    .background(odd ? Color.INPUT_FIELDS : Color.white)
                    .cornerRadius(3)
            }
        }
        .padding(.horizontal, 3)
        .foregroundColor(Color.gray)
        .background(odd ? Color.white : Color.INPUT_FIELDS)
        .cornerRadius(5)
        
    }
}
