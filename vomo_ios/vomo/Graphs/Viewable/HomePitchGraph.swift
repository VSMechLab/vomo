//
//  HomePitchGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 6/2/22.
//

import SwiftUI

struct HomePitchGraph: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var demoData: [Double] = [8, 9, 12, 16, 18, 17, 20, 28, 29, 30, 43, 38, 46, 50]
    @State private var index = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Pitch")
                    .font(._coverBodyCopy)
                    .padding(8)
                Spacer()
            }
            .font(._coverBodyCopy).foregroundColor(.white)
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
        .frame(height: 225, alignment: .center)
        .background(Color.BRIGHT_PURPLE)
        .cornerRadius(17)
    }
}

struct HomePitchGraph_Previews: PreviewProvider {
    static var previews: some View {
        HomePitchGraph()
    }
}
