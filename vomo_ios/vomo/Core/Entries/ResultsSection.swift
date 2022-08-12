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
    @State private var showDetails = false
    
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
                
                signalProcessingSection
            }
            .padding(.trailing, 5)
        }
        .padding(.vertical)
        .foregroundColor(Color.black)
        .background(Color.TEAL)
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
    
    private var signalProcessingSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack(spacing: 0) {
                Text("Avg duration: ")
                    .font(._bodyCopy)
                Text("\(entries.avgDuration(criteria: retrieve.focusDay.toStringDay()), specifier: "%.2f")")
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
                Text("Avg intensity: ")
                    .font(._bodyCopy)
                Text("\(entries.avgIntensity(criteria: retrieve.focusDay.toStringDay()), specifier: "%.2f")")
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
            
            if showDetails {
                ForEach(entries.recordings, id: \.createdAt) { record in
                    if record.createdAt.toStringDay() == retrieve.focusDay.toStringDay() {
                        HStack(spacing: 0) {
                            Text("Recorded at: ")
                                .font(._bodyCopy)
                            Text(record.createdAt.toStringHour())
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
                        
                        HStack(spacing: 0) {
                            Text("Duration: ")
                                .font(._bodyCopy)
                            Text("\(record.duration, specifier: "%.2f") seconds")
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
                        
                        HStack(spacing: 0) {
                            Text("Intensity: ")
                                .font(._bodyCopy)
                            Text("\(record.intensity, specifier: "%.2f") decibels")
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
                    }
                }
                
                HStack {
                    Button(action: {
                        self.showDetails.toggle()
                    }) {
                        Text("Show less")
                            .font(._bodyCopyBold)
                    }
                    Spacer()
                }
            } else {
                HStack {
                    Button(action: {
                        self.showDetails.toggle()
                    }) {
                        Text("Show more")
                            .font(._bodyCopyBold)
                    }
                    Spacer()
                }
            }
        }
    }
}
/*
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
 */
