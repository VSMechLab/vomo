//
//  OnboardView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI
import UserNotifications

/// To do - clean code (later)

struct OnboardView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    
    @State private var svm = SharedViewModel()
    @State private var stepSwitch = 0
    @State private var startIndex = 0
    
    var body: some View {
        VStack {
            switch stepSwitch {
            case 0:
                landingPage
            case 1:
                PersonalQuestionView()
            case 2:
                VoiceQuestionView()
            case 3:
                if self.settings.voice_plan == 1 {
                    TargetView()
                } else if self.settings.voice_plan == 2 {
                    CustomTargetView()
                }
            case 4:
                stepFour
            default:
                Text("error state")
            }
            
            Spacer()
            
            indicator
        }
        
        .onAppear() {
            if settings.edited_before {
                stepSwitch = 2
                startIndex = 2
            } else {
                startIndex = 1
            }
        }
    }
}

extension OnboardView {
    private var stepFour: some View {
        GoalEntryView()
    }
    
    private var landingPage: some View {
        ZStack {
            VStack {
                Spacer()
                ZStack {
                    Wave(color: Color.DARK_BLUE, offset: 1.5, recording: .constant(false))
                    Wave(color: Color.TEAL, offset: 1.0, recording: .constant(false))
                    Wave(color: Color.DARK_PURPLE, offset: 2.0, recording: .constant(false))
                }
                Spacer()
            }
            
            VStack {
                HStack(spacing: 0) {
                    Spacer()
                    
                    Text("Welcome to ")
                        .font(._title)
                    
                    Text("VoMo")
                        .font(._title)
                        .foregroundColor(Color.DARK_PURPLE)
                    
                    Text(".")
                        .font(._title)
                        .foregroundColor(Color.TEAL)
                    
                    Spacer()
                }
                .padding(.top, 100)
                .padding(.bottom, 10)
                
                Text("Track your voice over time and share vocal health information with your clinical provider all in one place")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .frame(width: svm.content_width)
                
                Spacer()
                
                 //CHANGE: added more padding
            } // End VStack
            .onAppear {
                UserDefaults.standard.set(false, forKey: "edited_before")
            }
        }
    }
    
    private var indicator: some View {
        VStack {
            Spacer()
            if stepSwitch != 0 {
                ZStack {
                    HStack {
                        if stepSwitch != 1 || startIndex != 2 {
                            Button(action: {
                                stepSwitch -= 1
                            }) {
                                HStack(spacing: 5) {
                                    Arrow()
                                        .rotationEffect(Angle(degrees:-180))
                                    Text("Back")
                                        .foregroundColor(Color.DARK_PURPLE)
                                        .font(._pageNavLink)
                                }
                            }
                        }
                        Spacer()
                        if stepSwitch != 4 {
                            Button(action: {
                                stepSwitch += 1
                            }) {
                                HStack(spacing: 5) {
                                    Text("Next")
                                        .foregroundColor(Color.DARK_PURPLE)
                                        .font(._pageNavLink)
                                    Arrow()
                                }
                            }
                        } else if stepSwitch == 4 {
                            Button(action: {
                                viewRouter.currentPage = .home
                                settings.edited_before = true
                            }) {
                                HStack(spacing: 5) {
                                    Text("Done")
                                        .foregroundColor(Color.DARK_PURPLE)
                                        .font(._pageNavLink)
                                    Arrow()
                                }
                            }
                        }
                    }
                    HStack {
                        ForEach(startIndex...4, id: \.self) { step in
                            Circle()
                                .foregroundColor(stepSwitch == step ? Color.DARK_PURPLE : Color.gray)
                                .frame(width: stepSwitch == step ? 8.5 : 6, height: stepSwitch == step ? 8.5 : 6, alignment: .center)
                        }
                    }
                }
                
                
            } else {
                Button(action: {
                    stepSwitch += 1
                }) {
                    SubmissionButton(label: "GET STARTED")
                }
            }
        }
        .frame(width: svm.content_width, height: 20, alignment: .center)
        .padding(.top, 30)
        .padding(.bottom, 40)
    }
}

struct OnboardView_Preview: PreviewProvider {
    static var previews: some View {
        OnboardView()
            .environmentObject(ViewRouter())
            .environmentObject(Settings())
    }
}

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
    
    @State var date: Date = .now
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                
                Text("Sign ")
                    .font(._title)
                
                Text("Up")
                    .font(._title)
                    .foregroundColor(Color.DARK_PURPLE)
                
                // CHANGED: changed the period to teal
                Text(".")
                    .font(._title)
                    .foregroundColor(Color.TEAL)
                
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
                        TextField(self.settings.firstName.isEmpty ? "First Name" : self.settings.firstName, text: $settings.firstName)
                            .font(self.settings.firstName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
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
                        TextField(self.settings.lastName.isEmpty ? "Last Name" : self.settings.lastName, text: $settings.lastName)
                            .font(self.settings.lastName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
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
                        self.settings.dob = date.toString(dateFormat: "MM/dd/yyyy")
                    }) {
                        HStack {
                            // CHANGE: fix date format
                            Text(date.toString(dateFormat: "MM/dd/yyyy"))
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
            
            Spacer()
        }
        .frame(width: svm.content_width)
        .onAppear() {
            date = self.settings.dob.toDateFromDOB() ?? .now
        }
    }
    
    // CHANGED: add method to get dob
    func getDOB() -> Date {
        return date
    }

    // CHANGED: add method to set dob
    func setDOB(newDate: Date) {
        self.date = newDate
    }
}

struct VoiceQuestionView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    
    let logo = "VM_0-Loading-Screen-logo"
    let select_img = "VM_4-Select-Btn-Prpl-Field"
    let unselect_img = "VM_4-Unselect-Btn-Wht-Field"
    
    let nav_img = "VM_Dropdown-Btn"
    
    @State private var svm = SharedViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            header
            
            haveVoMoChooseSection
            
            customizeSection
            
            Spacer()
        }.frame(width: svm.content_width)
            .onAppear() {
                print(settings.voice_plan)
            }
    }
}

extension VoiceQuestionView {
    private var header: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
                Text("Let's ")
                    .font(._title)
                
                Text("Get Started")
                    .font(._title)
                    .foregroundColor(Color.DARK_PURPLE)
                
                // CHANGED: changed the period to teal
                Text(".")
                    .font(._title)
                    .foregroundColor(Color.TEAL)
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text("Choose your voice plan")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .padding(.bottom, 20)
        }.frame(width: svm.content_width)
    }
    
    private var haveVoMoChooseSection: some View {
        Button(action: {
            self.settings.voice_plan = 1
        }) {
            ZStack {
                Image(settings.voice_plan == 1 ? select_img : unselect_img)
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Have VoMo Choose for Me")
                            .foregroundColor(settings.voice_plan == 1 ? Color.white : Color.gray)
                            .font(._buttonFieldCopyLarger)
                            .multilineTextAlignment(.leading)
                        
                        Text("Optimize my plan based on my voice diagnosis.")
                            .foregroundColor(settings.voice_plan == 1 ? Color.white : Color.DARK_PURPLE)
                            .font(._subCopy)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.leading, svm.content_width / 5)
                    
                    Spacer()
                }
            }
        }.padding(.top, -20)
    }
    
    private var customizeSection: some View {
        Button(action: {
            self.settings.voice_plan = 2
        }) {
            ZStack {
                Image(settings.voice_plan == 2 ? select_img : unselect_img)
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Customize My Own Plan")
                            .foregroundColor(settings.voice_plan == 2 ? Color.white : Color.gray)
                            .font(._buttonFieldCopyLarger)
                            .multilineTextAlignment(.leading)
                        
                        Text("Let me decide which tasks and measurements I want.")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(settings.voice_plan == 2 ? Color.white : Color.DARK_PURPLE)
                            .font(._subCopy)
                    }
                    .padding(.leading, svm.content_width / 5)
                    
                    Spacer()
                }
            }
        }.padding(.top, -20)
    }
}

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

struct CustomTargetView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    
    let logo = "VM_0-Loading-Screen-logo"
    let large_select_img = "VM_6-Select-Btn-Prpl-Field"
    let large_unselect_img = "VM_6-Unselect-Btn-Wht-Field"
    
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    
    let info_img = "VM_info-icon"
    
    let nav_img = "VM_Dropdown-Btn"
    
    @State private var svm = SharedViewModel()
    
    let vocalTasks = ["Vowel", "Maximum Phonation Time (MPT)", "Rainbow Sequence"]
    
    var body: some View {
        VStack {
            Spacer()
            
            header
            
            ScrollView(showsIndicators: false) {
                vocalTaskSection
                
                acousticParametersSection
                
                questionnairesSection
                
                Spacer()
            }
        }.frame(width: svm.content_width)
    }
}

extension CustomTargetView {
    private var header: some View {
        VStack(spacing: 0) {
            Text("Focus")
                .font(._title)
                .padding(.bottom, 5)
            
            Text("Select what you would like to focus on\nfrom the options below.")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
        }
    }
    
    private var vocalTaskSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Vocal Tasks
            Text("Vocal Tasks")
                .font(._fieldLabel)
            
            ForEach(vocalTasks, id: \.self) { task in
                Button(action: {
                    if task == "Vowel" {
                        self.settings.vowel.toggle()
                    } else if task == "Maximum Phonation Time (MPT)" {
                        self.settings.maxPT.toggle()
                    } else if task == "Rainbow Sequence" {
                        self.settings.rainbowS.toggle()
                    }
                }) {
                    ZStack(alignment: .leading) {
                        VStack {
                            if task == "Vowel" {
                                Image(settings.vowel ? large_select_img : large_unselect_img)
                                    .resizable()
                                    .scaledToFit()
                                    .shadow(color: Color.gray.opacity(0.5), radius: 1)
                            }
                            if task == "Maximum Phonation Time (MPT)" {
                                Image(settings.maxPT ? large_select_img : large_unselect_img)
                                    .resizable()
                                    .scaledToFit()
                                    .shadow(color: Color.gray.opacity(0.5), radius: 1)
                            }
                            if task == "Rainbow Sequence" {
                                Image(settings.rainbowS ? large_select_img : large_unselect_img)
                                    .resizable()
                                    .scaledToFit()
                                    .shadow(color: Color.gray.opacity(0.5), radius: 1)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            if task == "Vowel" {
                                Text(task)
                                    .foregroundColor(settings.vowel ? Color.white : Color.gray)
                                    .font(._buttonFieldCopyLarger)
                            }
                            if task == "Maximum Phonation Time (MPT)" {
                                Text(task)
                                    .foregroundColor(settings.maxPT ? Color.white : Color.gray)
                                    .font(._buttonFieldCopyLarger)
                            }
                            if task == "Rainbow Sequence" {
                                Text(task)
                                    .foregroundColor(settings.rainbowS ? Color.white : Color.gray)
                                    .font(._buttonFieldCopyLarger)
                            }
                            
                            if task == "Vowel" {
                                Text("Say ahh for 5 seconds")
                                    .foregroundColor(settings.vowel ? Color.white : Color.DARK_PURPLE)
                                    .font(._subCopy)
                                    .multilineTextAlignment(.leading)
                                    .padding(.trailing, 2)
                            }
                            if task == "Maximum Phonation Time (MPT)" {
                                Text("Say ahh for as long as you can")
                                    .foregroundColor(settings.maxPT ? Color.white : Color.DARK_PURPLE)
                                    .font(._subCopy)
                                    .multilineTextAlignment(.leading)
                                    .padding(.trailing, 2)
                            }
                            if task == "Rainbow Sequence" {
                                Text("The rainbow is a division of white light into many beautiful colors...")
                                    .foregroundColor(settings.rainbowS ? Color.white : Color.DARK_PURPLE)
                                    .font(._subCopy)
                                    .multilineTextAlignment(.leading)
                                    .padding(.trailing, 2)
                            }
                        }
                        .padding(.leading, svm.content_width / 6)
                    }
                }
            }
        }.padding(.top, 10)
    }
    
    private var acousticParametersSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Acoustic Parameters
            Text("Acoustic Parameters")
                .font(._fieldLabel)
            
            VStack(spacing: 7) {
                HStack {
                    Button(action: {
                        self.settings.pitch.toggle()
                    }) {
                        SelectionImage(picked: self.settings.pitch, text: "Pitch")
                    }
                    
                    Button(action: {
                        self.settings.CPP.toggle()
                    }) {
                        SelectionImage(picked: self.settings.CPP, text: "Cepstral Peak Prominence (CPP)")
                    }
                }.frame(height: svm.content_width * 0.105576)
                
                HStack {
                    Button(action: {
                        self.settings.intensity.toggle()
                    }) {
                        SelectionImage(picked: self.settings.intensity, text: "Intensity")
                    }
                    
                    Button(action: {
                        self.settings.duration.toggle()
                    }) {
                        SelectionImage(picked: self.settings.duration, text: "Duration")
                    }
                }.frame(height: svm.content_width * 0.105576)
                
                HStack {
                    Button(action: {
                        self.settings.minPitch.toggle()
                    }) {
                        SelectionImage(picked: self.settings.minPitch, text: "Minimum Pitch")
                    }
                    
                    Button(action: {
                        self.settings.maxPitch.toggle()
                    }) {
                        SelectionImage(picked: self.settings.maxPitch, text: "Maximum Pitch")
                    }
                }
                .frame(height: svm.content_width * 0.105576)
            }
        }
        .padding(.top, 10)
    }
    
    private var questionnairesSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Questionniares
            Text("Questionnaires")
                .font(._fieldLabel)
            
            /// vhi
            Button(action: {
                settings.vhi.toggle()
            }) {
                ZStack(alignment: .leading) {
                    Image(settings.vhi ? large_select_img : large_unselect_img)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color.gray.opacity(0.5), radius: 1)
                    
                    VStack(alignment: .leading) {
                        Text("VHI")
                            .foregroundColor(settings.vhi ? Color.white : Color.gray)
                            .font(._buttonFieldCopyLarger)
                            .multilineTextAlignment(.leading)
                        
                        Text("Vocal Handicap Index (VHI)-10")
                            .foregroundColor(settings.vhi ? Color.white : Color.DARK_PURPLE)
                            .font(._subCopy)
                            .multilineTextAlignment(.leading)
                            .padding(.trailing, 2)
                    }.padding(.leading, svm.content_width / 6)
                }
            }
            
            /// vocal effort
            Button(action: {
                settings.vocalEffort.toggle()
            }) {
                ZStack(alignment: .leading) {
                    Image(settings.vocalEffort ? large_select_img : large_unselect_img)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color.gray.opacity(0.5), radius: 1)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Vocal Effort")
                            .foregroundColor(settings.vocalEffort ? Color.white : Color.gray)
                            .font(._buttonFieldCopyLarger)
                        
                        Text("Ratings of physical and mental effort to make a voice")
                            .foregroundColor(settings.vocalEffort ? Color.white : Color.DARK_PURPLE)
                            .font(._subCopy)
                            .multilineTextAlignment(.leading)
                            .padding(.trailing, 2)
                    }
                    .padding(.leading, svm.content_width / 6)
                }
            }
            
            Spacer()
        }
        .padding(.top, 10)
    }
}

struct SelectionImage: View {
    @State private var svm = SharedViewModel()
    
    let picked: Bool
    let text: String
    
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    let info_img = "VM_info-icon"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Image(picked ? select_img : unselect_img)
                    .resizable()
                    .scaledToFit()
                
                HStack(spacing: 0) {
                    Text(text)
                        .font(._buttonFieldCopy)
                        .foregroundColor(picked ? Color.white : Color.BODY_COPY)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, geometry.size.width * 0.176)
                    
                    Spacer()
                    
                    VStack {
                        Image(info_img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.062, height: geometry.size.width * 0.062)
                            .padding(.trailing, geometry.size.width * 0.0245)
                            .padding(.top, geometry.size.width * 0.0245)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct GoalEntryView: View {
    @EnvironmentObject var notification: Notification
    @EnvironmentObject var settings: Settings
    
    @State private var svm = SharedViewModel()
    @State private var recordPerWeek = 0
    @State private var questsPerWeek = 0
    @State private var journalsPerWeek = 0
    @State private var numWeeks = 0
    
    let perWeekOptions = [1, 2, 3, 4, 5, 6, 7]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            ///
            /// check a function that determines if goal is active, funciton consideres:
            ///     not expired
            ///     set true by boolean
            ///
            /// based on this function we will enter one of two different modes,
            ///     filling out new goal
            ///     informing on current goal
            ///
            /// if newEntry -> settingSection
            ///     ask how many times a week
            ///     ask if want notifiations(On by default ignore smart notification functionality)
            ///     set button sets start time and hides the rest of the page
            ///
            /// else -> informSection
            ///     inform on current attributes of the goal
            ///
            
            Spacer()
            
            header
            
            if settings.isActive() {
                informSection
            } else {
                settingSection
            }
            
            Spacer()
        }
        .frame(width: svm.content_width)
    }
}

extension GoalEntryView {
    private var header: some View {
        HStack {
            Text("Goals")
                .font(._title)
            
            Spacer()
        }.padding(.vertical)
    }
    
    private var informSection: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if settings.isActive() {
                    Text("Your goal is active as of \(settings.startDate).")
                        .padding(.vertical, 5)
                }
                Text("The goal will last \(settings.numWeeks) weeks and you will complete \(settings.recordPerWeek) recordings, \(settings.journalsPerWeek) journals, and \(settings.surveysPerWeek) questionnaires,  per week.")
                
                VStack {
                    HStack(spacing: 5) {
                        Circle().foregroundColor(.black).frame(width: 8, height: 8)
                        Text("Your have entered \(settings.recordEntered) recordings so far")
                        Spacer()
                    }
                    HStack(spacing: 5) {
                        Circle().foregroundColor(.black).frame(width: 8, height: 8)
                        Text("Your have entered \(settings.journalEntered) journals so far")
                        Spacer()
                    }
                    HStack(spacing: 5) {
                        Circle().foregroundColor(.black).frame(width: 8, height: 8)
                        Text("Your have entered \(settings.questionnaireEntered) questionnaires so far")
                        Spacer()
                    }
                }
                .padding(.vertical)
            }
            .font(._bodyCopy)
            .foregroundColor(Color.BODY_COPY)
            
            Button(action: {
                self.clearGoal()
            }) {
                HStack {
                    Spacer()
                    ZStack {
                        Image(svm.button_img)
                            .resizable()
                            .frame(width: 225, height: 40)
                        
                        Text("RESET GOAL")
                            .font(._BTNCopy)
                            .foregroundColor(Color.white)
                    }
                    .padding(.top, 10)
                    Spacer()
                }
            }
        }
    }

    private var settingSection: some View {
        VStack(alignment: .leading) {
            Text("Define your goals here.")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .padding(.bottom)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text("Number of recordings per week")
                            .font(._fieldLabel)
                        
                        Menu {
                            Picker("", selection: $recordPerWeek) {
                                ForEach(perWeekOptions, id: \.self) { option in
                                    Text("\(option)")
                                        .font(._bodyCopy)
                                }
                            }
                        } label: {
                            ZStack {
                                EntryField()
                                
                                HStack {
                                    Text("\(recordPerWeek == 0 ? 0 : recordPerWeek) per week")
                                        .font(._bodyCopy)
                                    Spacer()
                                    
                                    Arrow()
                                }.padding(.horizontal, 5)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    
                    Group {
                        Text("Number of questionnaires per week")
                            .font(._fieldLabel)
                        
                        Menu {
                            Picker("", selection: $questsPerWeek) {
                                ForEach(perWeekOptions, id: \.self) { option in
                                    Text("\(option)")
                                        .font(._bodyCopy)
                                }
                            }
                        } label: {
                            ZStack {
                                EntryField()
                                
                                HStack {
                                    Text("\(questsPerWeek == 0 ? 0 : questsPerWeek) per week")
                                        .font(._bodyCopy)
                                    Spacer()
                                    
                                    Arrow()
                                }.padding(.horizontal, 5)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    
                    Group {
                        Text("Number of journals per week")
                            .font(._fieldLabel)
                        
                        Menu {
                            Picker("", selection: $journalsPerWeek) {
                                ForEach(perWeekOptions, id: \.self) { option in
                                    Text("\(option)")
                                        .font(._bodyCopy)
                                }
                            }
                        } label: {
                            ZStack {
                                EntryField()
                                
                                HStack {
                                    Text("\(journalsPerWeek == 0 ? 0 : journalsPerWeek) per week")
                                        .font(._bodyCopy)
                                    Spacer()
                                    
                                    Arrow()
                                }.padding(.horizontal, 5)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    
                    Text("Number of weeks to achieve goal")
                        .font(._fieldLabel)
                    
                    Menu {
                        Picker("", selection: $numWeeks) {
                            ForEach(perWeekOptions, id: \.self) { option in
                                HStack {
                                    Text("\(option)")
                                        .font(._bodyCopy)
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            EntryField()
                            
                            HStack {
                                Text(numWeeks == 1 ? "\(numWeeks == 0 ? 0 : numWeeks) week" : "\(numWeeks == 0 ? 0 : numWeeks) weeks")
                                    .font(._bodyCopy)
                                Spacer()
                                
                                Arrow()
                            }.padding(.horizontal, 5)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    Text("Ensure notifications are turned on by going to Settings -> Vomo -> Notifications -> Allow Notifications.")
                        .font(._bodyCopy)
                        .foregroundColor(Color.BODY_COPY)
                    Text("If this does not work, delete notifications, redownload the app and allow notifications when the alert appears.")
                        .font(._bodyCopy)
                        .foregroundColor(Color.BODY_COPY)
                    Text("Notifications will be delivered at 7pm every day, as long as the goal is running and set, until more complexity is added into the system.")
                        .font(._bodyCopy)
                        .foregroundColor(Color.BODY_COPY)
                        .padding(.bottom)
                    
                    HStack {
                        Spacer()
                        
                        if numWeeks != 0 {
                            Button(action: {
                                settings.setGoal(nWeeks: numWeeks, records: recordPerWeek, quests: questsPerWeek, journs: journalsPerWeek)
                                
                                notification.updateNotifications(triggers: settings.triggers())
                            }) {
                                SubmissionButton(label: "SET GOAL")
                            }
                            .padding(.top, 10)
                        } else {
                            SubmissionButton(label: "SET GOAL")
                            .padding(.top, 10)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .foregroundColor(Color.black)
    }
    
    func clearGoal() {
        self.numWeeks = 0
        self.recordPerWeek = 0
        self.journalsPerWeek = 0
        self.questsPerWeek = 0
        self.settings.clearGoal()
    }
}

struct GoalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        GoalEntryView()
            .environmentObject(Notification())
    }
}
