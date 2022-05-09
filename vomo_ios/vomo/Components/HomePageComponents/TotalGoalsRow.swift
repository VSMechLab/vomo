//
//  TotalGoalsRow.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/2/22.
//

import SwiftUI

struct TotalGoalsRow: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var entries: Entries
    
    let recordings_img = "VM_7-recording-icon"
    let start_img = "VM_7-star-icon"
    let complete_img = "VM_7-complete-icon"
    let info_img = "VM_info-icon"
    
    @State private var score = 2
    @State private var comp_profile = 1
    
    @Binding var visitPopup: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .center) {
                ZStack {
                    VStack {
                        ZStack {
                            ProgressBar(level: self.audioRecorder.recordings.count, color: Color.BLUE)
                            
                            Image(start_img)
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                        }
                        
                        Text("XX DAYS")
                            .font(Font.vomoActivityRowTitle)
                            .foregroundColor(Color.BLUE)
                        
                        Text("SINCE LAST VISIT")
                            .font(Font.vomoActivityRowSubtitle)
                            .foregroundColor(Color.BODY_COPY)
                    }
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Spacer()
                            Button(action: {
                                self.visitPopup.toggle()
                            }) {
                                Image(info_img)
                                    .resizable()
                                    .frame(width: 10, height: 10)
                            }
                        }
                        Spacer()
                    }
                }
            }.frame(width: 100)
            
            VStack(alignment: .center) {
                Button(action: {
                    viewRouter.currentPage = .entryView
                }) {
                    ZStack {
                        ProgressBar(level: self.score, color: Color.DARK_PURPLE)
                        
                        Image(recordings_img)
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                }
                
                Text("\(daysAgo().formatted()) DAYS")
                    .font(Font.vomoActivityRowTitle)
                    .foregroundColor(Color.DARK_PURPLE)
                
                Text("SINCE LAST ENTRY")
                    .font(Font.vomoActivityRowSubtitle)
                    .foregroundColor(Color.BODY_COPY)
            }.frame(width: 100)
            
            VStack(alignment: .center) {
                ZStack {
                    ProgressBar(level: self.comp_profile, color: Color.TEAL)
                    
                    Image(complete_img)
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                }
                
                Text("\(self.comp_profile * 10)%")
                    .font(Font.vomoActivityRowTitle)
                    .foregroundColor(Color.TEAL)
                
                Text("COMPLETED PROFILE")
                    .font(Font.vomoActivityRowSubtitle)
                    .foregroundColor(Color.BODY_COPY)
            }.frame(width: 100)
        }.foregroundColor(.white)
            .padding(.horizontal)
    }
    
    func daysAgo() -> Double {
        let from: Date = entries.recordings.last?.createdAt ?? .now
        let to: Date = .now

        let delta = to - from
        return delta
    }
}

struct ProgressBar: View {
    var level: Int
    var color: Color
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 7)
                    .foregroundColor(Color.gray)
                    .opacity(0.10)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress(), 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: 1)
                    .opacity(0.90)
            }.frame(width: 60, height: 60, alignment: .center)
        }
    }
    
    func progress() -> CGFloat {
        return CGFloat(CGFloat(level) / CGFloat(10))
    }
}
