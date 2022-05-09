//
//  RecordingsTile.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/9/22.
//

import SwiftUI
import Foundation

struct RecordingsTile: View {
    let date: Date
    
    let color: [Color] = [Color.BLUE, Color.BRIGHT_PURPLE, Color.DARK_PURPLE, Color.DARK_BLUE]
    let colorSelect = Int.random(in: 0...3)
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(5)
                .frame(width: 70, height: 70, alignment: .center)
                .shadow(radius: 1)
            VStack(spacing: -4) {
                Text("\(date.toString(dateFormat: "EEE"))")
                    .font(Font.vomoRecordingDay)
                    .foregroundColor(Color.BODY_COPY)
                
                Text("\(date.toString(dateFormat: "dd"))")
                    .font(Font.vomoRecordingDayNum)
                    .foregroundColor(color[colorSelect])
                
                Text(daysAgo().formatted() == "0" ? "Today": "\(daysAgo().formatted()) days ago")
                    .font(Font.vomoRecordingDaysAgo)
                    .foregroundColor(Color.BODY_COPY)
            }
        }.padding(1)
    }
    
    func daysAgo() -> Double {
        let from: Date = date
        let to: Date = .now
        
        let delta = to - from
        return delta
    }
}
