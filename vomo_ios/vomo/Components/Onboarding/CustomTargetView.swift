//
//  CustomTargetView.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/1/22.
//

import SwiftUI

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
                        self.settings.mpt.toggle()
                    } else if task == "Rainbow Sequence" {
                        self.settings.rainbow.toggle()
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
                                Image(settings.mpt ? large_select_img : large_unselect_img)
                                    .resizable()
                                    .scaledToFit()
                                    .shadow(color: Color.gray.opacity(0.5), radius: 1)
                            }
                            if task == "Rainbow Sequence" {
                                Image(settings.rainbow ? large_select_img : large_unselect_img)
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
                                    .foregroundColor(settings.mpt ? Color.white : Color.gray)
                                    .font(._buttonFieldCopyLarger)
                            }
                            if task == "Rainbow Sequence" {
                                Text(task)
                                    .foregroundColor(settings.rainbow ? Color.white : Color.gray)
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
                                    .foregroundColor(settings.mpt ? Color.white : Color.DARK_PURPLE)
                                    .font(._subCopy)
                                    .multilineTextAlignment(.leading)
                                    .padding(.trailing, 2)
                            }
                            if task == "Rainbow Sequence" {
                                Text("The rainbow is a division of white light into many beautiful colors...")
                                    .foregroundColor(settings.rainbow ? Color.white : Color.DARK_PURPLE)
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

struct CustomTargetView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTargetView()
    }
}
