//
//  PitchGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/6/22.
//

import SwiftUI

struct PitchGraph: View {
    @State private var demoData: [Double] = [55, 48, 54, 52, 50, 50, 56, 57, 59, 56, 57, 58, 57, 58]
    @State private var index = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Pitch >")
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
                    .chartStyle(ChartStyle(backgroundColor: .BLUE, foregroundColor: [ColorGradient(.DARK_BLUE, .BLUE), ColorGradient(.orange, .red)]))
                    .frame(height: 160)
                
                Color.BLUE
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
        .background(Color.BLUE.opacity(0.6))
        .cornerRadius(17)
    }
}
