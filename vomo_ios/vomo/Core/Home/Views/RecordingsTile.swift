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
                .shadow(color: Color.gray.opacity(0.6), radius: 2, x: 0, y: 0)
            VStack(spacing: -4) {
                Text("\(date.toString(dateFormat: "EEE").uppercased())")
                    .font(._day)
                    .foregroundColor(Color.BODY_COPY)
                
                Text("\(date.toString(dateFormat: "dd"))")
                    .font(._date)
                    .foregroundColor(color[colorSelect])
                
                daysSince
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

extension RecordingsTile {
    private var daysSince: some View {
        Text(
            daysAgo().formatted() == "0" ? "Today" : daysAgo().formatted() == "1" ?  "\(daysAgo().formatted()) day ago" : "\(daysAgo().formatted()) days ago"
        )
        .font(._lastUsed)
        .foregroundColor(Color.BODY_COPY)
    }
}

struct EmptyTile: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10) // CHANGED: rounded corners more, was 5
                .frame(width: 70, height: 70, alignment: .center)
                .shadow(color: Color.gray.opacity(0.6), radius: 2, x: 0, y: 0)
            VStack(spacing: -4) {
                Text("Start Entry") // CHANGED: recording -> entry
                    .font(._day)
                    .foregroundColor(Color.BODY_COPY)
                    .padding(.bottom, 5) // CHANGED: added padding to center +
                
                Text("+")
                    .font(._date)
                    .foregroundColor(Color.DARK_BLUE)
                
                Text("")
                    .font(._lastUsed)
                    .foregroundColor(Color.BODY_COPY)
            }
        }.padding(1)
    }
}
