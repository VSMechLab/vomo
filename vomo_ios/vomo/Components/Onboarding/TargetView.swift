//
//  TargetView.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/1/22.
//

import SwiftUI

struct TargetView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    
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
                    self.settings.focusSelection = 1
                }) {
                    ZStack(alignment: .leading) {
                        Image(settings.focusSelection == 1 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Spasmodic Dysphonia")
                            .font(._buttonFieldCopy)
                            .foregroundColor(settings.focusSelection == 1 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
                                
                Button(action: {
                    self.settings.focusSelection = 2
                }) {
                    ZStack(alignment: .leading) {
                        Image(settings.focusSelection == 2 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Recurrent Respiratory Papilomatosis (RRP)") // CHANGED: added respiratory and RRP
                            .font(._buttonFieldCopy)
                            .foregroundColor(settings.focusSelection == 2 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    self.settings.focusSelection = 3
                }) {
                    ZStack(alignment: .leading) {
                        Image(settings.focusSelection == 3 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Parkinson's Disease")
                            .font(._buttonFieldCopy)
                            .foregroundColor(settings.focusSelection == 3 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
                
                Button(action: {
                    self.settings.focusSelection = 4
                }) {
                    ZStack(alignment: .leading) {
                        Image(settings.focusSelection == 4 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Gender-Affirming Voice Care") // CHANGED: added voice
                            .font(._buttonFieldCopy)
                            .foregroundColor(settings.focusSelection == 4 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    self.settings.focusSelection = 5
                }) {
                    ZStack(alignment: .leading) {
                        Image(settings.focusSelection == 5 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Vocal Fold Paralysis / Paresis")
                            .font(._buttonFieldCopy)
                            .foregroundColor(settings.focusSelection == 5 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
                
                Button(action: {
                    self.settings.focusSelection = 6
                }) {
                    ZStack(alignment: .leading) {
                        Image(settings.focusSelection == 6 ? select_img : unselect_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("None of the Above (Default)")
                            .font(._buttonFieldCopy)
                            .foregroundColor(settings.focusSelection == 6 ? Color.white : Color.BODY_COPY)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, svm.content_width / 12.5)
                    }
                }
            }
            
            infoSection
            
            Spacer()
        }.frame(width: svm.content_width)
    }
}

extension TargetView {
    private var header: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
                Text("Voice Treatment ")
                    .font(._title)
                
                Text("Target")
                    .font(._title)
                    .foregroundColor(Color.DARK_PURPLE)
                
                Text(".")
                    .font(._title)
                    .foregroundColor(Color.TEAL)
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text("VoMo will customize your app based on your selection.")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
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
}

struct TargetView_Previews: PreviewProvider {
    static var previews: some View {
        TargetView()
            .environmentObject(ViewRouter())
            .environmentObject(Settings())
    }
}
