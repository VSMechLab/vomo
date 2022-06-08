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
    @State private var firstName = UserDefaults.standard.string(forKey: "first_name") ?? ""
    @State private var lastName = UserDefaults.standard.string(forKey: "last_name") ?? ""
    @State private var dob = UserDefaults.standard.string(forKey: "dob") ?? ""
    
    let logo = "VM_0-Loading-Screen-logo"
    let entry_img = "VM_12-entry-field"
    let nav_img = "VM_Dropdown-Btn"
    let fieldWidth =  UIScreen.main.bounds.width - 75
    let toggleWidth = UIScreen.main.bounds.width / 2 - 40
    let toggleHeight = CGFloat(35)
    
    let img_selected = "VM_Prpl-Square-Btn copy"
    let img_unselected = "VM_Prpl-Check-Square-Btn"
    
    let content_width = 317.5
    
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
                        .frame(width: content_width, height: toggleHeight)
                        .cornerRadius(7)
                    
                    HStack {
                        TextField(self.firstName.isEmpty ? "First Name" : self.firstName, text: self.$firstName)
                            .font(self.firstName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                    }.padding(.horizontal, 5)
                }.frame(width: content_width, height: toggleHeight)
                
                Text("Last Name")
                    .font(._fieldLabel)
                
                ZStack {
                    Image(entry_img)
                        .resizable()
                        .frame(width: content_width, height: toggleHeight)
                        .cornerRadius(7)
                    
                    HStack {
                        TextField(self.lastName.isEmpty ? "Last Name" : self.lastName, text: self.$lastName)
                            .font(self.lastName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                    }.padding(.horizontal, 5)
                }.frame(width: content_width, height: toggleHeight)
                
                Text("Date of Birth")
                    .font(._fieldLabel)
                
                ZStack {
                    Image(entry_img)
                        .resizable()
                        .frame(width: content_width, height: toggleHeight)
                        .cornerRadius(5)
                    
                    Button(action: {
                        withAnimation() {
                            self.showCalendar.toggle()
                        }
                        dob = date.toDOB()
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
                }.frame(width: content_width, height: toggleHeight)
                
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
        .frame(width: content_width)
        .onAppear() {
            date = self.dob.toDateFromDOB() ?? .now
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
                    dob = date.toDOB()
                    if self.firstName != "" && self.lastName != "" && self.dob != "" /* && self.acceptedTerms != false */ {
                        UserDefaults.standard.set(self.acceptedTerms, forKey:  "accepts_terms")
                        UserDefaults.standard.set(self.firstName, forKey:  "first_name")
                        UserDefaults.standard.set(self.lastName, forKey:  "last_name")
                        UserDefaults.standard.set(self.dob, forKey:  "dob")
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
            .frame(width: content_width, height: 55, alignment: .center)
        }
    }
    
    private var termsSection: some View {
        HStack(spacing: 0) {
            Button(action: {
                self.acceptedTerms.toggle()
            }) {
                Image(acceptedTerms ? img_unselected : img_selected)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
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
