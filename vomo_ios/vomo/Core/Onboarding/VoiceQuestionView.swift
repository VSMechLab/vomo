//
//  VoiceQuestionView.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/6/22.
//

import SwiftUI

struct VoiceQuestionView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    let logo = "VM_0-Loading-Screen-logo"
    let select_img = "VM_4-Select-Btn-Prpl-Field"
    let unselect_img = "VM_4-Unselect-Btn-Wht-Field"
    
    let nav_img = "VM_Dropdown-Btn"
    
    let content_width = 317.5
    
    @State private var voice_plan = UserDefaults.standard.integer(forKey: "voice_plan")
    @State private var edited_before = UserDefaults.standard.bool(forKey: "edited_before")
    
    var body: some View {
        VStack {
            Spacer()
            
            header
            
            Spacer()
            
            customizeSection
            
            haveVoMoChooseSection
            
            Spacer()
            
            navSection
        }.frame(width: content_width)
    }
}

struct VoiceQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceQuestionView()
    }
}

extension VoiceQuestionView {
    private var header: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
                Text("Let's ")
                    .font(._headline)
                
                Text("Get Started")
                    .font(._headline)
                    .foregroundColor(Color.DARK_PURPLE)
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text("Choose your voice plan")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.center)
        }
    }
    
    private var customizeSection: some View {
        Button(action: {
            self.voice_plan = 1
        }) {
            ZStack {
                Image(voice_plan == 1 ? select_img : unselect_img)
                    .resizable()
                    .frame(height: 85)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Have VoMo Choose for Me")
                            .foregroundColor(voice_plan == 1 ? Color.white : Color.gray)
                            .font(._buttonFieldCopyLarger)
                        
                        Text("Optimize my plan based on my voice diagnosis")
                            .foregroundColor(voice_plan == 1 ? Color.white : Color.DARK_PURPLE)
                            .font(._subCopy)
                    }
                    .padding(.leading, 60)
                    Spacer()
                }
            }.frame(height: 85)
        }.padding(.top, -20)
    }
    
    private var haveVoMoChooseSection: some View {
        Button(action: {
            self.voice_plan = 2
        }) {
            ZStack {
                Image(voice_plan == 1 ? unselect_img : select_img)
                    .resizable()
                    .frame(height: 85)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Customize My Own Plan")
                            .foregroundColor(voice_plan == 1 ? Color.gray : Color.white)
                            .font(._buttonFieldCopyLarger)
                        
                        Text("Let me decide which takss and measurements I want")
                            .foregroundColor(voice_plan == 1 ? Color.DARK_PURPLE : Color.white)
                            .font(._subCopy)
                    }
                    .padding(.leading, 60)
                    Spacer()
                }
            }.frame(height: 85)
        }.padding(.top, -20)
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
                    .foregroundColor(Color.DARK_PURPLE)
                    .frame(width: 6, height: 6, alignment: .center)
                
                Circle()
                    .foregroundColor(Color.gray)
                    .frame(width: 4, height: 4, alignment: .center)
            }
            
            HStack {
                if !edited_before {
                    Button(action: {
                        viewRouter.currentPage = .personalQuestionView
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
                }
                
                Spacer()
                
                Button(action: {
                    if self.voice_plan == 1 {
                        UserDefaults.standard.set(self.voice_plan, forKey:  "voice_plan")
                        viewRouter.currentPage = .targetView
                    } else if self.voice_plan == 2 {
                        UserDefaults.standard.set(self.voice_plan, forKey:  "voice_plan")
                        viewRouter.currentPage = .customTargetView
                    }
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
            .frame(width: content_width, height: 55, alignment: .center)
        }
    }
}
