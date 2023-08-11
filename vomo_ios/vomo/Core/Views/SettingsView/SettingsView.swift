//
//  SettingsView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

/*
 
 Fix PickerEntryField
 Add AltPickerEntryField
 Wrap up the rest of settings
 Move on to other parts of the application
 
 */

struct SettingsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var settings = Settings.shared
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var entries: Entries
    
    // Variables for settings
    @State private var sex = Settings.shared.sexAtBirth
    @State private var gender = Settings.shared.gender
    
    // Show or hide calendars
    @State private var showCalendar = false
    @State private var showOnsetCal = false
    
    @State private var showGoals = false
    @State private var showNotifications = false
    @State private var showDeleteWarning = false
    let svm = SharedViewModel()
    
    #if DEBUG
        @State private var showDebugMenu = false
    #endif
	
	@State private var selectedFiles = [URL]()
    
    var body: some View {
        ZStack {
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
                    
                    extraButtonSection
                    
                    Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")")
                        .font(._bodyCopyUnBold)

                    // MARK: Debug Menu
                    #if DEBUG
                    
                    Button {
                        self.showDebugMenu = true
                    } label: {
                        Text("Debug Menu")
                            .font(._bodyCopyLargeMedium)
                            .underline()
                            .foregroundColor(Color.DARK_PURPLE)
                    }
                    
                    #endif
                }
                .font(._fieldLabel)
                .padding(.bottom, 75)
                
                Spacer()
            }
            .frame(width: svm.content_width)
            
            popUpSection
        }
        
        #if DEBUG
        .sheet(isPresented: $showDebugMenu) {
            DebugMenuView()
        }
        #endif
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
            
            NameEntryField(topic: $settings.firstName, label: "First Name", type: .givenName)
        }
    }
    
    private var lastName: some View {
        Group {
            Text("Last Name")
            
            NameEntryField(topic: $settings.lastName, label: "Last Name", type: .familyName)
        }
    }
    
    private var dateOfBirth: some View {
        Group {
            Text("Date of Birth")
            
            DateEntryField(toggle: self.$showCalendar, date: self.$settings.dob)
       
            ZStack {
                if showCalendar {
                    DatePicker("", selection: $settings.dob, in: ...Date.now, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(maxWidth: svm.content_width * 0.9)
                }
            }
            .transition(.slide)
        }
        .padding(.bottom, 5)
    }
    
    private var sexAtBirth: some View {
        Group {
            Text("Sex (assigned at birth)")
            
            Menu {
                Picker("choose", selection: $sex) {
                    ForEach(SexAtBirth.allCases, id: \.self) { sex in
                        Text("\(sex.rawValue)")
                            .font(._fieldCopyRegular)
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())

            } label: {
                ZStack {
                    EntryField()
                    
                    HStack {
                        Text("\(sex.rawValue)")
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
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text("\(gender.rawValue)")
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
                        Text("\(gender.rawValue)")
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
            Text("Did your voice problem begin on a specific date?")
            
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
                    Text("When did your voice problem begin?")
                    
                    DateEntryField(toggle: self.$showOnsetCal, date: self.$settings.dateOnset)
                    
                    ZStack {
                        if showOnsetCal {
                            DatePicker("Pick date", selection: $settings.dateOnset, in: ...Date.now, displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                                .frame(maxWidth: svm.content_width * 0.9, maxHeight: 400)
                        }
                    }
                    .transition(.slide)
                }
            }
            .transition(.slide)
            
            Text("Allow incomplete surveys?")
                .padding(.top)
            
            HStack(spacing: 0) {
                Button("") {
                    withAnimation() {
                        self.settings.allowIncompleteSurvey = true
                    }
                }.buttonStyle(YesButton(selected: settings.allowIncompleteSurvey))
                Spacer()
                Button("") {
                    withAnimation() {
                        self.settings.allowIncompleteSurvey = false
                    }
                }.buttonStyle(NoButton(selected: settings.allowIncompleteSurvey))
            }
        }
    }
    
    private var trackStatementSection: some View {
        Button(action: {
            viewRouter.currentPage = .onboard
        }) {
            VStack(spacing: 0) {
                HStack {
                    Text("You are on \(svm.vocalIssues[settings.focusSelection]) track ")
                        .foregroundColor(Color.BODY_COPY)
                    Spacer()
                }
                HStack {
                    Text("Edit")
                        .underline()
                        .foregroundColor(Color.DARK_PURPLE)
                    Spacer()
                }
            }
            .font(._bodyCopyLargeMedium)
            .padding(.vertical)
        }
    }
    
    private var extraButtonSection: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.showGoals.toggle()
            }) {
                Text("Edit Goals")
                    .font(._bodyCopyLargeMedium)
                    .underline()
                    .foregroundColor(Color.DARK_PURPLE)
            }
            .padding(.bottom)
            
            Button(action: {
                self.showNotifications.toggle()
            }) {
                Text("Edit Reminders")
                    .font(._bodyCopyLargeMedium)
                    .underline()
                    .foregroundColor(Color.DARK_PURPLE)
            }
            
            Button(action: {
                selectedFiles = audioRecorder.allFiles()
                
                var filesToShare = [Any]()
                for fileURL in selectedFiles {
                    do {
                        let data = try Data(contentsOf: fileURL)
                        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileURL.lastPathComponent)
                        try data.write(to: tempURL)
                        filesToShare.append(tempURL)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                    
                    
                if !filesToShare.isEmpty {
                    let activityVC = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                    let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
                    let window = windowScene?.windows.first(where: { $0.isKeyWindow })
                    window?.rootViewController?.present(activityVC, animated: true)
                }
            }) {
                HStack {
                    Image(svm.share_button_alt)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22.5)
                    Text("Share all voice recording data")
                        .font(._bodyCopyLargeMedium)
                        .underline()
                        .foregroundColor(Color.DARK_PURPLE)
                    Spacer()
                }
            }
            .padding(.vertical)
            
            Button(action: {
                self.showDeleteWarning = true
            }) {
                Text("Delete All Collected Data")
                    .font(._bodyCopyLargeMedium)
                    .underline()
                    .foregroundColor(Color.red)
            }
            .padding(.vertical)
        }
    }
    
    private var popUpSection: some View {
        Group {
            if showGoals {
                ZStack {
                    Button(action: {
                        self.showGoals.toggle()
                    }) {
                        Color.gray.opacity(0.1)
                    }
                    
                    GoalEntryView()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray, radius: 1)
                        .padding()
                        .padding()
                }
            }
            
            if showNotifications {
                ZStack {
                    Button(action: {
                        self.showNotifications.toggle()
                    }) {
                        Color.gray.opacity(0.1)
                    }
                    
                    ReminderPopUp(showNotifications: $showNotifications)
                }
            }
            
            if showDeleteWarning {
                ZStack {
                    Color.white
                        .frame(width: svm.content_width * 0.7, height: 200)
                        .shadow(color: Color.gray, radius: 1)
                    
                    VStack(alignment: .leading) {
                        Text("Confim you would like to delete all data?")
                            .font(._bodyCopyLargeMedium)
                            .multilineTextAlignment(.leading)
                        Text("This cannot be reversed")
                            .font(._bodyCopy)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showDeleteWarning = false
                            }) {
                                Text("Cancel")
                                    .foregroundColor(Color.red)
                                    .font(._bodyCopyMedium)
                            }
                            Spacer()
                            Button(action: {
                                deleteAllData()
                                self.showDeleteWarning = false
                            }) {
                                Text("Yes")
                                    .foregroundColor(Color.green)
                                    .font(._bodyCopyMedium)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .padding(5)
                    .frame(width: svm.content_width * 0.7, height: 200)
                }
            }
        }
    }
    
    func deleteAllData() {
        entries.treatments.removeAll()
        entries.journals.removeAll()
        entries.questionnaires.removeAll()
        
        audioRecorder.deleteAllRecordings()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .foregroundColor(Color.black)
            .environmentObject(ViewRouter.shared)
    }
}

class DocumentPicker: NSObject, UIDocumentPickerDelegate {
    
    var selectedFiles = [URL]()
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedFiles.append(contentsOf: urls)
    }
}
