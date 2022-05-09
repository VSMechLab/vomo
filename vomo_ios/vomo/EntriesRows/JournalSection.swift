//
//  JournalSection.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/18/22.
//

import SwiftUI

struct JournalSection: View {
    @EnvironmentObject var entries: Entries
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @Binding var active: Int
    
    let focus: Date
    let type: String
    
    let logo = "VM_record-nav-icon"
    let dropdown = "VM_Dropdown-Btn"
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Image(logo)
                    .resizable()
                    .frame(width: 42, height: 42, alignment: .center)
                    .shadow(radius: 2)
                
                Spacer()
                
                Text("")
            }.frame(height: 100)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(type)
                        .font(Font.vomoSectionHeader)
                    
                    Spacer()
                    
                    Button(action: {
                        self.active = 0
                    }) {
                        Image(dropdown)
                            .resizable()
                            .rotationEffect(.degrees(-180))
                            .frame(width: 25, height: 10, alignment: .center)
                    }
                }
                
                // vomoJournalText
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(entries.journals) { journal in
                        if focus.toString(dateFormat: "MM, dd, yyyy") == journal.createdAt.toString(dateFormat: "MM, dd, yyyy") {
                            Text("\(journal.noteName)")
                                .font(Font.vomoJournalTextTitle)
                            
                            Text("\(journal.note)")
                                .font(Font.vomoJournalText)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.BLUE.opacity(0.45))
    }
}

/*
 
 List {
     if !entries.journalsPresent {
         ForEach(entries.journals) { journal in
             if focus.toString(dateFormat: "MM, dd, yyyy") == journal.createdAt.toString(dateFormat: "MM, dd, yyyy") {
                 VStack {
                     Text("NoteName: \(journal.noteName)")
                     
                     Spacer()
                     
                     Text("Note: \(journal.note)")
                 }
             }
         }
     }
 }
 
 */
