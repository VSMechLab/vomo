//
//  ScoresMaximumPitchGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 6/2/22.
//

import SwiftUI

struct ScoresMaximumPitchGraph: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var demoData: [Double] = [20, 28, 29, 30, 43, 38, 46, 50]
    @State private var index = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    viewRouter.currentPage = .scoresView
                }) {
                    Text("Maximum Pitch")
                        .font(._coverBodyCopy)
                }
                .padding(.top, -5)
                Spacer()
                if index < demoData.count && index > 0 {
                    Text("\(demoData[index], specifier: "%.0f")")
                } else {
                    Text("\(demoData[0], specifier: "%.0f")")
                }
            }
            .padding(.horizontal, 5).font(._coverBodyCopy).foregroundColor(.white)
            .font(._fieldLabel)
            
            Spacer()
            
            VStack(spacing: 0) {
                LineChart(index: self.$index)
                    .data(demoData)
                    .chartStyle(ChartStyle(backgroundColor: .BRIGHT_PURPLE, foregroundColor: [ColorGradient(.DARK_PURPLE, .DARK_PURPLE), ColorGradient(.BRIGHT_PURPLE, .BRIGHT_PURPLE)]))
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
        .background(Color.BRIGHT_PURPLE)
        .cornerRadius(17)
    }
}

struct ScoresMaximumPitchGraph_Previews: PreviewProvider {
    static var previews: some View {
        ScoresMaximumPitchGraph()
    }
}
