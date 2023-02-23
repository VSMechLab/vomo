//
//  VEScale.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/30/22.
//

import SwiftUI
import UIKit

struct VEScale: View {
    @Binding var responses: [Int]
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
                        UISliderView(value: $position, minValue: 0.0, maxValue: 10.0, thumbColor: .purple, minTrackColor: .clear, maxTrackColor: .clear)
                            .padding(.horizontal)
                            .padding(.bottom, 38.5)
                            .onChange(of: self.position) { selection in
                                if responses.count > 0 {
                                    self.responses[index] = Int(selection)
                                }
                            }
                    } else {
                        HStack(spacing: 0) {
                            ForEach(0..<11) { index in
                                // 4. Always
                                Button(action: {
                                    self.position = Double(index)
                                }) {
                                    Image(position == Double(index) ? svm.select_img : "")
                                        .resizable()
                                        .frame(width: dotSize, height: dotSize)
                                }
                                .frame(height: dotSize)
                            }
                        }
                        .padding(.bottom, 38.5)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text(position >= 0 ? "\(position * 10, specifier: "%.0f")%" : "")
                            .font(._bodyCopyBold)
                            .foregroundColor(Color.DARK_PURPLE)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                }
            }
        }
        .padding(2.5)
        .onChange(of: position) { selection in
            if responses.count > 0 {
                self.responses[index] = Int(selection)
            }
        }
    }
}

extension VEScale {
    private var background: some View {
        Image(svm.empty_scale_img)
            .resizable()
            .scaledToFit()
            .shadow(color: Color.gray.opacity(0.9), radius: 1)
    }
    
    private var textPrompt: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Text(prompt)
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
