//
//  PersonalQuestionView.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/6/22.
//

import SwiftUI

struct PersonalQuestionView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @ObservedObject var userSettings = UserSettings()
    
    let logo = "VM_0-Loading-Screen-logo"
    let entry_img = "VM_12-entry-field"
    let nav_img = "VM_Dropdown-Btn"
    let fieldWidth =  UIScreen.main.bounds.width - 75
    let toggleWidth = UIScreen.main.bounds.width / 2 - 40
    let toggleHeight = CGFloat(35)
    
    let img_selected = "VM_Prpl-Square-Btn copy"
    let img_unselected = "VM_Prpl-Check-Square-Btn"
    
    @State private var svm = SharedViewModel()
    
    let arrow_img = "VM_Dropdown-Btn"
    
    @State private var showCalendar = false
    
    @State var goalDate = ""
    @State var showDatePicker = false
    @State var textfieldText: String = ""
    
    @State var date: Date = .now
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                
                Text("Sign ")
                    .font(._headline)
                
                Text("Up.")
                    .font(._headline)
                    .foregroundColor(Color.DARK_PURPLE)
                
                Spacer()
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("First Name")
                    .font(._fieldLabel)
                
                ZStack {
                    Image(entry_img)
                        .resizable()
                        .frame(width: svm.content_width, height: toggleHeight)
                        .cornerRadius(7)
                    
                    HStack {
                        TextField(self.userSettings.firstName.isEmpty ? "First Name" : self.userSettings.firstName, text: $userSettings.firstName)
                            .font(self.userSettings.firstName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                    }.padding(.horizontal, 5)
                }.frame(width: svm.content_width, height: toggleHeight)
                
                Text("Last Name")
                    .font(._fieldLabel)
                
                ZStack {
                    Image(entry_img)
                        .resizable()
                        .frame(width: svm.content_width, height: toggleHeight)
                        .cornerRadius(7)
                    
                    HStack {
                        TextField(self.userSettings.lastName.isEmpty ? "Last Name" : self.userSettings.lastName, text: $userSettings.lastName)
                            .font(self.userSettings.lastName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                    }.padding(.horizontal, 5)
                }.frame(width: svm.content_width, height: toggleHeight)
                
                Text("Date of Birth")
                    .font(._fieldLabel)
                
                ZStack {
                    Image(entry_img)
                        .resizable()
                        .frame(width: svm.content_width, height: toggleHeight)
                        .cornerRadius(5)
                    
                    Button(action: {
                        withAnimation() {
                            self.showCalendar.toggle()
                        }
                        userSettings.dob = date.toDOB()
                    }) {
                        HStack {
                            Text(date.toDOB())
                                .font(._bodyCopy)
                            /*
                            TextField(self.dob.isEmpty ? "00/00/0000" : self.dob, text: self.$dob)
                                .font(self.dob.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                            */
                            Spacer()
                            Image(arrow_img)
                                .resizable()
                                .frame(width: 20, height: 10)
                                .rotationEffect(Angle(degrees:  showCalendar ? 180 : 0))
                        }.padding(.horizontal, 7)
                    }
                }.frame(width: svm.content_width, height: toggleHeight)
                
                ZStack {
                    if showCalendar {
                        DatePicker("", selection: $date, in: ...Date.now, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                            .frame(maxHeight: 400)
                    }
                }
                .transition(.slide)
            }
            
            //termsSection
            
            Spacer()
            
            navSection
            
        }
        .frame(width: svm.content_width)
        .onAppear() {
            date = self.userSettings.dob.toDateFromDOB() ?? .now
        }
    }
}

extension PersonalQuestionView {
    private var navSection: some View {
        Group {
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
                    userSettings.dob = self.date.toDOB()
                    if self.userSettings.firstName != "" && self.userSettings.lastName != "" && self.userSettings.dob != "" /* && self.acceptedTerms != false */ {
                        viewRouter.currentPage = .voiceQuestionView
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
            .frame(width: svm.content_width, height: 55, alignment: .center)
        }
    }
    
    private var termsSection: some View {
        HStack(spacing: 0) {
            /*
            Button(action: {
                /*
                self.userSettings.acceptedTerms.toggle()
                */
            }) {
                Image(self.userSettings.$acceptedTerms ? img_unselected : img_selected)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            */
            
            Text("By signing up you accept the ")
                .foregroundColor(Color.BODY_COPY)
                .font(._disclaimerCopy)
            
            Button(action: {
                
            }) {
                Text("Terms of Service")
                    .foregroundColor(Color.DARK_PURPLE)
                    .font(._disclaimerLink)
            }
            
            Text("and ")
                .foregroundColor(Color.BODY_COPY)
                .font(._disclaimerCopy)
            
            Button(action: {
                
            }) {
                Text("Privacy Policy")
                    .foregroundColor(Color.DARK_PURPLE)
                    .font(._disclaimerLink)
            }
        }
        .padding(.vertical)
        .multilineTextAlignment(.center)
    }
}
