//
//  CustomTargetView.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/11/22.
//

import SwiftUI

struct CustomTargetView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    let logo = "VM_0-Loading-Screen-logo"
    let large_select_img = "VM_6-Select-Btn-Prpl-Field"
    let large_unselect_img = "VM_6-Unselect-Btn-Wht-Field"
    
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    
    let nav_img = "VM_Dropdown-Btn"
    
    //let buttonWidth: CGFloat = 165
    let buttonHeight: CGFloat = 37 * 0.95
    
    let content_width = 317.5
    
    
    @State private var vowel = UserDefaults.standard.bool(forKey: "vowel")
    @State private var maxPT = UserDefaults.standard.bool(forKey: "max_pt")
    @State private var rainbowS = UserDefaults.standard.bool(forKey: "rainbow_s")
    @State private var allTasks = UserDefaults.standard.bool(forKey: "all_tasks")
    
    @State private var pitch = UserDefaults.standard.bool(forKey: "pitch")
    @State private var CPP = UserDefaults.standard.bool(forKey: "cpp")
    @State private var intensity = UserDefaults.standard.bool(forKey: "intensity")
    @State private var HNR = UserDefaults.standard.bool(forKey: "hnr")
    @State private var minPitch = UserDefaults.standard.bool(forKey: "min_pitch")
    @State private var maxPitch = UserDefaults.standard.bool(forKey: "max_pitch")
    
    @State private var accousticParameters = UserDefaults.standard.integer(forKey: "accoustic_parameters")
    @State private var questionnaires = UserDefaults.standard.integer(forKey: "questionnaires")
    @State private var edited_before = UserDefaults.standard.bool(forKey: "edited_before")
    
    var body: some View {
        VStack {
            Spacer()
            
            header
            
            // Vocal Tasks
            HStack(spacing: 0) {
                Text("Vocal Tasks")
                    .font(._fieldLabel)
                
                Spacer()
            }.frame(width: content_width)
            .padding(.bottom, -5)
            
            vocalTaskSection
            
            accousticParametersSection
            
            questionnairesSection
            
            Spacer()
            
            navSection
        }.frame(width: content_width)
    }
}

extension CustomTargetView {
    private var header: some View {
        VStack(spacing: 0) {
            Text("Focus")
                .font(._headline)
                .padding(.bottom, 5)
            
            Text("Select what you would like to focus on\nfrom the options below.")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
        }
    }
    
    private var vocalTaskSection: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    self.vowel.toggle()
                    self.allTasks = false
                }) {
                    ZStack(alignment: .leading) {
                        Image(self.vowel ? select_img : unselect_img)
                            .resizable()
                            .frame(height: buttonHeight)
                        
                        Text("Vowel")
                            .font(._buttonFieldCopy)
                            .foregroundColor(self.vowel ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 26)
                    }
                }.frame(height: buttonHeight)
                
                Button(action: {
                    self.rainbowS.toggle()
                    self.allTasks = false
                }) {
                    ZStack(alignment: .leading) {
                        Image(self.rainbowS ? select_img : unselect_img)
                            .resizable()
                            .frame(height: buttonHeight)
                        
                        Text("Rainbow Sequences")
                            .font(._buttonFieldCopy)
                            .foregroundColor(self.rainbowS ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 26)
                    }
                }.frame(height: buttonHeight)
            }
            
            HStack {
                Button(action: {
                    self.maxPT.toggle()
                    self.allTasks = false
                }) {
                    ZStack(alignment: .leading) {
                        Image(self.maxPT ? select_img : unselect_img)
                            .resizable()
                            .frame(height: buttonHeight)
                        
                        Text("Maximum Phonation Time")
                            .font(._buttonFieldCopy)
                            .foregroundColor(self.maxPT ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 26)
                    }
                }.frame(height: buttonHeight)
                
                Button(action: {
                    self.vowel = false
                    self.maxPT = false
                    self.rainbowS = false
                    self.allTasks.toggle()
                }) {
                    ZStack(alignment: .leading) {
                        Image(self.allTasks ? select_img : unselect_img)
                            .resizable()
                            .frame(height: buttonHeight)
                        
                        Text("All Tasks")
                            .font(._buttonFieldCopy)
                            .foregroundColor(self.allTasks ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 26)
                    }
                }.frame(height: buttonHeight)
            }
            .padding(.vertical, 15)
        }.padding(.vertical, 3)
    }
    
    private var accousticParametersSection: some View {
        Group {
            // Accoustic Parameters
            HStack(spacing: 0) {
                Text("Accoustic Parameters")
                    .font(._fieldLabel)
                
                Spacer()
            }.frame(width: content_width)
            .padding(.bottom, -5)
            
            Group {
                
                
                HStack {
                    Button(action: {
                        self.pitch.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.pitch ? select_img : unselect_img)
                                .resizable()
                                .frame(height: buttonHeight)
                            
                            Text("Pitch")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.pitch ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(height: buttonHeight)
                                    
                    Button(action: {
                        self.CPP.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.CPP ? select_img : unselect_img)
                                .resizable()
                                .frame(height: buttonHeight)
                            
                            Text("CPP")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.CPP ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(height: buttonHeight)
                }
                
                HStack {
                    Button(action: {
                        self.intensity.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.intensity ? select_img : unselect_img)
                                .resizable()
                                .frame(height: buttonHeight)
                            
                            Text("Intensity")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.intensity ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(height: buttonHeight)
                    
                    Button(action: {
                        self.HNR.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.HNR ? select_img : unselect_img)
                                .resizable()
                                .frame(height: buttonHeight)
                            
                            Text("HNR")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.HNR ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(height: buttonHeight)
                }
                
                HStack {
                    Button(action: {
                        self.minPitch.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.minPitch ? select_img : unselect_img)
                                .resizable()
                                .frame(height: buttonHeight)
                            
                            Text("Minimum Pitch")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.minPitch ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(height: buttonHeight)
                    
                    Button(action: {
                        self.maxPitch.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.maxPitch ? select_img : unselect_img)
                                .resizable()
                                .frame(height: buttonHeight)
                            
                            Text("Maximum Pitch")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.maxPitch ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(height: buttonHeight)
                }
                .padding(.bottom, 15)
            }.padding(.vertical, 3)
        }
    }
    
    private var questionnairesSection: some View {
        Group {
            
            // Questionniares
            HStack(spacing: 0) {
                Text("Questionnaires")
                    .font(._fieldLabel)
                
                Spacer()
            }.frame(width: content_width)
            .padding(.bottom, -5)
            
            
            VStack(spacing: 0) {
                Button(action: {
                    questionnaires = 1
                }) {
                    ZStack(alignment: .leading) {
                        Image(questionnaires == 1 ? large_select_img : large_unselect_img)
                            .resizable()
                        
                        VStack(alignment: .leading) {
                            Text("VRQOL")
                                .foregroundColor(questionnaires == 1 ? Color.white : Color.gray)
                                .font(._buttonFieldCopyLarger)
                            
                            Text("Voice-Related Quality of Life")
                                .foregroundColor(questionnaires == 1 ? Color.white : Color.DARK_PURPLE)
                                .font(._subCopy)
                        }
                        .padding(.leading, 60)
                    }
                    .frame(width: content_width + 20, height: 70)
                }
                
                Button(action: {
                    questionnaires = 2
                }) {
                    ZStack(alignment: .leading) {
                        Image(questionnaires == 2 ? large_select_img : large_unselect_img)
                            .resizable()
                        
                        VStack(alignment: .leading) {
                            Text("Vocal Effort")
                                .foregroundColor(questionnaires == 2 ? Color.white : Color.gray)
                                .font(._buttonFieldCopyLarger)
                            
                            Text("Ratings of physcial and mental effort to make a voice")
                                .foregroundColor(questionnaires == 2 ? Color.white : Color.DARK_PURPLE)
                                .font(._subCopy)
                        }
                        .padding(.leading, 60)
                        .padding(.top, -5)
                    }
                    .frame(width: content_width + 20, height: 70)
                }
                .padding(.top, -10)
            }
        }
    }
    
    private var navSection: some View {
        Group {
            HStack {
                if !edited_before {
                    Circle()
                        .foregroundColor(Color.gray)
                        .frame(width: 4, height: 4, alignment: .center)
                }
                
                Circle()
                    .foregroundColor(Color.gray)
                    .frame(width: 4, height: 4, alignment: .center)
                
                Circle()
                    .foregroundColor(Color.DARK_PURPLE)
                    .frame(width: 6, height: 6, alignment: .center)
            }
            
            HStack {
                Button(action: {
                    viewRouter.currentPage = .voiceQuestionView
                }) {
                    HStack(spacing: 5) {
                        Image(nav_img)
                            .resizable()
                            .rotationEffect(Angle(degrees: 90))
                            .frame(width: 25, height: 12)
                        
                        Text("Back")
                            .foregroundColor(Color.DARK_PURPLE)
                            .font(._pageNavLink)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    saveAll()
                    viewRouter.currentPage = .homeView
                }) {
                    HStack(spacing: 5) {
                        Text("Next")
                            .foregroundColor(Color.DARK_PURPLE)
                            .font(._pageNavLink)
                        
                        
                        Image(nav_img)
                            .resizable()
                            .rotationEffect(Angle(degrees: 270))
                            .frame(width: 25, height: 12)
                    }
                }
            }
            .frame(width: content_width, height: 55)
        }
    }
    
    func saveAll() {
        UserDefaults.standard.set(true, forKey:  "edited_before")
        UserDefaults.standard.set(0, forKey:  "focus_selection")
        
        UserDefaults.standard.set(self.vowel, forKey:  "vowel")
        UserDefaults.standard.set(self.maxPT, forKey:  "max_pt")
        UserDefaults.standard.set(self.rainbowS, forKey:  "rainbow_s")
        UserDefaults.standard.set(self.allTasks, forKey:  "all_tasks")
        
        UserDefaults.standard.set(self.pitch, forKey:  "pitch")
        UserDefaults.standard.set(self.CPP, forKey:  "cpp")
        UserDefaults.standard.set(self.intensity, forKey:  "intensity")
        UserDefaults.standard.set(self.HNR, forKey:  "hnr")
        UserDefaults.standard.set(self.minPitch, forKey:  "min_pitch")
        UserDefaults.standard.set(self.maxPitch, forKey:  "max_pitch")
        
        UserDefaults.standard.set(self.accousticParameters, forKey:  "accoustic_parameters")
        UserDefaults.standard.set(self.questionnaires, forKey:  "questionnaires")
    }
}
