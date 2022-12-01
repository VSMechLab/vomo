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
    
    let afflictions = ["Empty", "Laryngeal Dystonia", "Recurrent Respiratory Papilomatosis (RRP)", "Parkinson's Disease", "Gender-Affirming Voice Care", "Vocal Fold Paralysis / Paresis", "None of the Above (Default)"]
    
    var body: some View {
        VStack {
            Spacer()
            
            header
            
            VStack {
                ForEach(1...6, id: \.self) { index in
                    Button(action: {
                        self.settings.focusSelection = index
                        self.settings.setSurveys()
                    }) {
                        ZStack(alignment: .leading) {
                            ZStack {
                                if settings.focusSelection == index {
                                    Color.MEDIUM_PURPLE
                                        .frame(width: svm.content_width - 2, height: 60)
                                } else {
                                    Color.white
                                        .frame(width: svm.content_width - 2, height: 60)
                                }
                                
                                HStack {
                                    Image(settings.focusSelection == index ? svm.select : svm.unselect)
                                        .resizable()
                                        .frame(width: 27.5, height: 27.5)
                                        .padding(.leading, 15)
                                    Spacer()
                                }
                            }
                            .cornerRadius(10)
                            .shadow(color: Color.gray, radius: 1)
                            .padding(1)
                            
                            VStack(alignment: .leading) {
                                Text(afflictions[index])
                                    .foregroundColor(settings.focusSelection == index ? Color.white : Color.gray)
                                    .font(._buttonFieldCopyLarger)
                                    .multilineTextAlignment(.leading)
                            }.padding(.leading, svm.content_width / 7)
                        }
                    }
                }
            }.frame(width: svm.content_width)
            
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
