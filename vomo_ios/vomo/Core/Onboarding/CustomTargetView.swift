//
//  CustomTargetView.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/11/22.
//

import SwiftUI

struct CustomTargetView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @ObservedObject var userSettings = UserSettings()
    
    let logo = "VM_0-Loading-Screen-logo"
    let large_select_img = "VM_6-Select-Btn-Prpl-Field"
    let large_unselect_img = "VM_6-Unselect-Btn-Wht-Field"
    
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    
    let info_img = "VM_info-icon"
    
    let nav_img = "VM_Dropdown-Btn"
    
    @State private var svm = SharedViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            header
            
            vocalTaskSection
            
            acousticParametersSection
            
            questionnairesSection
            
            Spacer()
            
            navSection
        }.frame(width: svm.content_width)
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
        VStack(alignment: .leading, spacing: 7) {
            // Vocal Tasks
            Text("Vocal Tasks")
                .font(._fieldLabel)
            
            VStack(spacing: 7) {
                HStack {
                    Button(action: {
                        self.userSettings.vowel.toggle()
                        self.userSettings.allTasks = false
                    }) {
                        SelectionImage(picked: self.userSettings.vowel, text: "Vowel")
                    }
                    
                    Button(action: {
                        self.userSettings.rainbowS.toggle()
                        self.userSettings.allTasks = false
                    }) {
                        SelectionImage(picked: self.userSettings.rainbowS, text: "Rainbow Sequences")
                    }
                }
                .frame(height: svm.content_width * 0.105576)
                
                HStack {
                    Button(action: {
                        self.userSettings.maxPT.toggle()
                        self.userSettings.allTasks = false
                    }) {
                        SelectionImage(picked: self.userSettings.maxPT, text: "MPT")
                    }
                    
                    Button(action: {
                        self.userSettings.vowel = false
                        self.userSettings.maxPT = false
                        self.userSettings.rainbowS = false
                        self.userSettings.allTasks.toggle()
                    }) {
                        SelectionImage(picked: self.userSettings.allTasks, text: "All Tasks")
                    }
                }
                .frame(height: svm.content_width * 0.105576)
            }
        }.padding(.top, 10)
    }
    
    private var acousticParametersSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Acoustic Parameters
            Text("Acoustic Parameters")
                .font(._fieldLabel)
            
            VStack(spacing: 7) {
                HStack {
                    Button(action: {
                        self.userSettings.pitch.toggle()
                    }) {
                        SelectionImage(picked: self.userSettings.pitch, text: "Pitch")
                    }
                    
                    Button(action: {
                        self.userSettings.CPP.toggle()
                    }) {
                        SelectionImage(picked: self.userSettings.CPP, text: "CPP")
                    }
                }.frame(height: svm.content_width * 0.105576)
                
                HStack {
                    Button(action: {
                        self.userSettings.intensity.toggle()
                    }) {
                        SelectionImage(picked: self.userSettings.intensity, text: "Intensity")
                    }
                    
                    Button(action: {
                        self.userSettings.duration.toggle()
                    }) {
                        SelectionImage(picked: self.userSettings.duration, text: "Duration")
                    }
                }.frame(height: svm.content_width * 0.105576)
                
                HStack {
                    Button(action: {
                        self.userSettings.minPitch.toggle()
                    }) {
                        SelectionImage(picked: self.userSettings.minPitch, text: "Minimum Pitch")
                    }
                    
                    Button(action: {
                        self.userSettings.maxPitch.toggle()
                    }) {
                        SelectionImage(picked: self.userSettings.maxPitch, text: "Maximum Pitch")
                    }
                }
                .frame(height: svm.content_width * 0.105576)
            }
        }
        .padding(.top, 10)
    }
    
    private var questionnairesSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Questionniares
            Text("Questionnaires")
                .font(._fieldLabel)
            
            VStack(spacing: 7) {
                Button(action: {
                    userSettings.questionnaires = 1
                }) {
                    ZStack(alignment: .leading) {
                        Image(userSettings.questionnaires == 1 ? large_select_img : large_unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        VStack(alignment: .leading) {
                            Text("VRQOL")
                                .foregroundColor(userSettings.questionnaires == 1 ? Color.white : Color.gray)
                                .font(._buttonFieldCopyLarger)
                            
                            Text("Voice-Related Quality of Life")
                                .foregroundColor(userSettings.questionnaires == 1 ? Color.white : Color.DARK_PURPLE)
                                .font(._subCopy)
                        }.padding(.leading, svm.content_width / 5)
                    }
                }
                
                Button(action: {
                    userSettings.questionnaires = 2
                }) {
                    ZStack(alignment: .leading) {
                        Image(userSettings.questionnaires == 2 ? large_select_img : large_unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        VStack(alignment: .leading) {
                            Text("Vocal Effort")
                                .foregroundColor(userSettings.questionnaires == 2 ? Color.white : Color.gray)
                                .font(._buttonFieldCopyLarger)
                            
                            Text("Ratings of physcial and mental effort to make a voice")
                                .foregroundColor(userSettings.questionnaires == 2 ? Color.white : Color.DARK_PURPLE)
                                .font(._subCopy)
                        }
                        .padding(.leading, svm.content_width / 5)
                    }
                }
                .padding(.top, -10)
                
                Spacer()
            }
        }
        .padding(.top, 10)
    }
    
    private var navSection: some View {
        Group {
            HStack {
                if !userSettings.edited_before {
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
            .frame(width: svm.content_width, height: 55)
        }
    }
}

// CHANGED: added preview
struct CustomTargetView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTargetView()
    }
}

struct SelectionImage: View {
    @State private var svm = SharedViewModel()
    
    let picked: Bool
    let text: String
    
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    let info_img = "VM_info-icon"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Image(picked ? select_img : unselect_img)
                    .resizable()
                    .scaledToFit()
                
                HStack(spacing: 0) {
                    Text(text)
                        .font(._buttonFieldCopy)
                        .foregroundColor(picked ? Color.white : Color.BODY_COPY)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, geometry.size.width * 0.176)
                    
                    Spacer()
                    
                    VStack {
                        Image(info_img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.062, height: geometry.size.width * 0.062)
                            .padding(.trailing, geometry.size.width * 0.0245)
                            .padding(.top, geometry.size.width * 0.0245)
                        Spacer()
                    }
                }
            }
        }
    }
}
