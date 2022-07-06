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
    
    let nav_img = "VM_Dropdown-Btn"
    
    @State private var svm = SharedViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            header
            
            // Vocal Tasks
            HStack(spacing: 0) {
                Text("Vocal Tasks")
                    .font(._fieldLabel)
                
                Spacer()
            }.frame(width: svm.content_width)
            .padding(.bottom, -5)
            
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
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    self.userSettings.vowel.toggle()
                    self.userSettings.allTasks = false
                }) {
                    ZStack(alignment: .leading) {
                        Image(self.userSettings.vowel ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Vowel")
                            .font(._buttonFieldCopy)
                            .foregroundColor(self.userSettings.vowel ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
                
                Button(action: {
                    self.userSettings.rainbowS.toggle()
                    self.userSettings.allTasks = false
                }) {
                    ZStack(alignment: .leading) {
                        Image(self.userSettings.rainbowS ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Rainbow Sequences")
                            .font(._buttonFieldCopy)
                            .foregroundColor(self.userSettings.rainbowS ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    self.userSettings.maxPT.toggle()
                    self.userSettings.allTasks = false
                }) {
                    ZStack(alignment: .leading) {
                        Image(self.userSettings.maxPT ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Maximum Phonation Time")
                            .font(._buttonFieldCopy)
                            .foregroundColor(self.userSettings.maxPT ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
                
                Button(action: {
                    self.userSettings.vowel = false
                    self.userSettings.maxPT = false
                    self.userSettings.rainbowS = false
                    self.userSettings.allTasks.toggle()
                }) {
                    ZStack(alignment: .leading) {
                        Image(self.userSettings.allTasks ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("All Tasks")
                            .font(._buttonFieldCopy)
                            .foregroundColor(self.userSettings.allTasks ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
            }
            .padding(.vertical, 15)
        }.padding(.vertical, 3)
    }
    
    private var acousticParametersSection: some View {
        Group {
            // Acoustic Parameters
            HStack(spacing: 0) {
                Text("Acoustic Parameters")
                    .font(._fieldLabel)
                
                Spacer()
            }.frame(width: svm.content_width)
            .padding(.bottom, -5)
            
            Group {
                HStack {
                    Button(action: {
                        self.userSettings.pitch.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.userSettings.pitch ? select_img : unselect_img)
                                .resizable()
                                .scaledToFit()
                            
                            Text("Pitch")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.userSettings.pitch ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, svm.content_width / 12.5)
                        }
                    }
                                    
                    Button(action: {
                        self.userSettings.CPP.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.userSettings.CPP ? select_img : unselect_img)
                                .resizable()
                                .scaledToFit()
                            
                            Text("CPP")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.userSettings.CPP ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, svm.content_width / 12.5)
                        }
                    }
                }
                
                HStack {
                    Button(action: {
                        self.userSettings.intensity.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.userSettings.intensity ? select_img : unselect_img)
                                .resizable()
                                .scaledToFit()
                            
                            Text("Intensity")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.userSettings.intensity ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, svm.content_width / 12.5)
                        }
                    }
                    
                    Button(action: {
                        self.userSettings.HNR.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.userSettings.HNR ? select_img : unselect_img)
                                .resizable()
                                .scaledToFit()
                            
                            Text("HNR")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.userSettings.HNR ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, svm.content_width / 12.5)
                        }
                    }
                }
                
                HStack {
                    Button(action: {
                        self.userSettings.minPitch.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.userSettings.minPitch ? select_img : unselect_img)
                                .resizable()
                                .scaledToFit()
                            
                            Text("Minimum Pitch")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.userSettings.minPitch ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, svm.content_width / 12.5)
                        }
                    }
                    
                    Button(action: {
                        self.userSettings.maxPitch.toggle()
                    }) {
                        ZStack(alignment: .leading) {
                            Image(self.userSettings.maxPitch ? select_img : unselect_img)
                                .resizable()
                                .scaledToFit()
                            
                            Text("Maximum Pitch")
                                .font(._buttonFieldCopy)
                                .foregroundColor(self.userSettings.maxPitch ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, svm.content_width / 12.5)
                        }
                    }
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
            }.frame(width: svm.content_width)
            .padding(.bottom, -5)
            
            VStack(spacing: 0) {
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
                        }
                        .padding(.leading, svm.content_width / 5)
                        .padding(.top, -5) // CHANGED: added padding
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
                        .padding(.top, -5)
                    }
                }
                .padding(.top, -10)
            }
            .padding(.horizontal, -5)
        }
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
