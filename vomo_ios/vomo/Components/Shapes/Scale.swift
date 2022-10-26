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
    
    @State private var position: Int = 0
    
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
                    .padding(.bottom, 55)
                    .onChange(of: self.position) { selection in
                        self.responses[index] = selection
                        print(responses)
                    }
                }
            }
        }
        .padding(.leading, 1.5)
        .frame(width: svm.content_width - 1.5)
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

struct EmptyScale: View {
    @Binding var responses: [Int]
    let prompt: String
    let index: Int
    
    let svm = SharedViewModel()
    
    @State private var position: Int = 0
    
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
                    .padding(.horizontal, -5)
                    .frame(width: svm.content_width - 30, alignment: .center)
                    .padding(.bottom, 55)
                    .onChange(of: self.position) { selection in
                        self.responses[index] = selection
                        print(responses)
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Poor")
                        Spacer()
                        Text("Great")
                    }
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                    .font(.questionnaireScale)
                    .foregroundColor(Color.BODY_COPY)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

extension EmptyScale {
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
