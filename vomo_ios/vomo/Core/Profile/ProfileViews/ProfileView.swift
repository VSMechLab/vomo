//
//  ProfileView.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/8/22.
//

import SwiftUI
import UIKit
import Foundation
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ProfileView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var recordingState: RecordState
    
    @ObservedObject var userSettings = UserSettings()
    
    @State private var svm = SharedViewModel()
    @State private var vm = ProfileViewModel()
    
    // Variables for settings
    @State var date: Date = .now
    @State private var sex = ""
    @State private var gender = ""
    @State var dateOnset: Date = .now
    
    // Show or hide calendars
    @State private var showCalendar = false
    @State private var showOnsetCal = false
    
    // Initialize variables
    init() {
        self.date = self.userSettings.dob.toDateFromDOB() ?? PersonalQuestionView().getDOB()
        self.sex = self.userSettings.sexAtBirth
        self.gender = self.userSettings.gender
        self.dateOnset = self.userSettings.dateOnset.toDateFromDOB() ?? .now
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            header
            
            ProfilePicturePicker()
            
            VStack(alignment: .leading) {
                firstName
                
                lastName
                
                dateOfBirth

                sexAtBirth
                
                genderOption
                
                voiceProblemOnsetSection
                
                trackStatementSection
            }
            .font(._coverBodyCopy)
            .frame(width: svm.content_width)
        }
    }
}

extension ProfileView {
    private var header: some View {
        Group {
            Text("Profile")
                .font(._headline)
        }
    }
    
    private var firstName: some View {
        Group {
            Text("First Name")
                .font(._fieldLabel)
            
            ZStack {
                EntryField()
                
                HStack {
                    TextField(self.userSettings.firstName.isEmpty ? "First Name" : self.userSettings.firstName, text: $userSettings.firstName)
                        .font(self.userSettings.firstName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                }.padding(.horizontal, 5)
            }
            //.frame(width: svm.content_width, height: toggleHeight)
        }
    }
    
    private var lastName: some View {
        Group {
            Text("Last Name")
                .font(._fieldLabel)
            
            ZStack {
                EntryField()
                
                HStack {
                    TextField(self.userSettings.lastName.isEmpty ? "Last Name" : self.userSettings.lastName, text: $userSettings.lastName)
                        .font(self.userSettings.lastName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                }.padding(.horizontal, 5)
            }
            //.frame(width: svm.content_width, height: toggleHeight)
            
        }
    }
    
    private var dateOfBirth: some View {
        Group {
            Text("Date of Birth")
                .font(._fieldLabel)
            
            ZStack {
                EntryField()
                
                // CHANGED: swapped text field for date picker
                    Button(action: {
                        withAnimation() {
                            self.showCalendar.toggle()
                        }

                        self.userSettings.dob = self.date.toDOB()
                    }) {
                        HStack {
                            Text(self.date.toString(dateFormat: "MM/dd/yyyy"))
                                .font(._bodyCopy)
                            
                            Spacer()

                            Image(vm.arrow_img)
                                .resizable()
                                .frame(width: 20, height: 10)
                                .rotationEffect(Angle(degrees:  showCalendar ? 180 : 0))
                        } //End HStack
                        .padding(.horizontal, 7)
                    }
                }
                //.frame(height: toggleHeight)
            
            // CHANGED: added date picker
            ZStack {
                if showCalendar {
                    DatePicker("", selection: $date, in: ...Date.now, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(maxWidth: svm.content_width * 0.9, maxHeight: 400)
                }
            } // End ZStack
            .transition(.slide)
        }
    }
    
    private var sexAtBirth: some View {
        Group {
            // CHANGED: added sex assigned at birth field
            Text("Sex (assigned at birth)")
                .font(._fieldLabel)
            
            Menu {
                Picker("choose", selection: $sex) {
                    ForEach(vm.sexes, id: \.self) { sex in
                        Text("\(sex)")
                            .font(._fieldCopyRegular)
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
                .onChange(of: self.sex) { newSex in
                    self.userSettings.sexAtBirth = sex
                }

            } label: {
                ZStack {
                    EntryField()
                    
                    HStack {
                        // CHANGED: capitalize the g for consistency
                        Text("\(sex == "" ? "Select Sex" : sex)")
                            .font(._fieldCopyRegular)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                } // End ZStack
                //.frame(height: toggleHeight)
                .transition(.slide)
            }
        }
    }
    
    private var genderOption: some View {
        Group {
            Text("Gender")
                .font(._fieldLabel)
            
            Menu {
                Picker("choose", selection: $gender) {
                    ForEach(vm.genders, id: \.self) { gender in
                        Text("\(gender)")
                            .font(._fieldCopyRegular)
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
                .onChange(of: self.gender) { newGender in
                    self.userSettings.gender = gender
                }
            } label: {
                ZStack {
                    EntryField()
                    
                    // CHANGED: capitalize the g for consistency
                    HStack {
                        Text("\(gender == "" ? "Select Gender" : gender)")
                            .font(._fieldCopyRegular)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 5)
                } // End ZStack
                //.frame(height: toggleHeight)
                .transition(.slide)
            }
        }
    }
    
    private var voiceProblemOnsetSection: some View {
        Group {
            Text("Voice Problem Onset")
                .font(._fieldLabel)
            
            HStack(spacing: 0) {
                Button("") { self.userSettings.voice_onset = true }.buttonStyle(YesButton(selected: userSettings.voice_onset))
                Spacer()
                Button("") { self.userSettings.voice_onset = false }.buttonStyle(NoButton(selected: userSettings.voice_onset))
            }
            
            // CHANGED: added date of onset selection
            Group {
                VStack (alignment: .leading) {
                    if self.userSettings.voice_onset {
                        Text("Date of Onset")
                            .font(._fieldLabel)

                        ZStack {
                            EntryField()

                            Button(action: {
                                withAnimation() {
                                    self.showOnsetCal.toggle()
                                }
                            }) {
                                HStack {
                                    Text(self.dateOnset.toString(dateFormat: "MM/dd/yyyy"))
                                        .font(._bodyCopy)
                                    Spacer()
                                    Image(vm.arrow_img)
                                        .resizable()
                                        .frame(width: 20, height: 10)
                                        .rotationEffect(Angle(degrees:  showOnsetCal ? 180 : 0))
                                }.padding(.horizontal, 7)
                            }
                        }
                        //.frame(height: toggleHeight)

                        ZStack {
                            if showOnsetCal {
                                DatePicker("", selection: $dateOnset, in: ...Date.now, displayedComponents: .date)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .frame(maxWidth: svm.content_width * 0.9, maxHeight: 400)
                            }
                        }.transition(.slide)
                    } // End if
                } // End VStack
            } // End group
        }
    }
    
    private var trackStatementSection: some View {
        HStack(spacing: 0) {
            Text("You are on \(vm.prompt[userSettings.focusSelection]) track ")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
            Button(action: {
                viewRouter.currentPage = .voiceQuestionView
            }) {
                Text("Edit.")
                    .underline()
                    .font(._bodyCopy)
                    .foregroundColor(Color.DARK_PURPLE)
            }
            Spacer()
        }
        .padding(.vertical, 5)
        .padding(.bottom, 75)
    }
}



// CHANGED: added preview
struct Previews_ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
