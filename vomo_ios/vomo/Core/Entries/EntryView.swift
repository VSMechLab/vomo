//
//  EntryView.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/18/22.
//

import SwiftUI

struct EntryView: View {
    @EnvironmentObject var entries: Entries
    
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    
    @State private var active = -1
    
    let logo = "VM_record-nav-icon"
    let dropdown = "VM_Dropdown-Btn"
    let focus: Date
    
    var body: some View {
        VStack {
            ProfileButton()
                .padding(.horizontal, 15)
            
            HStack {
                Text("Entry for ")
                    .font(._headline)
                    .padding(.leading, 30)
                
                Spacer()
            }
           
            HStack {
                Text("\(focus.toString(dateFormat: "MMM d, yyyy"))")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.center)
                    .padding(.leading, 30)
                
                Spacer()
            }
            
            HStack {
                Text("Review and listen to your recordings here")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.center)
                    .padding(.leading, 30)
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                if self.active == 1 {
                    if !entries.recordingsPresent {
                        RecordingSection(audioRecorder: AudioRecorder(), active: self.$active, focus: self.focus, type: "RECORDING")
                    } else {
                        FieldOfEntry(active: self.$active, type: "RECORDING")
                    }
                } else {
                    FieldOfEntry(active: self.$active, type: "RECORDING")
                }
                
                Divider()
                
                if self.active == 2 {
                    if !entries.questioinnairesPresent {
                        QuestionnaireSection(audioRecorder: AudioRecorder(), active: self.$active, focus: self.focus, type: "RESULTS")
                    } else {
                        FieldOfEntry(active: self.$active, type: "RESULTS")
                    }
                } else {
                    FieldOfEntry(active: self.$active, type: "RESULTS")
                }
                
                Divider()
                
                if self.active == 3 {
                    if !entries.journalsPresent {
                        JournalSection(audioRecorder: AudioRecorder(), active: self.$active, focus: self.focus, type: "JOURNALS")
                    } else {
                        FieldOfEntry(active: self.$active, type: "JOURNALS")
                    }
                } else {
                    FieldOfEntry(active: self.$active, type: "JOURNALS")
                }
            }
            .frame(width: 350)
            .background()
            .cornerRadius(8)
            .shadow(radius: 2)
            .padding()
            
            Spacer()
            
            Button("clear-all") {
                entries.recordings.removeAll()
            }.foregroundColor(Color.DARK_PURPLE)
            
            Spacer()
        }
    }
}

struct FieldOfEntry: View {
    @Binding var active: Int
    
    let type: String
    
    let logo = "VM_record-nav-icon"
    let dropdown = "VM_Dropdown-Btn"
    
    var body: some View {
        HStack {
            Image(logo)
                .resizable()
                .frame(width: 42, height: 42, alignment: .center)
                .shadow(radius: 2)
            
            VStack(alignment: .leading) {
                Text(type)
                    .font(._coverBodyCopy)
                
                Text("XXX RECORDINGS")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
            }
            
            Spacer()
            
            Button(action: {
                if type == "RECORDING" {
                    self.active = 1
                } else if type == "RESULTS" {
                    self.active = 2
                } else if type == "JOURNALS" {
                    self.active = 3
                }
            }) {
                Image(dropdown)
                    .resizable()
                    .frame(width: 25, height: 10, alignment: .center)
            }
        }
        .padding()
    }
}
