//
//  HomeActivityGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 6/2/22.
//

import SwiftUI

struct HomeActivityGraph: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var demoData: [Double] = []
    @State private var index = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Entries")
                    .font(._coverBodyCopy)
                    .padding(8)
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
                }
                .padding(.horizontal, 2.5)
                
                VStack(spacing: 0) {
                    Color.white.frame(width: 1)
                    VStack(spacing: 0) {
                        Text("")
                            .font(._fieldLabel)
                            .foregroundColor(Color.INPUT_FIELDS)
                        Text("")
                            .font(._CTALink)
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(spacing: 0) {
                        BarChart()
                            .data(demoData)
                            .chartStyle(ChartStyle(backgroundColor: .clear, foregroundColor: [ColorGradient(.TEAL, .BRIGHT_PURPLE), ColorGradient(.DARK_PURPLE, .DARK_PURPLE)]))
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
        }
        .frame(height: 225, alignment: .center)
        .background(Color.BLUE)
        .cornerRadius(17)
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

struct HomeActivityGraph_Previews: PreviewProvider {
    static var previews: some View {
        HomeActivityGraph()
    }
}
