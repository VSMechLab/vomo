//
//  TaskGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/9/22.
//

import SwiftUI

struct TaskGraph: View {
    @State private var demoData: [Double] = [55, 48, 54, 52, 50, 50, 56, 57, 59, 56, 57, 58, 57, 58]
    @State private var index = 0
    
    let content_height: CGFloat = 300
    
    var body: some View {
        ZStack {
            Color.BLUE.opacity(0.3).frame(height: content_height).cornerRadius(12)
            
            HStack(spacing: 0) {
                Text("ENTRIES")
                    .font(._coverBodyCopy)
                    .rotationEffect(Angle(degrees: -90))
                    .padding(.horizontal, -10)
                VStack {
                    ForEach(0...10, id: \.self) { item in
                        Text("\(10 - item)")
                            .font(._coverBodyCopy)
                    }
                }.frame(height: content_height * 0.5)
                Text("10\n9\n8\n7\n6\n5\n4\n3\n2\n1\n")
                    .font(._coverBodyCopy)
                    .foregroundColor(Color.INPUT_FIELDS)
                    .frame(width: 1, height: content_height * 0.495)
                Color.white.frame(width: 1, height: content_height * 0.495)
                
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
                            ForEach(0...demoData.count, id: \.self) { item in
                                VStack(spacing: 0) {
                                    Text("WEEK")
                                        .font(._coverBodyCopy)
                                        .foregroundColor(Color.INPUT_FIELDS)
                                    Text("\(item + 1)")
                                        .font(._coverBodyCopy)
                                }.padding(.top, 5)
                                if item != demoData.count {
                                    Spacer()
                                }
                            }
                        }.padding(.horizontal, 12)
                    }
                }
            }.frame(height: content_height)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Measure")
                        .font(._coverBodyCopy)
                        .padding()
                    Spacer()
                }
                Spacer()
            }.frame(height: content_height)
        }.foregroundColor(Color.white)
    }
}
