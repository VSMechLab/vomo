//
//  ActivityGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/9/22.
//

import SwiftUI

struct ActivityGraph: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var demoData: [Double] = []
    @State private var index = 0
    
    let content_height: CGFloat = 300
    
    var body: some View {
        ZStack {
            Color.BLUE.frame(height: content_height).cornerRadius(12)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("Entries")
                        .font(._coverBodyCopy)
                        .padding()
                    Spacer()
                }
                
                Spacer()
                
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        ForEach(0...findMaxEntries(), id: \.self) { item in
                            Text("\(findMaxEntries() - item)")
                                .font(._coverBodyCopy)
                            Spacer()
                        }
                    }.padding(.trailing, 5)
                    
                    VStack(spacing: 0) {
                        Color.white.frame(width: 1)
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 0) {
                            BarChart()
                                .data(demoData)
                                .chartStyle(ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .BRIGHT_PURPLE), ColorGradient(.DARK_PURPLE, .DARK_PURPLE)]))
                                .frame(height: content_height * 0.60)
                                .padding(.horizontal, 10)
                            
                            Color.white.frame(height: 1)
                                .padding(.horizontal, -100)
                            
                            HStack {
                                ForEach(audioRecorder.months().reversed(), id: \.self) { item in
                                    VStack {
                                        Text(item.toMonth().uppercased())
                                            .font(._fieldLabel)
                                            .foregroundColor(Color.INPUT_FIELDS)
                                        Text(item.toYear())
                                            .font(._CTALink)
                                    }
                                }
                            }.padding(.horizontal, 12)
                        }
                    }
                    
                    Spacer()
                }
                //.background(Color.gray.opacity(0.3))
                .padding()
            }
        }
        .foregroundColor(Color.white)
        .onAppear() {
            demoData = audioRecorder.monthsTotal()
        }
    }
    
    func findMaxEntries() -> Int {
        var max = 0.0
        for num in demoData {
            if num >= max {
                max = num
            }
        }
        return Int(max)
    }
}
