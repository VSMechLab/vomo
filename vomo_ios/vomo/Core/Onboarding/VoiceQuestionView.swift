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
    
    @State private var voice_plan = UserDefaults.standard.integer(forKey: "voice_plan")
    @State private var edited_before = UserDefaults.standard.bool(forKey: "edited_before")
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                
                Text("Let's ")
                    .font(._headline)
                
                Text("Get Started")
                    .font(._headline)
                    .foregroundColor(Color.DARK_PURPLE)
                
                Spacer()
            }
            .padding(.bottom, 20)
            
            Button(action: {
                self.voice_plan = 1
            }) {
                ZStack {
                    Image(voice_plan == 1 ? select_img : unselect_img)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 40, height: 90, alignment: .center)
                    
                    VStack(alignment: .leading) {
                        Text("Have VoMo Choose for Me")
                            .foregroundColor(voice_plan == 1 ? Color.white : Color.gray)
                            .font(._buttonFieldCopy)
                        
                        Text("More description can go here")
                            .foregroundColor(voice_plan == 1 ? Color.white : Color.DARK_PURPLE)
                            .font(._subCopy)
                    }.padding(.leading, 35)
                }.frame(width: UIScreen.main.bounds.width - 40, height: 90, alignment: .center)
            }.padding(.top, -20)
           
            Button(action: {
                self.voice_plan = 2
            }) {
                ZStack {
                    Image(voice_plan == 1 ? unselect_img : select_img)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 40, height: 90, alignment: .center)
                    
                    VStack(alignment: .leading) {
                        Text("Customize My Own Plan")
                            .foregroundColor(voice_plan == 1 ? Color.gray : Color.white)
                            .font(._buttonFieldCopy)
                        
                        Text("More description can go here")
                            .foregroundColor(voice_plan == 1 ? Color.DARK_PURPLE : Color.white)
                            .font(._subCopy)
                    }.padding(.leading, 35)
                }.frame(width: UIScreen.main.bounds.width - 40, height: 90, alignment: .center)
            }.padding(.top, -20)
            
            Spacer()
            
            
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
            .frame(width: UIScreen.main.bounds.width - 50, height: 55, alignment: .center)
            .padding()
        }
    }
}

struct VoiceQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceQuestionView()
    }
}
