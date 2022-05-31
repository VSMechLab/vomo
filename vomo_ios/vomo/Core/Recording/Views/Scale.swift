//
//  Scale.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/12/22.
//

import SwiftUI

struct Scale: View {
    let scale_img = "VM_11-scale-bg-ds"
    let select_img = "VM_11-select-btn-ds"
    
    let scale_width: CGFloat = 317.5
    let scale_height: CGFloat = 140
    
    @Binding var position: Int
    
    let prompt: Int
    let promptSelection = [
        "1. I have trouble speaking loudly or being heard in noisy situations.",
        "2. I run out of air and need to take frequent breaths when talking.",
        "3. I sometimes do not know what will come out when I begin speaking.",
        "4. I am sometimes anxious or frustrated (because of my voice).",
        "5. I sometimes get depressed (because of my voice).",
        "6. I have trouble using the telephone (because of my voice).",
        "7. I have trouble doing my job or practicing my profession (because of my voice).",
        "8. I avoid going out socially (because of my voice).",
        "9. I have to repeat myself to be understood",
        "10. I have become less outgoing (because of my voice).",
        "The overall quality of my voice during the last two weeks has been:"
    ]
    
    var body: some View {
        ZStack {
            Image(scale_img)
                .resizable()
                .frame(width: scale_width, height: scale_height)
            
            
            ZStack {
                VStack {
                    HStack {
                        Text(promptSelection[prompt])
                            .font(._question)
                            .foregroundColor(Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    Spacer()
                }.padding()
            }
            
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        // 0. Never
                        Button(action: {
                            self.position = 0
                        }) {
                            Image(position == 0 ? select_img : "").resizable().frame(width: 28, height: 28)
                        }
                        
                        Spacer()
                        
                        // 1. Almost Never
                        Button(action: {
                            self.position = 1
                        }) {
                            Image(position == 1 ? select_img : "").resizable().frame(width: 28, height: 28)
                        }
                        
                        Spacer()
                        
                        // 2. Sometimes
                        Button(action: {
                            self.position = 2
                        }) {
                            Image(position == 2 ? select_img : "").resizable().frame(width: 28, height: 28)
                        }
                        
                        Spacer()
                        
                        // 3. Almost Always
                        Button(action: {
                            self.position = 3
                        }) {
                            Image(position == 3 ? select_img : "").resizable().frame(width: 28, height: 28)
                        }
                        
                        Spacer()
                        
                        // 4. Always
                        Button(action: {
                            self.position = 4
                        }) {
                            Image(position == 4 ? select_img : "").resizable().frame(width: 28, height: 28)
                        }.padding(.trailing, 4)
                    }
                    .padding(.horizontal, -5)
                    .frame(width: scale_width - 30, alignment: .center)
                    .padding(.bottom, 60)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Never")
                        Spacer()
                        Text("Almost Never")
                        Spacer()
                        Text("Sometimes")
                        Spacer()
                        Text("Almost Always")
                        Spacer()
                        Text("Always")
                    }
                    .padding(.horizontal, 15)
                    .font(._question)
                    .foregroundColor(Color.BODY_COPY)
                    .padding(.bottom, 31)
                }
            }
        }
    }
}
