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
    @State private var vm = ScoresViewModel()
    @State private var scoresModifier = false
    @State private var pitchThreshold = 0
    @State private var focusSelection = UserDefaults.standard.integer(forKey: "focus_selection")
    
    @State private var svm = SharedViewModel()
    
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
                    
                    /*
                    Find a way to save threshold values for the metrics
                     6 types, an array of 3 items, low, target, high
                     18 items saved total
                     
                     Save one entire array?
                     Save individual elements
                     
                     [pitch_low, pitch_mid, pitch_high, cpp_low, cpp_mid,....max_pitch_high]
                     
                     
                    UserDefaults.standard.bool(forKey: "pitch")
                    UserDefaults.standard.bool(forKey: "cpp")
                    UserDefaults.standard.bool(forKey: "intensity")
                    UserDefaults.standard.bool(forKey: "hnr")
                    UserDefaults.standard.bool(forKey: "min_pitch")
                    UserDefaults.standard.bool(forKey: "max_pitch")
                    */
                    
                    //Text("Pitches threshold data: \(vm.readPitch()[0])")
                    
                    graphSection
                }.frame(width: svm.content_width)
            }
            
            if scoresModifier {
                ScoresModifier(scoresModifier: self.$scoresModifier)
            }
        }
    }
}

extension ScoresView {
    private var graphSection: some View {
        Group {
            if focusSelection != 0 {
                Text("test")
            } else {
                if UserDefaults.standard.bool(forKey: "pitch") {
                    ZStack {
                        ScoresPitchGraph()
                        VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    self.scoresModifier.toggle()
                                }) {
                                    Text("SET THRESHOLD")
                                        .font(._day)
                                        .foregroundColor(.white)
                                        .padding(5)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                if UserDefaults.standard.bool(forKey: "cpp") {
                    ZStack {
                        ScoresCPPGraph()
                        VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    self.scoresModifier.toggle()
                                }) {
                                    Text("SET THRESHOLD")
                                        .font(._day)
                                        .foregroundColor(.white)
                                        .padding(5)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                if UserDefaults.standard.bool(forKey: "intensity") {
                    ZStack {
                        ScoresIntensityGraph()
                        VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    self.scoresModifier.toggle()
                                }) {
                                    Text("SET THRESHOLD")
                                        .font(._day)
                                        .foregroundColor(.white)
                                        .padding(5)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                if UserDefaults.standard.bool(forKey: "hnr") {
                    ZStack {
                        ScoresHNRGraph()
                        VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    self.scoresModifier.toggle()
                                }) {
                                    Text("SET THRESHOLD")
                                        .font(._day)
                                        .foregroundColor(.white)
                                        .padding(5)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                if UserDefaults.standard.bool(forKey: "min_pitch") {
                    ZStack {
                        ScoresMinimumPitchGraph()
                        VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    self.scoresModifier.toggle()
                                }) {
                                    Text("SET THRESHOLD")
                                        .font(._day)
                                        .foregroundColor(.white)
                                        .padding(5)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                if UserDefaults.standard.bool(forKey: "max_pitch") {
                    ZStack {
                        ScoresMaximumPitchGraph()
                        VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    self.scoresModifier.toggle()
                                }) {
                                    Text("SET THRESHOLD")
                                        .font(._day)
                                        .foregroundColor(.white)
                                        .padding(5)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ScoresModifier: View {
    @Binding var scoresModifier: Bool
    
    let stop_play_img = "VM_stop_play-btn"
    
    let x_button = "VoMo-App-Assets_2_popup-close-btn"
    
    let less_gray = "VoMo-App-Assets_2_8.4_less-than-gry-btn"
    let less = "VoMo-App-Assets_2_8.4_less-than-btn"
    let mid_gray = "VoMo-App-Assets_2_8.4_between-gry-btn"
    let mid = "VoMo-App-Assets_2_8.4_between-btn"
    let more_gray = "VoMo-App-Assets_2_8.4_more-than-gry-btn"
    let more = "VoMo-App-Assets_2_8.4_more-than-btn"
    
    @State private var selected = 0
    
    @State private var leftBound = ""
    @State private var rightBound = ""
    
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
                            
                            Button(action: {
                                self.scoresModifier.toggle()
                            }) {
                                Image(x_button)
                                    .resizable()
                                    .frame(width: 12, height: 12)
                            }
                            .font(.title3.weight(.light))
                            .padding(.horizontal, 8)
                        }
                        
                        Text("Choose your acceptable\nscore range:")
                            .font(._bodyCopy)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            VStack {
                                Button(action: {
                                    self.selected = 1
                                }) {
                                    Image(selected == 1 ? less : less_gray)
                                        .resizable()
                                }
                                .frame(width: 40, height: 40)
                                
                                VStack(spacing: 0) {
                                    Text("Less Than")
                                    TextField("XX", text: self.$leftBound)
                                        .foregroundColor(Color.DARK_PURPLE)
                                        .font(._bodyCopyBoldLower)
                                        .keyboardType(.numberPad)
                                }
                                .font(._bodyCopy)
                                .foregroundColor(Color.BODY_COPY)
                                .multilineTextAlignment(.center)
                                .frame(width: 80, height: 50)
                            }
                            .frame(width: 55)
                            
                            VStack {
                                Button(action: {
                                    self.selected = 2
                                }) {
                                    Image(selected == 2 ? mid : mid_gray)
                                        .resizable()
                                }
                                .frame(width: 40, height: 40)
                                
                                VStack(spacing: 0) {
                                    Text("Between\n")
                                    HStack(spacing: 0) {
                                        TextField("XX", text: self.$leftBound)
                                            .foregroundColor(Color.DARK_PURPLE)
                                            .font(._bodyCopyBoldLower)
                                            .keyboardType(.numberPad)
                                        Text(" and ")
                                            .font(._bodyCopy)
                                        TextField("XX", text: self.$rightBound)
                                            .foregroundColor(Color.DARK_PURPLE)
                                            .font(._bodyCopyBoldLower)
                                            .keyboardType(.numberPad)
                                    }
                                    .padding(.top, -10)
                                }
                                .font(._bodyCopy)
                                .foregroundColor(Color.BODY_COPY)
                                .multilineTextAlignment(.center)
                                .frame(width: 80, height: 50)
                            }
                            .frame(width: 55)
                            .padding(.horizontal, 25)
                            
                            VStack {
                                Button(action: {
                                    self.selected = 3
                                }) {
                                    Image(selected == 3 ? more : more_gray)
                                        .resizable()
                                }
                                .frame(width: 40, height: 40)
                                
                                VStack(spacing: 0) {
                                    Text("More Than")
                                    TextField("XX", text: self.$rightBound)
                                        .foregroundColor(Color.DARK_PURPLE)
                                        .font(._bodyCopyBoldLower)
                                        .keyboardType(.numberPad)
                                }
                                .font(._bodyCopy)
                                .foregroundColor(Color.BODY_COPY)
                                .multilineTextAlignment(.center)
                                .frame(width: 80, height: 50)
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
