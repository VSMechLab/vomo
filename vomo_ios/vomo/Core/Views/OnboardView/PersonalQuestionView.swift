//
//  PersonalQuestionView.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/1/22.
//

import SwiftUI

struct PersonalQuestionView: View {
    @EnvironmentObject var settings: Settings
    
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
    
    @State private var sex = ""
    @State private var gender = ""
    
    @State var date: Date = .now
    
    var body: some View {
        VStack {
            Spacer()
            
            headerSection
            
            VStack(alignment: .leading) {
                firstNameSection
                
                lastNameSection
                
                sexAtBirth
                
                genderOption
                
                dobSection
                
                ZStack {
                    if showCalendar {
                        DatePicker("", selection: $date, in: ...Date.now, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                }
                .transition(.slide)
            }
            
            Spacer()
        }
        .frame(width: svm.content_width)
        .onAppear() {
            date = self.settings.dob.toDateFromDOB() ?? .now
        }
        .onAppear() {
            // Initialize values
            sex = self.settings.sexAtBirth
            gender = self.settings.gender
        }
    }
    
    
}

extension PersonalQuestionView {
    private var sexAtBirth: some View {
        Group {
            Text("Sex (assigned at birth)")
            
            Menu {
                Picker("choose", selection: $sex) {
                    ForEach(svm.sexes, id: \.self) { sex in
                        Text("\(sex)")
                            .font(._fieldCopyRegular)
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
                .onChange(of: self.sex) { newSex in
                    self.settings.sexAtBirth = sex
                    self.gender = sex
                    self.settings.gender = sex
                }

            } label: {
                ZStack {
                    EntryField()
                    
                    HStack {
                        Text("\(sex == "" ? "Select Sex" : sex)")
                            .font(._fieldCopyRegular)
                        
                        Spacer()
                    }
                    .padding(.horizontal, svm.fieldPadding)
                }
                .transition(.slide)
            }
        }
    }
    
    private var genderOption: some View {
        Group {
            Text("Gender")
            
            Menu {
                Picker("choose", selection: $gender) {
                    ForEach(svm.genders, id: \.self) { gender in
                        Text("\(gender)")
                            .font(._fieldCopyRegular)
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
                .onChange(of: self.gender) { newGender in
                    self.settings.gender = gender
                }
            } label: {
                ZStack {
                    EntryField()
                    
                    HStack {
                        Text("\(gender == "" ? "Select Gender" : gender)")
                            .font(._fieldCopyRegular)
                        
                        Spacer()
                    }
                    .padding(.horizontal, svm.fieldPadding)
                }
                .transition(.slide)
            }
        }
    }
    
    private var headerSection: some View {
        HStack(spacing: 0) {
            Spacer()
            Text("Sign ")
            Text("Up")
                .foregroundColor(Color.DARK_PURPLE)
            Text(".")
                .foregroundColor(Color.TEAL)
            Spacer()
        }
        .font(._title)
        .padding()
    }
    
    private var firstNameSection: some View {
        Group {
            Text("First Name")
                .font(._fieldLabel)
            
            ZStack {
                Image(entry_img)
                    .resizable()
                    .frame(width: svm.content_width, height: toggleHeight)
                    .cornerRadius(7)
                
                HStack {
                    TextField(self.settings.firstName.isEmpty ? "First Name" : self.settings.firstName, text: $settings.firstName)
                        .font(self.settings.firstName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                }.padding(.horizontal, 5)
            }.frame(width: svm.content_width, height: toggleHeight)
        }
    }
    
    private var lastNameSection: some View {
        Group {
            Text("Last Name")
                .font(._fieldLabel)
            
            ZStack {
                Image(entry_img)
                    .resizable()
                    .frame(width: svm.content_width, height: toggleHeight)
                    .cornerRadius(7)
                
                HStack {
                    TextField(self.settings.lastName.isEmpty ? "Last Name" : self.settings.lastName, text: $settings.lastName)
                        .font(self.settings.lastName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                }.padding(.horizontal, 5)
            }.frame(width: svm.content_width, height: toggleHeight)
        }
    }
    
    private var dobSection: some View {
        Group {
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
                    self.settings.dob = date.toString(dateFormat: "MM/dd/yyyy")
                }) {
                    HStack {
                        Text(date.toString(dateFormat: "MM/dd/yyyy"))
                            .font(._bodyCopy)
                        
                        Spacer()
                        Image(arrow_img)
                            .resizable()
                            .frame(width: 20, height: 10)
                            .rotationEffect(Angle(degrees:  showCalendar ? 180 : 0))
                    }.padding(.horizontal, 7)
                }
            }.frame(width: svm.content_width, height: toggleHeight)
        }
    }
}

struct PersonalQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalQuestionView()
            .environmentObject(Settings())
    }
}
