//
//  VEScale.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/30/22.
//

import SwiftUI
import UIKit

struct VEScale: View {
    @EnvironmentObject var entries: Entries
    
    @Binding var responses: [Double]
    let prompt: String
    let index: Int
    
    let svm = SharedViewModel()
    
    @State private var position: Double = -1.0
    
    let dotSize = 35.0
    
    var body: some View {
        ZStack {
            background
            
            textPrompt
            
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    
                    if position != -1 {
                        UISliderView(value: $position, minValue: 0.0, maxValue: 20.0, thumbColor: .purple, minTrackColor: .clear, maxTrackColor: .clear)
                            .shadow(color: .gray, radius: 5)
                            .padding(.horizontal)
                            .padding(.bottom, index == 12 ? 73.5 : 38.5)
                            .onChange(of: self.position) { selection in
                                if responses.count > 0 {
                                    self.responses[index] = selection / 2
                                }
                            }
                    } else {
                        HStack(spacing: 0) {
                            ForEach(0...20, id: \.self) { index in
                                // 4. Always
                                Button(action: {
                                    self.position = Double(index)
                                }) {
                                    Image(position == Double(index) ? svm.select_img : "")
                                        .resizable()
                                        .frame(width: dotSize, height: dotSize)
                                        .shadow(color: .gray, radius: 5)
                                }
                                .frame(height: dotSize)
                            }
                        }
                        .padding(.bottom, index == 12 ? 73.5 : 38.5)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        if index == 12 {
                            Text("0%")
                        }
                        Spacer()
                        if index == 12 {
                            Text(" 50%")
                        } else {
                            Text(position >= 0 ? "\(position * 5, specifier: "%.0f")%" : "")
                        }
                        Spacer()
                        if index == 12 {
                            Text("100%")
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(width: svm.content_width)
                    .font(._bodyCopyBold)
                    .foregroundColor(Color.DARK_PURPLE)
                    .padding(.bottom, 5)
                    .padding(.bottom, index == 12 ? 50 : 0)
                }
            }
            
            if index == 12 {
                Text(position > 0 ? "\(position * 5, specifier: "%.0f")% " : " ")
                    .font(._bodyCopyBold)
                    .foregroundColor(Color.DARK_PURPLE)
                    .padding(.bottom, 5)
                    .padding(.bottom, index == 12 ? 50 : 0)
            }
        }
        .padding(2.5)
        .onChange(of: position) { selection in
            if responses.count > 0 {
                self.responses[index] = selection / 2
            }
        }
        .onAppear() {
            self.entries.getItems()
        }
    }
}

extension VEScale {
    private var background: some View {
        Image(index == 12 ? svm.bi_survey_key : svm.empty_scale_img)
            .resizable()
            .scaledToFit()
            .shadow(color: Color.gray.opacity(0.9), radius: 1)
    }
    
    private var textPrompt: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Text(.init(prompt))
                        .font(._question)
                        .foregroundColor(Color.BODY_COPY)
                        .multilineTextAlignment(.leading)
                        .frame(width: 315)
                    Spacer()
                }
                Spacer()
            }.padding(.vertical)
        }
    }
}

struct VEScale_Previews: PreviewProvider {
    static var previews: some View {
        VEScale(responses: .constant([1]), prompt: "test", index: 0)
    }
}
