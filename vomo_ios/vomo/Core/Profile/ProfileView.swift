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
    
    @State private var gender = UserDefaults.standard.string(forKey: "gender") ?? ""
    
    
    
    @State private var fteProfile = false
    
    
    
    // CHANGED: create new variables for date of voice problem onset and sex
    @State private var date_voice_onset = UserDefaults.standard.string(forKey: "dateVoiceOnset")
    @State private var sex = UserDefaults.standard.string(forKey: "sex") ?? ""

    // CHANGED: capitalized the options for consistency, updated option choices
    var genders = ["Other", "Genderqueer", "Non-binary", "Female", "Male"]

    // CHANGED: added sex assigned at birth options
    var sexes = ["Other", "Female", "Male"]
    
    let genderKey = "gender", dobKey = "dob"
    let voiceOnsetKey = "voiceOnset", currentSmokerKey = "currentSmoker"
    let haveRefluxKey = "haveReflux", haveAsthmaKey = "haveAsthma"
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    let entry_img = "VM_12-entry-field"
    let button_img = "VM_Gradient-Btn"
    let toggleHeight: CGFloat = 37 * 0.95
    let img_selected = "VM_Prpl-Square-Btn copy"
    let img_unselected = "VM_Prpl-Check-Square-Btn"
    let prompt = ["a custom", "the Spasmodic Dysphonia", "the Recurrent Pappiloma", "the Parkinson's Disease", "the Gender-Affirming Care", "the Vocal Fold/Paresis", "the default"]
    
    @State private var svm = SharedViewModel()
    
    // CHANGED: add variables for date picker wheel
    @State private var showCalendar = false
    @State var date: Date = .now
    let arrow_img = "VM_Dropdown-Btn"

    // CHANGED: add variables for onset date picker
    @State private var showOnsetCal = false
    @State var dateOnset: Date = .now
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView(showsIndicators: false) {
                ProfilePicturePicker()
                    .padding(.top) // CHANGED: added top padding
                
                VStack(alignment: .leading) {
                    firstName
                    
                    lastName
                    
                    dateOfBirth

                    sexAtBirth
                    
                    genderOption
                    
                    Group {
                        // CHANGED: added Problem
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
                                        Image(entry_img)
                                            .resizable()
                                            .frame(height: toggleHeight)
                                            .cornerRadius(5)

                                        Button(action: {
                                            withAnimation() {
                                                self.showOnsetCal.toggle()
                                            }
                                            self.date_voice_onset = self.dateOnset.toDOB()
                                        }) {
                                            HStack {
                                                Text(self.dateOnset.toString(dateFormat: "MM/dd/yyyy"))
                                                    .font(._bodyCopy)
                                                Spacer()
                                                Image(arrow_img)
                                                    .resizable()
                                                    .frame(width: 20, height: 10)
                                                    .rotationEffect(Angle(degrees:  showOnsetCal ? 180 : 0))
                                            }.padding(.horizontal, 7)
                                        }
                                    }.frame(height: toggleHeight)

                                    ZStack {
                                        if showOnsetCal {
                                            DatePicker("", selection: $dateOnset, in: ...Date.now, displayedComponents: .date)
                                                .datePickerStyle(WheelDatePickerStyle())
                                                .frame(maxHeight: 400)
                                        } // End if
                                    }.transition(.slide)
                                } // End if
                            } // End VStack
                        } // End group
                    }
                }
                .font(._coverBodyCopy)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 0) {
                        Text("You are on \(prompt[userSettings.focusSelection]) track ")
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
                    
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            save()
                        }) {
                            SubmissionButton(label: "SAVE")
                        }
                        .padding(.bottom, 80)
                        Spacer()
                    }
                    .frame(width: svm.content_width)
                }.frame(width: svm.content_width)
            }
            .frame(width: svm.content_width)
            // CHANGED: added what date loads upon open
            .onAppear() {
                self.date = self.userSettings.dob.toDateFromDOB() ?? PersonalQuestionView().getDOB()
                self.dateOnset = self.date_voice_onset?.toDateFromDOB() ?? .now
            }
        }
        .padding(.vertical)
    }
    
    func save() {
        UserDefaults.standard.set(self.gender, forKey:  "gender")
        
        // CHANGED: add onset date and sex to saved values
        UserDefaults.standard.set(self.date_voice_onset, forKey: "dateVoiceOnset")
        UserDefaults.standard.set(self.sex, forKey: "sex")
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
                Image(entry_img)
                    .resizable()
                    .frame(width: svm.content_width, height: toggleHeight)
                    .cornerRadius(7)
                
                HStack {
                    TextField(self.userSettings.firstName.isEmpty ? "First Name" : self.userSettings.firstName, text: $userSettings.firstName)
                        .font(self.userSettings.firstName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                }.padding(.horizontal, 5)
            }.frame(width: svm.content_width, height: toggleHeight)
        }
    }
    
    private var lastName: some View {
        Group {
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
            
        }
    }
    
    private var dateOfBirth: some View {
        Group {
            Text("Date of Birth")
                .font(._fieldLabel)
            
            ZStack {
                Image(entry_img)
                    .resizable()
                    .frame(height: toggleHeight)
                    .cornerRadius(5)
                
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

                            Image(arrow_img)
                                .resizable()
                                .frame(width: 20, height: 10)
                                .rotationEffect(Angle(degrees:  showCalendar ? 180 : 0))
                        } //End HStack
                        .padding(.horizontal, 7)
                    }

//                            HStack {
//                                TextField(self.dob.isEmpty ? "00/00/0000" : self.dob, text: self.$dob)
//                                    .font(self.dob.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
//                            }.padding(.horizontal, 7)
                } // End ZStack
                .frame(height: toggleHeight)
            
            // CHANGED: added date picker
            ZStack {
                if showCalendar {
                    DatePicker("", selection: $date, in: ...Date.now, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(maxHeight: 400)
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

            ZStack {
                Image(entry_img)
                    .resizable()
                    .frame(height: toggleHeight)
                    .cornerRadius(7)

                HStack {
                    Menu {
                        Picker("choose", selection: $sex) {
                            ForEach(sexes, id: \.self) { sex in
                                Text("\(sex)")
                                    .font(._fieldCopyRegular)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(InlinePickerStyle())

                    } label: {
                        // CHANGED: capitalize the g for consistency
                        Text("\(sex == "" ? "Select Sex" : sex)")
                            .font(._fieldCopyRegular)
                    }
                    .frame(maxHeight: 400)

                    Spacer()
                } // End HStack
                .padding(.horizontal, 5)
            } // End ZStack
            .frame(height: toggleHeight)
            .transition(.slide)
        }
    }
    
    private var genderOption: some View {
        Group {
            Text("Gender")
                .font(._fieldLabel)

            ZStack {
                Image(entry_img)
                    .resizable()
                    .frame(height: toggleHeight)
                    .cornerRadius(7)

                HStack {
                    Menu {
                        Picker("choose", selection: $gender) {
                            ForEach(genders, id: \.self) { gender in
                                Text("\(gender)")
                                    .font(._fieldCopyRegular)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(InlinePickerStyle())

                    } label: {
                        // CHANGED: capitalize the g for consistency
                        Text("\(gender == "" ? "Select Gender" : gender)")
                            .font(._fieldCopyRegular)
                    }
                    .frame(maxHeight: 400)
                    Spacer()
                } // End HStack
                .padding(.horizontal, 5)
            } // End ZStack
            .frame(height: toggleHeight)
            .transition(.slide)
        }
    }
}



// CHANGED: added preview
struct Previews_ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
