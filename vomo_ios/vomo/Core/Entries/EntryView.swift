//
//  EntryView.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/18/22.
//

import SwiftUI

struct EntryView: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var retrieve: Retrieve
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    @State private var active = -1
    
    
    @State private var svm = SharedViewModel()
    
    let logo = "VoMo-App-Assets_2_journals-gfx"//"VM_record-nav-icon"
    let dropdown = "VM_Dropdown-Btn"
    let focus: Date
    
    let recording_logo = "VM_record-nav-ds-icon"
    let scores_logo = "VoMo-App-Assets_2_scores-gfx"
    let journal_logo = "VoMo-App-Assets_2_journals-gfx"
    
    let folder_img = "VoMo-App-Assets_2_past-fldr-gfx"
    
    @State private var showMore = false
    
    var body: some View {
        VStack {
            ProfileButton()
                .padding(.horizontal, 15)
            
            HStack {
                Text("Entry for ")
                    .font(._headline)
                
                Spacer()
            }
            
            HStack {
                Text("Review your recordings, scores, and journal entries")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            
            HStack {
                Text("\(retrieve.focusDay.toString(dateFormat: "MMM d, yyyy"))")
                Spacer()
            }
            .font(._fieldLabel)
            .foregroundColor(Color.BODY_COPY)
            .padding(.bottom, -5)
            
            VStack(spacing: 0) {
                if self.active == 1 {
                    if !entries.recordingsPresent {
                        RecordingSection(active: self.$active, focus: self.focus, type: "RECORDINGS")
                    } else {
                        FieldOfEntry(active: self.$active, type: "RECORDINGS", logo: recording_logo, text: "Expand to playback previous recordings")
                    }
                } else {
                    FieldOfEntry(active: self.$active, type: "RECORDINGS", logo: recording_logo, text: "Expand to playback previous recordings")
                }
                
                Divider()
                
                if self.active == 2 {
                    if !entries.recordingsPresent {
                        ResultsSection(active: self.$active, focus: self.focus, type: "RESULTS")
                    } else {
                        FieldOfEntry(active: self.$active, type: "RESULTS", logo: scores_logo, text: "View your acoustic and questionnaire scores")
                    }
                } else {
                    FieldOfEntry(active: self.$active, type: "RESULTS", logo: scores_logo, text: "View your acoustic and questionnaire scores")
                }
                
                Divider()
                
                if self.active == 3 {
                    if !entries.journalsPresent {
                        JournalSection(audioRecorder: AudioRecorder(), active: self.$active, focus: self.focus, type: "JOURNALS")
                    } else {
                        FieldOfEntry(active: self.$active, type: "JOURNALS", logo: journal_logo, text: "View your journal entries here")
                    }
                } else {
                    FieldOfEntry(active: self.$active, type: "JOURNALS", logo: journal_logo, text: "View your journal entries here")
                }
            }
            .transition(.slide)
            .background()
            .cornerRadius(9)
            .shadow(radius: 2)
            .padding(.top)
            
            if showMore {
                VStack(alignment: .leading) {
                    Text("2022")
                        .foregroundColor(Color.black)
                        .font(._fieldLabel)
                    Color.TEAL.frame(width: 317.5, height: 7)
                    
                    List {
                        ForEach(audioRecorder.uniqueDays().reversed(), id: \.self) { day in
                            Button(action: {
                                self.retrieve.focusDay = day
                            }) {
                                Text("\(day.toStringDay())")
                                    .font(retrieve.focusDay == day ? ._fieldLabel : ._pageNavLink)
                                    .foregroundColor(retrieve.focusDay == day ? Color.DARK_PURPLE : Color.BODY_COPY)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .listRowInsets(.none)
                    .listRowSeparator(.hidden)
                    .frame(maxHeight: 150)
                    
                    Spacer()
                    
                    Button("show less") {
                        withAnimation {
                            self.showMore.toggle()
                        }
                    }
                    .font(._fieldLabel)
                    .foregroundColor(Color.DARK_PURPLE)
                    
                    Spacer()
                }
                .transition(.slide)
            } else {
                Button("show more") {
                    withAnimation {
                        self.showMore.toggle()
                    }
                }
                .font(._fieldLabel)
                .foregroundColor(Color.DARK_PURPLE)
                .transition(.slide)
            }
            
            Spacer()
        }.frame(width: svm.content_width)
    }
}

struct FieldOfEntry: View {
    @Binding var active: Int
    
    let type: String
    let logo: String
    let text: String
    let dropdown = "VM_Dropdown-Btn"
    
    var body: some View {
        HStack {
            Image(logo)
                .resizable()
                .frame(width: 55, height: 55, alignment: .center)
                .padding(.leading, 4)
            
            VStack(alignment: .leading) {
                Text(type)
                    .font(._fieldLabel)
                
                Text(text)
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Button(action: {
                if type == "RECORDINGS" {
                    withAnimation {
                        self.active = 1
                    }
                } else if type == "RESULTS" {
                    withAnimation {
                        self.active = 2
                    }
                } else if type == "JOURNALS" {
                    withAnimation {
                        self.active = 3
                    }
                }
            }) {
                Image(dropdown)
                    .resizable()
                    .frame(width: 20, height: 8.5, alignment: .center)
            }
        }
        .frame(height: 45)
        .padding(.vertical)
        .padding(.trailing, 5)
        
    }
}
