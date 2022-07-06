//
//  TargetView.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/11/22.
//

import SwiftUI

struct TargetView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @ObservedObject var userSettings = UserSettings()
    
    let logo = "VM_0-Loading-Screen-logo"
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    
    let nav_img = "VM_Dropdown-Btn"
    
    let buttonWidth: CGFloat = 160
    let buttonHeight: CGFloat = 35
    
    @State private var svm = SharedViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            header
            
            HStack {
                Button(action: {
                    self.userSettings.focusSelection = 1
                }) {
                    ZStack(alignment: .leading) {
                        Image(userSettings.focusSelection == 1 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Spasmodic Dysphonia")
                            .font(._buttonFieldCopy)
                            .foregroundColor(userSettings.focusSelection == 1 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
                                
                Button(action: {
                    self.userSettings.focusSelection = 2
                }) {
                    ZStack(alignment: .leading) {
                        Image(userSettings.focusSelection == 2 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Recurrent Pappilloma")
                            .font(._buttonFieldCopy)
                            .foregroundColor(userSettings.focusSelection == 2 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    self.userSettings.focusSelection = 3
                }) {
                    ZStack(alignment: .leading) {
                        Image(userSettings.focusSelection == 3 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Parkinson's Disease")
                            .font(._buttonFieldCopy)
                            .foregroundColor(userSettings.focusSelection == 3 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
                
                Button(action: {
                    self.userSettings.focusSelection = 4
                }) {
                    ZStack(alignment: .leading) {
                        Image(userSettings.focusSelection == 4 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Gender-Affirming Care")
                            .font(._buttonFieldCopy)
                            .foregroundColor(userSettings.focusSelection == 4 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    self.userSettings.focusSelection = 5
                }) {
                    ZStack(alignment: .leading) {
                        Image(userSettings.focusSelection == 5 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Vocal Fold Paralysis / Paresis")
                            .font(._buttonFieldCopy)
                            .foregroundColor(userSettings.focusSelection == 5 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
                
                Button(action: {
                    self.userSettings.focusSelection = 6
                }) {
                    ZStack(alignment: .leading) {
                        Image(userSettings.focusSelection == 6 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("None of the Above (Default)")
                            .font(._buttonFieldCopy)
                            .foregroundColor(userSettings.focusSelection == 6 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
            }
            
            infoSection
            
            Spacer()
            
            navSection
        }.frame(width: svm.content_width)
    }
}

extension TargetView {
    private var header: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
                Text("Voice Treatment ")
                    .font(._headline)
                
                Text("Target")
                    .font(._headline)
                    .foregroundColor(Color.DARK_PURPLE)
                
                Text(".")
                    .font(._headline)
                    .foregroundColor(Color.TEAL)
                
                Spacer()
            }
            .padding(.bottom, 20)
            
            Text("VoMo will customize your app based on your selection.")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
        }.frame(width: svm.content_width + 100)
    }
    
    private var infoSection: some View {
        HStack(spacing: 0) {
            Text("Need more info? ")
                .font(._disclaimerCopy)
            Button("Click Here.") {
                
            }.foregroundColor(Color.DARK_PURPLE)
                .font(._disclaimerLink)
        }.padding(.vertical)
            .hidden()
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
                    UserDefaults.standard.set(true, forKey:  "edited_before")
                    UserDefaults.standard.set(self.userSettings.focusSelection, forKey:  "focus_selection")
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
