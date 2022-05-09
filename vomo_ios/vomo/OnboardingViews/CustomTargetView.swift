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
    
    let buttonWidth: CGFloat = 165
    let buttonHeight: CGFloat = 37
    
    @State private var vocalTasks = UserDefaults.standard.integer(forKey: "vocal_tasks")
    @State private var accousticParameters = UserDefaults.standard.integer(forKey: "accoustic_parameters")
    @State private var questionnaires = UserDefaults.standard.integer(forKey: "questionnaires")
    @State private var edited_before = UserDefaults.standard.bool(forKey: "edited_before")
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Focus")
                .font(Font.vomoTitle)
                .padding(.bottom, 5)
            
            Text("Select what you would like to focus on\nfrom the options below.")
                .font(Font.vomoLightBodyText)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            // Vocal Tasks
            Group {
                HStack {
                    Text("Vocal Tasks")
                        .font(Font.vomoSectionHeader)
                        .padding(.leading, 38)
                    
                    Spacer()
                }
                .padding(.bottom, -5)
                
                HStack {
                    Button(action: {
                        self.vocalTasks = 1
                    }) {
                        ZStack(alignment: .leading) {
                            Image(vocalTasks == 1 ? select_img : unselect_img)
                                .resizable()
                                .frame(width: buttonWidth, height: buttonHeight)
                            
                            Text("Spasmodic Dysphonia")
                                .font(Font.vomoRecordingDay)
                                .foregroundColor(vocalTasks == 1 ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(width: buttonWidth, height: buttonHeight)
                                    
                    Button(action: {
                        self.vocalTasks = 2
                    }) {
                        ZStack(alignment: .leading) {
                            Image(vocalTasks == 2 ? select_img : unselect_img)
                                .resizable()
                                .frame(width: buttonWidth, height: buttonHeight)
                            
                            Text("Recurrent Pappilloma")
                                .font(Font.vomoRecordingDay)
                                .foregroundColor(vocalTasks == 2 ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(width: buttonWidth, height: buttonHeight)
                }
                
                HStack {
                    Button(action: {
                        self.vocalTasks = 3
                    }) {
                        ZStack(alignment: .leading) {
                            Image(vocalTasks == 3 ? select_img : unselect_img)
                                .resizable()
                                .frame(width: buttonWidth, height: buttonHeight)
                            
                            Text("Parkinson's Disease")
                                .font(Font.vomoRecordingDay)
                                .foregroundColor(vocalTasks == 3 ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(width: buttonWidth, height: buttonHeight)
                    
                    Button(action: {
                        self.vocalTasks = 4
                    }) {
                        ZStack(alignment: .leading) {
                            Image(vocalTasks == 4 ? select_img : unselect_img)
                                .resizable()
                                .frame(width: buttonWidth, height: buttonHeight)
                            
                            Text("Gender-Affirming Care")
                                .font(Font.vomoRecordingDay)
                                .foregroundColor(vocalTasks == 4 ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(width: buttonWidth, height: buttonHeight)
                }
                .padding(.bottom, 15)
            }.padding(.vertical, 3)
            .padding(.horizontal, 3)
            
            // Accoustic Parameters
            Group {
                HStack {
                    Text("Accoustic Parameters")
                        .font(Font.vomoSectionHeader)
                        .padding(.leading, 38)
                    
                    Spacer()
                }
                .padding(.bottom, -5)
                
                HStack {
                    Button(action: {
                        self.accousticParameters = 1
                    }) {
                        ZStack(alignment: .leading) {
                            Image(accousticParameters == 1 ? select_img : unselect_img)
                                .resizable()
                                .frame(width: buttonWidth, height: buttonHeight)
                            
                            Text("Spasmodic Dysphonia")
                                .font(Font.vomoRecordingDay)
                                .foregroundColor(accousticParameters == 1 ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(width: buttonWidth, height: buttonHeight)
                                    
                    Button(action: {
                        self.accousticParameters = 2
                    }) {
                        ZStack(alignment: .leading) {
                            Image(accousticParameters == 2 ? select_img : unselect_img)
                                .resizable()
                                .frame(width: buttonWidth, height: buttonHeight)
                            
                            Text("Recurrent Pappilloma")
                                .font(Font.vomoRecordingDay)
                                .foregroundColor(accousticParameters == 2 ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(width: buttonWidth, height: buttonHeight)
                }
                
                HStack {
                    Button(action: {
                        self.accousticParameters = 3
                    }) {
                        ZStack(alignment: .leading) {
                            Image(accousticParameters == 3 ? select_img : unselect_img)
                                .resizable()
                                .frame(width: buttonWidth, height: buttonHeight)
                            
                            Text("Parkinson's Disease")
                                .font(Font.vomoRecordingDay)
                                .foregroundColor(accousticParameters == 3 ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(width: buttonWidth, height: buttonHeight)
                    
                    Button(action: {
                        self.accousticParameters = 4
                    }) {
                        ZStack(alignment: .leading) {
                            Image(accousticParameters == 4 ? select_img : unselect_img)
                                .resizable()
                                .frame(width: buttonWidth, height: buttonHeight)
                            
                            Text("Gender-Affirming Care")
                                .font(Font.vomoRecordingDay)
                                .foregroundColor(accousticParameters == 4 ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(width: buttonWidth, height: buttonHeight)
                }
                
                HStack {
                    Button(action: {
                        self.accousticParameters = 5
                    }) {
                        ZStack(alignment: .leading) {
                            Image(accousticParameters == 5 ? select_img : unselect_img)
                                .resizable()
                                .frame(width: buttonWidth, height: buttonHeight)
                            
                            Text("Vocal Fold Paralysis / Paresis")
                                .font(Font.vomoRecordingDay)
                                .foregroundColor(accousticParameters == 5 ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(width: buttonWidth, height: buttonHeight)
                    
                    Button(action: {
                        self.accousticParameters = 6
                    }) {
                        ZStack(alignment: .leading) {
                            Image(accousticParameters == 6 ? select_img : unselect_img)
                                .resizable()
                                .frame(width: buttonWidth, height: buttonHeight)
                            
                            Text("None of the Above")
                                .font(Font.vomoRecordingDay)
                                .foregroundColor(accousticParameters == 6 ? Color.white : Color.BODY_COPY)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 26)
                        }
                    }.frame(width: buttonWidth, height: buttonHeight)
                }
                .padding(.bottom, 15)
            }.padding(.vertical, 3)
            .padding(.horizontal, 3)
            
            // Questionniares
            Group {
                HStack {
                    Text("Questionnaires")
                        .font(Font.vomoSectionHeader)
                        .padding(.leading, 38)
                    
                    Spacer()
                }
                .padding(.bottom, -5)
                
                VStack(spacing: 0) {
                    Button(action: {
                        questionnaires = 1
                    }) {
                        ZStack(alignment: .leading) {
                            Image(questionnaires == 1 ? large_select_img : large_unselect_img)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width - 40, height: 67.5, alignment: .center)
                            
                            VStack(alignment: .leading) {
                                Text("VRQOL")
                                    .foregroundColor(questionnaires == 1 ? Color.white : Color.gray)
                                    .font(Font.vomoHeader)
                                
                                Text("More description can go here")
                                    .foregroundColor(questionnaires == 1 ? Color.white : Color.DARK_PURPLE)
                                    .font(Font.vomoButtons)
                            }.padding(.leading, 60)
                        }//.frame(width: UIScreen.main.bounds.width - 40, height: 100, alignment: .center)
                    }
                   
                    Button(action: {
                        questionnaires = 2
                    }) {
                        ZStack(alignment: .leading) {
                            Image(questionnaires == 2 ? large_select_img : large_unselect_img)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width - 40, height: 67.5, alignment: .center)
                            
                            VStack(alignment: .leading) {
                                Text("Vocal Effort")
                                    .foregroundColor(questionnaires == 2 ? Color.white : Color.gray)
                                    .font(Font.vomoHeader)
                                
                                Text("More description can go here")
                                    .foregroundColor(questionnaires == 2 ? Color.white : Color.DARK_PURPLE)
                                    .font(Font.vomoButtons)
                            }.padding(.leading, 60)
                        }//.frame(width: UIScreen.main.bounds.width - 40, height: 100, alignment: .center)
                    }.padding(.top, -10)
                }
            }
            
            Spacer()
            
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
                            .font(Font.vomoLightBodyText)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    UserDefaults.standard.set(true, forKey:  "edited_before")
                    UserDefaults.standard.set(0, forKey:  "focus_selection")
                    UserDefaults.standard.set(self.vocalTasks, forKey:  "vocal_tasks")
                    UserDefaults.standard.set(self.accousticParameters, forKey:  "accoustic_parameters")
                    UserDefaults.standard.set(self.questionnaires, forKey:  "questionnaires")
                    viewRouter.currentPage = .homeView
                }) {
                    HStack(spacing: 5) {
                        Text("Next")
                            .foregroundColor(Color.DARK_PURPLE)
                            .font(Font.vomoLightBodyText)
                        
                        
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
