//
//  VoiceQuestionView.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/1/22.
//

import SwiftUI

struct VoiceQuestionView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    
    let logo = "VM_0-Loading-Screen-logo"
    let select_img = "VM_4-Select-Btn-Prpl-Field"
    let unselect_img = "VM_4-Unselect-Btn-Wht-Field"
    
    let nav_img = "VM_Dropdown-Btn"
    
    @State private var svm = SharedViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            header
            
            haveVoMoChooseSection
            
            customizeSection
            
            Spacer()
        }
        .frame(width: svm.content_width)
    }
}

extension VoiceQuestionView {
    private var header: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
                Text("Let's ")
                    .font(._title)
                
                Text("Get Started")
                    .font(._title)
                    .foregroundColor(Color.DARK_PURPLE)
                
                // CHANGED: changed the period to teal
                Text(".")
                    .font(._title)
                    .foregroundColor(Color.TEAL)
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text("Choose your voice plan")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .padding(.bottom, 20)
        }.frame(width: svm.content_width)
    }
    
    private var haveVoMoChooseSection: some View {
        Button(action: {
            self.settings.voice_plan = 1
        }) {
            ZStack {
                Image(settings.voice_plan == 1 ? select_img : unselect_img)
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Have VoMo Choose for Me")
                            .foregroundColor(settings.voice_plan == 1 ? Color.white : Color.gray)
                            .font(._buttonFieldCopyLarger)
                            .multilineTextAlignment(.leading)
                        
                        Text("Optimize my plan based on my voice diagnosis.")
                            .foregroundColor(settings.voice_plan == 1 ? Color.white : Color.DARK_PURPLE)
                            .font(._subCopy)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.leading, svm.content_width / 5)
                    
                    Spacer()
                }
            }
        }.padding(.top, -20)
    }
    
    private var customizeSection: some View {
        Button(action: {
            self.settings.voice_plan = 2
            self.settings.focusSelection = 0
        }) {
            ZStack {
                Image(settings.voice_plan == 2 ? select_img : unselect_img)
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Customize My Own Plan")
                            .foregroundColor(settings.voice_plan == 2 ? Color.white : Color.gray)
                            .font(._buttonFieldCopyLarger)
                            .multilineTextAlignment(.leading)
                        
                        Text("Let me decide which tasks and measurements I want.")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(settings.voice_plan == 2 ? Color.white : Color.DARK_PURPLE)
                            .font(._subCopy)
                    }
                    .padding(.leading, svm.content_width / 5)
                    
                    Spacer()
                }
            }
        }.padding(.top, -20)
    }
}

struct VoiceQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceQuestionView()
    }
}
