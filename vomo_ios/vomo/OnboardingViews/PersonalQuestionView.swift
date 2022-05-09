//
//  PersonalQuestionView.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/6/22.
//

import SwiftUI

struct PersonalQuestionView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var acceptedTerms = UserDefaults.standard.bool(forKey: "accepts_terms")
    @State private var name = UserDefaults.standard.string(forKey: "name") ?? ""
    @State private var gender = UserDefaults.standard.string(forKey: "gender") ?? ""
    @State private var dob = UserDefaults.standard.string(forKey: "dob") ?? ""
    
    let logo = "VM_0-Loading-Screen-logo"
    let entry_img = "VM_12-entry-field"
    let nav_img = "VM_Dropdown-Btn"
    let fieldWidth =  UIScreen.main.bounds.width - 75
    let toggleWidth = UIScreen.main.bounds.width / 2 - 40
    let toggleHeight = CGFloat(35)
    
    let img_selected = "VM_Prpl-Square-Btn copy"
    let img_unselected = "VM_Prpl-Check-Square-Btn"
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                
                Text("Sign ")
                    .font(Font.vomoTitle)
                
                Text("Up.")
                    .font(Font.vomoTitle)
                    .foregroundColor(Color.DARK_PURPLE)
                
                Spacer()
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Name")
                    .font(Font.vomoSectionHeader)
                
                ZStack {
                    Image(entry_img)
                        .resizable()
                        .frame(width: fieldWidth, height: toggleHeight)
                        .cornerRadius(7)
                    
                    HStack {
                        TextField(self.name.isEmpty ? "First and Last Name" : self.name, text: self.$name)
                            .font(self.name.isEmpty ? Font.vomoItalicButtons : Font.vomoButtons)
                    }.padding(.horizontal, 5)
                }.frame(width: fieldWidth, height: toggleHeight)
                
                Text("Gender")
                    .font(Font.vomoSectionHeader)
                
                ZStack {
                    Image(entry_img)
                        .resizable()
                        .frame(width: fieldWidth, height: toggleHeight)
                        .cornerRadius(7)
                    
                    HStack {
                        TextField(self.gender.isEmpty ? "Gender" : self.gender, text: self.$gender)
                            .font(self.gender.isEmpty ? Font.vomoItalicButtons : Font.vomoButtons)
                    }.padding(.horizontal, 5)
                }.frame(width: fieldWidth, height: toggleHeight)
                
                Text("Date of Birth")
                    .font(Font.vomoSectionHeader)
                
                ZStack {
                    Image(entry_img)
                        .resizable()
                        .frame(width: fieldWidth, height: toggleHeight)
                        .cornerRadius(5)
                    
                    HStack {
                        TextField(self.dob.isEmpty ? "00/00/0000" : self.dob, text: self.$dob)
                            .font(self.dob.isEmpty ? Font.vomoItalicButtons : Font.vomoButtons)
                    }.padding(.horizontal, 7)
                }.frame(width: fieldWidth, height: toggleHeight)
            }
            
            HStack {
                Spacer()
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    Button(action: {
                        self.acceptedTerms.toggle()
                    }) {
                        Image(acceptedTerms ? img_selected : img_unselected)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    
                    Text("By signing up you accept the ")
                        .foregroundColor(Color.BODY_COPY)
                    
                    Button(action: {
                        
                    }) {
                        Text("Terms of Service")
                            .foregroundColor(Color.DARK_PURPLE)
                    }
                    
                    Text("and ")
                        .foregroundColor(Color.BODY_COPY)
                    
                    Button(action: {
                        
                    }) {
                        Text("Privacy Policy")
                            .foregroundColor(Color.DARK_PURPLE)
                    }
                    
                    Spacer()
                }
                .multilineTextAlignment(.center)
                .font(Font.vomoButtons)
                .padding()
                        
                Spacer()
            }
            
            HStack {
                Circle()
                    .foregroundColor(Color.DARK_PURPLE)
                    .frame(width: 6, height: 6, alignment: .center)
                
                Circle()
                    .foregroundColor(Color.gray)
                    .frame(width: 4, height: 4, alignment: .center)
                
                Circle()
                    .foregroundColor(Color.gray)
                    .frame(width: 4, height: 4, alignment: .center)
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    if self.name != "" && self.dob != "" && self.gender != "" {
                        UserDefaults.standard.set(self.acceptedTerms, forKey:  "accepts_terms")
                        UserDefaults.standard.set(self.name, forKey:  "name")
                        UserDefaults.standard.set(self.dob, forKey:  "dob")
                        UserDefaults.standard.set(self.gender, forKey:  "gender")
                        viewRouter.currentPage = .voiceQuestionView
                    }
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
