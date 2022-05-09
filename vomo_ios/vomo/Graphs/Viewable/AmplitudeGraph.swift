//
//  AmplitudeGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/19/22.
//

import SwiftUI

struct AmplitudeGraph: View {
    @State private var demoData: [Double] = [8, 9, 12, 16, 18, 17, 20, 28, 29, 30, 43, 38, 46, 50]
    @State private var index = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Amplitude >")
                Spacer()
                if index < demoData.count && index > 0 {
                    Text("\(demoData[index], specifier: "%.0f")")
                } else {
                    Text("\(demoData[0], specifier: "%.0f")")
                }
            }.padding(.horizontal, 5).font(.vomoCardnHeader).foregroundColor(.white)
            
            Spacer()
            
            VStack(spacing: 0) {
                LineChart(index: self.$index)
                    .data(demoData)
                    .chartStyle(ChartStyle(backgroundColor: .BRIGHT_PURPLE, foregroundColor: [ColorGradient(.DARK_BLUE, .DARK_PURPLE), ColorGradient(.orange, .red)]))
                    .frame(height: 160)
                Color.BRIGHT_PURPLE
                /*
                HStack(spacing: 0) {
                    ForEach(1..<demoData.count + 1) { item in
                        Text("\(item)").font(Font.vomoActivityRowSubtitle)
                        if item != demoData.count + 1 {
                            Spacer()
                        }
                    }
                }*/
            }
            
        }
        .padding(.top)
        .frame(height: 225, alignment: .center)
        .background(Color.DARK_PURPLE.opacity(0.6))
        .cornerRadius(17)
    }
}
