//
//  EffortScale.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

struct EffortScale: View {
    let scale_img = "VM_11-scale-bg-ds"
    let select_img = "VM_11-select-btn-ds"
    
    let scale_width: CGFloat = 315
    let scale_height: CGFloat = 140
    
    @Binding var position: Int
    
    let prompt: Int
    
    var body: some View {
        ZStack {
            Image(scale_img)
                .resizable()
                .frame(width: scale_width + 10, height: scale_height)
            
            
            ZStack {
                VStack {
                    HStack(spacing: 0) {
                        Text(prompt == 1 ? "How much physical effort did it take to make a voice?" : "How much mental effort did it take to make a voice?")
                            .foregroundColor(Color.BODY_COPY)
                        Spacer()
                    }
                    .font(._question)
                    .multilineTextAlignment(.leading)
                    
                    Spacer()
                }.padding()
            }
            
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        ForEach(0..<101) { index in
                            Button(action: {
                                self.position = index
                                print("[EffortScale index] \(index)")
                            }) {
                                Image(position == index ? select_img : "").resizable().frame(width: 28, height: 28)
                            }
                        }
                    }
                    .frame(width: scale_width - 30, alignment: .center)
                    .padding(.bottom, 60)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Text(prompt == 1 ? "Minimal effort,\neasy speaking" : "Minimal effort,\nno mental thought")
                        Spacer()
                        Text(prompt == 1 ? "Maximal effort,\nhard to speak" : "Minimal effort,\ngreat mental thought")
                    }
                    .padding(.horizontal, 15)
                    .multilineTextAlignment(.center)
                    .font(._question)
                    .foregroundColor(Color.BODY_COPY)
                    .padding(.bottom, 26)
                }
            }
        }.frame(width: scale_width, height: scale_height)
    }
}
