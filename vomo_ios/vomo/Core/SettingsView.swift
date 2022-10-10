//
//  SettingsView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

/*
 
 Fix PickerEntryField
 Add AltPickerEntryField
 Wrap up the rest of settings
 Move on to other parts of the application
 
 */

struct SettingsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    
    // Variables for settings
    @State var date: Date = .now
    @State private var sex = ""
    @State private var gender = ""
    @State var dateOnset: Date = .now
    
    // Show or hide calendars
    @State private var showCalendar = false
    @State private var showOnsetCal = false
    
    let svm = SharedViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            header
            
            VStack(alignment: .leading/*, spacing: 100*/) {
                firstName
                
                lastName
                
                dateOfBirth

                sexAtBirth
                
                genderOption
                
                voiceProblemOnsetSection
                
                trackStatementSection
            }
            .font(._fieldLabel)
            .padding(.bottom, 75)
            
            Spacer()
        }
        .frame(width: svm.content_width)
    }
}

extension SettingsView {
    private var header: some View {
        HStack {
            Text("Settings")
                .font(._title)
            Spacer()
        }
        .padding(.vertical)
    }
    
    private var firstName: some View {
        Group {
            Text("First Name")
            
            TextEntryField(topic: $settings.firstName)
        }
    }
    
    private var lastName: some View {
        Group {
            Text("Last Name")
            
            TextEntryField(topic: $settings.lastName)
        }
    }
    
    private var dateOfBirth: some View {
        Group {
            Text("Date of Birth")
            
            DateEntryField(toggle: self.$showCalendar, date: self.$settings.dob)
            
            ZStack {
                if showCalendar {
                    DatePicker("", selection: $date, in: ...Date.now, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(maxWidth: svm.content_width * 0.9)
                }
            }
            .transition(.slide)
            .onChange(of: date) { value in
                self.settings.dob = self.date.toDOB()
            }
        }
    }
    
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
    
    private var voiceProblemOnsetSection: some View {
        Group {
            Text("Voice Problem Onset")
            
            HStack(spacing: 0) {
                Button("") {
                    withAnimation() {
                        self.settings.voice_onset = true
                    }
                }.buttonStyle(YesButton(selected: settings.voice_onset))
                Spacer()
                Button("") {
                    withAnimation() {
                        self.settings.voice_onset = false
                    }
                }.buttonStyle(NoButton(selected: settings.voice_onset))
            }
            
            VStack (alignment: .leading) {
                if self.settings.voice_onset {
                    Text("Date of Onset")
                    
                    DateEntryField(toggle: self.$showOnsetCal, date: self.$settings.dateOnset)
                    
                    ZStack {
                        if showOnsetCal {
                            DatePicker("", selection: $dateOnset, in: ...Date.now, displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                                .frame(maxWidth: svm.content_width * 0.9, maxHeight: 400)
                        }
                    }
                    .transition(.slide)
                    .onChange(of: dateOnset) { value in
                        self.settings.dateOnset = self.dateOnset.toDOB()
                    }
                }
            }
            .transition(.slide)
        }
    }
    
    private var trackStatementSection: some View {
        Button(action: {
            viewRouter.currentPage = .onboard
        }) {
            HStack(spacing: 0) {
                Text("You are on \(svm.vocalIssues[settings.focusSelection]) track ")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                Text("Edit.")
                    .underline()
                    .font(._bodyCopy)
                    .foregroundColor(Color.DARK_PURPLE)
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .foregroundColor(Color.black)
            .environmentObject(ViewRouter())
            .environmentObject(Settings())
    }
}
