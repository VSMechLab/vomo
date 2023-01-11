//
//  VEScale.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/30/22.
//

import SwiftUI

struct VEScale: View {
    @Binding var responses: [Int]
    let prompt: String
    let index: Int
    
    let svm = SharedViewModel()
    
    @State private var position: Int = -1
    @State private var slideSwitch: Bool = false
    
    var body: some View {
        ZStack {
            background
            
            textPrompt
            
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    
                    if slideSwitch {
                        CustomSlider(position: $position)
                            .frame(height: 28)
                    } else {
                        HStack(spacing: 0) {
                            ForEach(0..<11) { index in
                                // 4. Always
                                Button(action: {
                                    self.position = index
                                    self.slideSwitch = true
                                }) {
                                    Image(position == index ? svm.select_img : "")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                            }
                        }
                        .frame(height: 28)
                        .onChange(of: self.position) { selection in
                            if self.responses.count > 0 {
                                self.responses[index] = selection
                            }
                        }
                            
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(2.5)
        .onChange(of: position) { _ in
            self.responses[index] = position
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
