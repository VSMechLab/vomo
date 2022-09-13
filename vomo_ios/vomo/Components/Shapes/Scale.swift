//
//  Scale.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI

struct Scale: View {
    let scale_img = "VM_11-scale-bg-ds"
    let select_img = "VM_11-select-btn-ds"
    
    let svm = SharedViewModel()
    
    let scale_height: CGFloat = 140
    
    @Binding var position: Int
    
    let prompt: Int
    
    var body: some View {
        ZStack {
            Image(scale_img)
                .resizable()
                .scaledToFit()
            
            
            ZStack {
                VStack {
                    HStack {
                        Text(svm.questionniare == "VRQOL" ? svm.vrqol[prompt] : svm.vhi[prompt])
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
                    .frame(width: svm.content_width - 30, alignment: .center)
                    .padding(.bottom, 55)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Never")
                        Spacer()
                        Text("Almost\nNever")
                        Spacer()
                        Text("Sometimes")
                        Spacer()
                        Text("Almost\nAlways")
                        Spacer()
                        Text("Always")
                    }
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                    .font(.questionnaireScale)
                    .foregroundColor(Color.BODY_COPY)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
