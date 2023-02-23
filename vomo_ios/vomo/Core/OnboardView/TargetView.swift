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
    
    let buttonWidth: CGFloat = 160
    let buttonHeight: CGFloat = 35
    
    let svm = SharedViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            header
            
            ScrollView(showsIndicators: false) {
                vocalSelectionsSection
                
                Spacer()
            }
            
            //infoSection
            
        }.frame(width: svm.content_width)
    }
}

extension TargetView {
    private var vocalSelectionsSection: some View {
        VStack {
            ForEach(1...8, id: \.self) { index in
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
                            Text(svm.vocalIssues[index])
                                .foregroundColor(settings.focusSelection == index ? Color.white : Color.gray)
                                .font(._buttonFieldCopyLarger)
                                .multilineTextAlignment(.leading)
                        }.padding(.leading, svm.content_width / 7)
                    }
                }
            }
        }.frame(width: svm.content_width)
    }
    
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
