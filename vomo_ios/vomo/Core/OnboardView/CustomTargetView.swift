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
    @State private var showNote = false
    @State private var noteSelection = 0
    
    let vocalTasks = ["Vowel", "Maximum Phonation Time (MPT)", "Rainbow Sequence"]
    
    let title = ["Pitch", "CPP", "Intensity", "Duration", "Minimum Pitch", "Maximum Pitch"]
    let body_text = ["Mean fundemental frequency", "Cepstral peak prominence: indicative of dysphonia severity", "Measured in sound pressure level (dB)", "Time (seconds) someone can sustain", "Lowest fundemental frequency taken during connnected speech", "Highest fundemental frequency taken during connnected speech"]
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                header
                
                ScrollView(showsIndicators: false) {
                    vocalTaskSection
                    
                    acousticParametersSection
                    
                    surveysSection
                    
                    Spacer()
                }
            }.frame(width: svm.content_width)
            
            if showNote {
                Button(action: {
                    self.showNote.toggle()
                }) {
                    ZStack {
                        Color.gray.opacity(0.1)
                        ZStack {
                            Color.white.frame(width: svm.content_width * 0.7, height: UIScreen.main.bounds.height * 0.25)
                                .cornerRadius(12.5)
                                .shadow(color: Color.gray.opacity(0.7), radius: 2)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(title[noteSelection])
                                        .font(._BTNCopy)
                                    Spacer()
                                }
                                HStack {
                                    Text(body_text[noteSelection])
                                        .font(._BTNCopyUnbold)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding(7.5)
                            .frame(width: svm.content_width * 0.7, height: UIScreen.main.bounds.height * 0.25)
                        }
                        .frame(width: svm.content_width * 0.7, height: UIScreen.main.bounds.height * 0.25)
                    }
                }
            }
        }
    }
}

extension CustomTargetView {
    private var header: some View {
        VStack(spacing: 0) {
            Text("Custom Plan")
                .font(._title)
                .padding(.bottom, 5)
            
            Text("Decide your tasks and voice measurements.")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.center)
        }
    }
    
    private var vocalTaskSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Vocal Tasks
            Text("Vocal Tasks")
                .font(._fieldLabel)
            
            ForEach(vocalTasks, id: \.self) { task in
                VStack {
                    /// all three ones
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
                            ZStack {
                                if task == "Vowel" {
                                    if settings.vowel {
                                        Color.MEDIUM_PURPLE
                                            .frame(width: svm.content_width - 2, height: 60)
                                    } else {
                                        Color.white
                                            .frame(width: svm.content_width - 2, height: 60)
                                    }
                                    
                                    HStack {
                                        Image(settings.vowel ? svm.select : svm.unselect)
                                            .resizable()
                                            .frame(width: 27.5, height: 27.5)
                                            .padding(.leading, 15)
                                        
                                        Spacer()
                                    }
                                }
                                if task == "Maximum Phonation Time (MPT)" {
                                    if settings.mpt {
                                        Color.MEDIUM_PURPLE
                                            .frame(width: svm.content_width - 2, height: 60)
                                    } else {
                                        Color.white
                                            .frame(width: svm.content_width - 2, height: 60)
                                    }
                                    
                                    HStack {
                                        Image(settings.mpt ? svm.select : svm.unselect)
                                            .resizable()
                                            .frame(width: 27.5, height: 27.5)
                                            .padding(.leading, 15)
                                        
                                        Spacer()
                                    }
                                }
                                if task == "Rainbow Sequence" {
                                    if settings.rainbow {
                                        Color.MEDIUM_PURPLE
                                            .frame(width: svm.content_width - 2, height: 60)
                                    } else {
                                        Color.white
                                            .frame(width: svm.content_width - 2, height: 60)
                                    }
                                    
                                    HStack {
                                        Image(settings.rainbow ? svm.select : svm.unselect)
                                            .resizable()
                                            .frame(width: 27.5, height: 27.5)
                                            .padding(.leading, 15)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .cornerRadius(10)
                            .shadow(color: Color.gray, radius: 1)
                            .padding(1)
                            
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
                            .padding(.leading, svm.content_width / 7)
                        }
                    }
                }.frame(width: svm.content_width)
            }
        }.padding(.top, 10)
    }
    
    private var acousticParametersSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Acoustic Parameters
            Text("Acoustic Parameters")
                .font(._fieldLabel)
            
            VStack(spacing: 9.5) {
                HStack {
                    Button(action: {
                        self.settings.pitch.toggle()
                    }) {
                        SelectionImage(picked: self.settings.pitch, text: "Pitch", count: 0, showNote: $showNote, noteSelection: $noteSelection)
                    }
                    
                    Button(action: {
                        self.settings.CPP.toggle()
                    }) {
                        SelectionImage(picked: self.settings.CPP, text: "Cepstral Peak Prominence", count: 1, showNote: $showNote, noteSelection: $noteSelection)
                    }
                }.frame(height: svm.content_width * 0.105576)
                
                HStack {
                    Button(action: {
                        self.settings.intensity.toggle()
                    }) {
                        SelectionImage(picked: self.settings.intensity, text: "Intensity", count: 2, showNote: $showNote, noteSelection: $noteSelection)
                    }
                    
                    Button(action: {
                        self.settings.duration.toggle()
                    }) {
                        SelectionImage(picked: self.settings.duration, text: "Duration", count: 3, showNote: $showNote, noteSelection: $noteSelection)
                    }
                }.frame(height: svm.content_width * 0.105576)
                
                HStack {
                    Button(action: {
                        self.settings.minPitch.toggle()
                    }) {
                        SelectionImage(picked: self.settings.minPitch, text: "Minimum Pitch", count: 4, showNote: $showNote, noteSelection: $noteSelection)
                    }
                    
                    Button(action: {
                        self.settings.maxPitch.toggle()
                    }) {
                        SelectionImage(picked: self.settings.maxPitch, text: "Maximum Pitch", count: 5, showNote: $showNote, noteSelection: $noteSelection)
                    }
                }
                .frame(height: svm.content_width * 0.105576)
            }
        }
        .padding(.top, 10)
    }
    
    private var surveysSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Questionniares
            Text("Surveys")
                .font(._fieldLabel)
            
            VStack {
                /// vhi
                Button(action: {
                    settings.vhi.toggle()
                }) {
                    ZStack(alignment: .leading) {
                        ZStack {
                            if settings.vhi {
                                Color.MEDIUM_PURPLE
                                    .frame(width: svm.content_width - 2, height: 60)
                            } else {
                                Color.white
                                    .frame(width: svm.content_width - 2, height: 60)
                            }
                            
                            HStack {
                                Image(settings.vhi ? svm.select : svm.unselect)
                                    .resizable()
                                    .frame(width: 27.5, height: 27.5)
                                    .padding(.leading, 15)
                                Spacer()
                            }
                        }
                        .cornerRadius(10)
                        .shadow(color: Color.gray, radius: 1)
                        .padding(1)
                        
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
                        }.padding(.leading, svm.content_width / 7)
                    }
                }
            }.frame(width: svm.content_width)
            
            VStack {
                /// vocal effort
                Button(action: {
                    settings.vocalEffort.toggle()
                }) {
                    ZStack(alignment: .leading) {
                        ZStack {
                            if settings.vocalEffort {
                                Color.MEDIUM_PURPLE
                                    .frame(width: svm.content_width - 2, height: 60)
                            } else {
                                Color.white
                                    .frame(width: svm.content_width - 2, height: 60)
                            }
                            
                            HStack {
                                Image(settings.vocalEffort ? svm.select : svm.unselect)
                                    .resizable()
                                    .frame(width: 27.5, height: 27.5)
                                    .padding(.leading, 15)
                                Spacer()
                            }
                        }
                        .cornerRadius(10)
                        .shadow(color: Color.gray, radius: 1)
                        .padding(1)
                        
                        VStack(alignment: .leading) {
                            Text("Vocal Effort")
                                .foregroundColor(settings.vocalEffort ? Color.white : Color.gray)
                                .font(._buttonFieldCopyLarger)
                                .multilineTextAlignment(.leading)
                            
                            Text("Ratings of physical and mental effort to make a voice")
                                .foregroundColor(settings.vocalEffort ? Color.white : Color.DARK_PURPLE)
                                .font(._subCopy)
                                .multilineTextAlignment(.leading)
                                .padding(.trailing, 2)
                        }.padding(.leading, svm.content_width / 7)
                    }
                }
            }.frame(width: svm.content_width)
            
            VStack {
                /// vocal effort
                Button(action: {
                    settings.botulinumInjection.toggle()
                }) {
                    ZStack(alignment: .leading) {
                        ZStack {
                            if settings.botulinumInjection {
                                Color.MEDIUM_PURPLE
                                    .frame(width: svm.content_width - 2, height: 60)
                            } else {
                                Color.white
                                    .frame(width: svm.content_width - 2, height: 60)
                            }
                            
                            HStack {
                                Image(settings.botulinumInjection ? svm.select : svm.unselect)
                                    .resizable()
                                    .frame(width: 27.5, height: 27.5)
                                    .padding(.leading, 15)
                                Spacer()
                            }
                        }
                        .cornerRadius(10)
                        .shadow(color: Color.gray, radius: 1)
                        .padding(1)
                        
                        VStack(alignment: .leading) {
                            Text("Botulinum Injection Survey")
                                .foregroundColor(settings.botulinumInjection ? Color.white : Color.gray)
                                .font(._buttonFieldCopyLarger)
                                .multilineTextAlignment(.leading)
                            
                            Text("Laryngeal Dystonia and Vocal Tremor")
                                .foregroundColor(settings.botulinumInjection ? Color.white : Color.DARK_PURPLE)
                                .font(._subCopy)
                                .multilineTextAlignment(.leading)
                                .padding(.trailing, 2)
                        }.padding(.leading, svm.content_width / 7)
                    }
                }
            }.frame(width: svm.content_width)
            
            Spacer()
        }
        .padding(.top, 10)
    }
}

struct SelectionImage: View {
    @State private var svm = SharedViewModel()
    
    let picked: Bool
    let text: String
    let count: Int
    
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    let info_img = "VM_info-icon"
    
    @Binding var showNote: Bool
    @Binding var noteSelection: Int
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack {
                if picked {
                    Color.MEDIUM_PURPLE
                        .frame(width: (svm.content_width - 2) / 2, height: 37.5)
                } else {
                    Color.INPUT_FIELDS
                        .frame(width: (svm.content_width - 2) / 2, height: 37.5)
                }
                
                HStack {
                    Image(picked ? svm.select : svm.unselect)
                        .resizable()
                        .frame(width: 27.5, height: 27.5)
                        .padding(.leading, 15)
                    Spacer()
                }
            }
            .cornerRadius(10)
            .shadow(color: Color.gray, radius: 1)
            .padding(1)
            
            HStack(spacing: 0) {
                Text(text)
                    .font(._buttonFieldCopy)
                    .foregroundColor(picked ? Color.white : Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, svm.content_width / 7)
                
                Spacer()
                
                Button(action: {
                    self.showNote.toggle()
                    self.noteSelection = count
                }) {
                    VStack {
                        Image(info_img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .padding(.trailing, 5)
                            .padding(.top, 5)
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
