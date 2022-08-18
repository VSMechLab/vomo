//
//  TotalGoalsRow.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

struct TotalGoalsRow: View {
    @ObservedObject var goal = Goal()
    
    @ObservedObject var audioRecorder: AudioRecorder
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var entries: Entries
    
    let recordings_img = "VoMo-App-Assets_2_8-entry-gfx"
    let start_img = "VoMo-App-Assets_2_8-visit-gfx"
    let complete_img = "VoMo-App-Assets_2_8-goal-gfx"
    
    @State private var score = 2
    @State private var comp_profile = 1
    
    @Binding var visitPopup: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .center) {
                Button(action: {
                    withAnimation {
                        self.visitPopup.toggle()
                    }
                }) {
                    ZStack {
                        ProgressBar(level: self.audioRecorder.recordings.count, color: Color.BLUE)
                        
                        Image(start_img)
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                }
                
                Text("VISITS")
                    .font(._stats)
                    .foregroundColor(Color.BLUE)
                
                // CHANGED: changed text to track visits
                Text("TRACK VISITS")
                    .font(._statsLabel)
                    .foregroundColor(Color.BODY_COPY)
            }.frame(width: 100)
            
            VStack(alignment: .center) {
                Button(action: {
                    viewRouter.currentPage = .activityView
                }) {
                    ZStack {
                        ProgressBar(level: self.score, color: Color.DARK_PURPLE)
                        
                        Image(recordings_img)
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                }
                
                Text("\(daysAgo().formatted()) DAYS")
                    .font(._stats)
                    .foregroundColor(Color.DARK_PURPLE)
                
                Text("SINCE LAST ENTRY")
                    .font(._statsLabel)
                    .foregroundColor(Color.BODY_COPY)
            }.frame(width: 100)
            
            VStack(alignment: .center) {
                // CHANGED: add button functionality to check icon
                Button(action: {
                    viewRouter.currentPage = .activityView
                }) {
                    ZStack {
                        ProgressBar(level: Int(goal.progress() * 10), color: Color.TEAL)

                        Image(complete_img)
                            .resizable()
                            .frame(width: 35, height: 30, alignment: .center)
                    }
                    .frame(width: 30)
                }
                
                Text(goal.active() ?  "\(goal.progress() * 100, specifier: "%.0f")%" : "+")
                    .font(._stats)
                    .foregroundColor(Color.TEAL)
                
                Text(goal.active() ? "GOAL PROGRESS" : "ADD A NEW GOAL")
                    .font(._statsLabel)
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
                    .stroke(lineWidth: 3)
                    .foregroundColor(Color.gray)
                    .opacity(0.10)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress(), 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
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
