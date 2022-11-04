//
//  Scale.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI

struct Scale: View {
    @Binding var responses: [Int]
    let prompt: String
    let index: Int
    
    let svm = SharedViewModel()
    
    @State private var position: Int = -1
    
    var body: some View {
        ZStack {
            background
            
            textPrompt
            
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        // 0. Never
                        Button(action: {
                            self.position = 0
                        }) {
                            Image(position == 0 ? svm.select_img : "").resizable().frame(width: 28, height: 28)
                        }
                        
                        Spacer()
                        
                        // 1. Almost Never
                        Button(action: {
                            self.position = 1
                        }) {
                            Image(position == 1 ? svm.select_img : "").resizable().frame(width: 28, height: 28)
                        }
                        
                        Spacer()
                        
                        // 2. Sometimes
                        Button(action: {
                            self.position = 2
                        }) {
                            Image(position == 2 ? svm.select_img : "").resizable().frame(width: 28, height: 28)
                        }
                        
                        Spacer()
                        
                        // 3. Almost Always
                        Button(action: {
                            self.position = 3
                        }) {
                            Image(position == 3 ? svm.select_img : "").resizable().frame(width: 28, height: 28)
                        }
                        
                        Spacer()
                        
                        // 4. Always
                        Button(action: {
                            self.position = 4
                        }) {
                            Image(position == 4 ? svm.select_img : "").resizable().frame(width: 28, height: 28)
                        }.padding(.trailing, 4)
                    }
                    .padding(.bottom, 45)
                    .onChange(of: self.position) { selection in
                        if responses.count > 0 {
                            self.responses[index] = selection
                        }
                    }
                }
            }
        }
        .padding(.leading, 1.5)
        .shadow(color: Color.gray.opacity(0.5), radius: 1)
    }
}

extension Scale {
    private var background: some View {
        Image(svm.scale_img)
            .resizable()
            .scaledToFit()
    }
    
    private var textPrompt: some View {
        ZStack {
            VStack {
                HStack {
                    Text(prompt)
                        .font(._question)
                        .foregroundColor(Color.BODY_COPY)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                Spacer()
            }.padding()
        }
    }
}

struct BackupScale: View {
    @Binding var responses: [Int]
    let prompt: String
    let index = 10
    
    let svm = SharedViewModel()
    
    @State private var position: Int = -1
    
    var body: some View {
        ZStack {
            background
            
            textPrompt
            
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        ForEach(0..<11) { index in
                            // 4. Always
                            Button(action: {
                                self.position = index
                            }) {
                                Image(position == index ? svm.select_img : "").resizable().frame(width: 28, height: 28)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                    .padding(.horizontal, 20)
                    .onChange(of: self.position) { selection in
                        if self.responses.count > 0 {
                            self.responses[index] = selection
                        }
                    }
                }
            }
        }
        .padding(.leading, 1.5)
        .shadow(color: Color.gray.opacity(0.5), radius: 1)
    }
}

extension BackupScale {
    private var background: some View {
        Image(svm.empty_scale_img)
            .resizable()
            .scaledToFit()
    }
    
    private var textPrompt: some View {
        ZStack {
            VStack {
                HStack {
                    Text(prompt)
                        .font(._question)
                        .foregroundColor(Color.BODY_COPY)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                Spacer()
            }.padding()
        }
    }
}
