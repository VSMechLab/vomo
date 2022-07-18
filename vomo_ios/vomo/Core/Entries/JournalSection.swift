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
    
    let logo = "VoMo-App-Assets_2_journals-gfx"
    let dropdown = "VM_Dropdown-Btn"
    
    var body: some View {
        HStack(alignment: .top) {
            Image(logo)
                .resizable()
                .frame(width: 55, height: 55, alignment: .center)
                .padding(.leading, 4)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(type)
                        .font(._fieldLabel)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            self.active = 0
                        }
                    }) {
                        Image(dropdown)
                            .resizable()
                            .rotationEffect(.degrees(-180))
                            .frame(width: 20, height: 8.5, alignment: .center)
                            .padding(.trailing, 5)
                    }
                }
                
                // vomoJournalText
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(entries.journals) { journal in
                        if focus.toString(dateFormat: "MM, dd, yyyy") == journal.createdAt.toString(dateFormat: "MM, dd, yyyy") {
                            Text("\(journal.noteName)")
                                .font(._fieldCopyRegular)
                            
                            Text("\(journal.note)")
                                .font(._fieldCopyRegular)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
        .padding(.vertical)
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
