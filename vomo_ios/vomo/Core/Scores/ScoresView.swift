//
//  ScoresView.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/9/22.
//

import SwiftUI

/*
 
 Todo
 Need more direction
 
 */

struct ScoresView: View {
    @State private var scoresModifier = false
    let content_width = 317.5
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ProfileButton()
                    
                    Text("Scores")
                        .font(._headline)
                    Text("See your scores for each accoustic measure and questionnaire here. Use the 'Threshold' button on each graph to set your target ranges. These can help you track your progress.")
                        .font(._bodyCopy)
                        .foregroundColor(Color.BODY_COPY)
                        .multilineTextAlignment(.leading)
                    
                    Text("24 October")
                        .font(._coverBodyCopy)
                        .padding(.top)
                    
                    Button(action: {
                        self.scoresModifier.toggle()
                    }) {
                        MeasureGraph()
                    }
                    Button(action: {
                        self.scoresModifier.toggle()
                    }) {
                        TaskGraph()
                    }.padding(.bottom, 100)
                }.frame(width: content_width)
            }
            
            if scoresModifier {
                ScoresModifier(scoresModifier: self.$scoresModifier)
            }
        }
    }
}

struct ScoresModifier: View {
    @Binding var scoresModifier: Bool
    
    let stop_play_img = "VM_stop_play-btn"
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                self.scoresModifier.toggle()
            }) {
                Color.white.opacity(0.1)
            }
            
            HStack(spacing: 0) {
                Button(action: {
                    self.scoresModifier.toggle()
                }) {
                    Color.white.opacity(0.1)
                }
                
                ZStack {
                    Color.white.frame(width: 275, height: 175).opacity(0.95).shadow(color: Color.black.opacity(0.2), radius: 5)
                    
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button("X") {
                                self.scoresModifier.toggle()
                            }
                                .font(.title3.weight(.light))
                                .padding(.horizontal)
                        }
                        
                        Text("Choose your acceptable\nscore range:")
                            .font(._bodyCopy)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            VStack {
                                Button(action: {
                                }) {
                                    Image(stop_play_img)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                                
                                Text("Less Than\nXX")
                                    .font(._bodyCopy)
                                    .foregroundColor(Color.BODY_COPY)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 55)
                            
                            VStack {
                                Button(action: {
                                }) {
                                    Image(stop_play_img)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                                
                                Text("Between\nXX and XX")
                                    .font(._bodyCopy)
                                    .foregroundColor(Color.BODY_COPY)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 55)
                            .padding(.horizontal, 25)
                            
                            VStack {
                                Button(action: {
                                }) {
                                    Image(stop_play_img)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                                
                                Text("More Than\nXX")
                                    .font(._bodyCopy)
                                    .foregroundColor(Color.BODY_COPY)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 55)
                        }
                    }.frame(width: 275, height: 175)
                }
                
                Button(action: {
                    self.scoresModifier.toggle()
                }) {
                    Color.white.opacity(0.1)
                }
            }
            
            Button(action: {
                self.scoresModifier.toggle()
            }) {
                Color.white.opacity(0.1)
            }
        }.padding(.top, 175)
    }
}
