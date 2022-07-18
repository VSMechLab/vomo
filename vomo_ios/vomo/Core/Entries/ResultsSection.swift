//
//  ResultsSection.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/18/22.
//

import SwiftUI

struct ResultsSection: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @EnvironmentObject var retrieve: Retrieve
    @Binding var active: Int
    
    let focus: Date
    let type: String
    
    let logo = "VoMo-App-Assets_2_scores-gfx"
    let dropdown = "VM_Dropdown-Btn"
    let info_img = "VM_info-icon"
    @State private var infoPopup = false
    
    var body: some View {
        HStack(alignment: .top) {
            headerSection
            
            VStack(alignment: .leading, spacing: 3) {
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
                    }
                }
                
                HStack(spacing: 0) {
                    Text("Mean Pitch Vowel: ")
                        .font(._bodyCopy)
                    Text("XX")
                        .font(._bodyCopyBold)
                    Spacer()
                    Button(action: {
                        self.infoPopup.toggle()
                    }) {
                        Image(info_img)
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                }
                
                Color.white.frame(height: 1)
                
                HStack(spacing: 0) {
                    Text("HNR Vowel: ")
                        .font(._bodyCopy)
                    Text("XX")
                        .font(._bodyCopyBold)
                    Spacer()
                    Button(action: {
                        self.infoPopup.toggle()
                    }) {
                        Image(info_img)
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                }
                
                Color.white.frame(height: 1)
                
                HStack(spacing: 0) {
                    Text("VRQOL: ")
                        .font(._bodyCopy)
                    Text("XX")
                        .font(._bodyCopyBold)
                    Spacer()
                    Button(action: {
                        self.infoPopup.toggle()
                    }) {
                        Image(info_img)
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                }
                
                Color.white.frame(height: 1)
                
                ForEach(audioRecorder.recordings, id: \.createdAt) { record in
                    if record.createdAt.toStringDay() == retrieve.focusDay.toStringDay() {
                        HStack {
                            Text("Record \(record.createdAt.toStringHour())")
                            
                            Spacer()
                            
                            Text("Function: ")
                        }
                        .font(._bodyCopy)
                        .onAppear {
                            audioRecorder.signalProcess(file: record.fileURL)
                        }
                    }
                }
            }
            .padding(.trailing, 5)
        }
        .padding(.vertical)
        .foregroundColor(Color.black)
        .background(Color.TEAL)
    }
    
    func retrieveAudioURL(createdAt: Date) -> URL {
        var returnURL: URL = URL(string: "https://apple.com/")!
        
        for recording in audioRecorder.recordings {
            if recording.createdAt == createdAt {
                returnURL = recording.fileURL
            }
        }
        
        return returnURL
    }
}

extension ResultsSection {
    private var headerSection: some View {
        VStack {
            Image(logo)
                .resizable()
                .frame(width: 55, height: 55)
                .padding(.leading, 5)
        }
    }
}
/*
List {
    if !entries.questioinnairesPresent {
        ForEach(entries.questionnaires) { questionnaire in
            if focus.toString(dateFormat: "MM, dd, yyyy") == questionnaire.createdAt.toString(dateFormat: "MM, dd, yyyy") {
                HStack {
                    Text("Date: \(questionnaire.createdAt)")
                    
                    Spacer()
                    
                    VStack {
                        Group {
                            Text("Q1: \(questionnaire.q1)")
                            Text("Q2: \(questionnaire.q2)")
                            Text("Q3: \(questionnaire.q3)")
                        }
                    }
                }
            }
        }
    }
}*/
