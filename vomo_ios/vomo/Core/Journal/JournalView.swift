//
//  JournalView.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/8/22.
//

import SwiftUI

struct JournalView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var entries: Entries
    
    let banner_img = "VoMo-App-Assets_journalEntry-Banner"
    let tag_img = "VM_12-tags-entry-field"
    let field_img = "VM_12-entry-field"
    let button_img = "VM_Gradient-Btn"

    
    @State private var svm = SharedViewModel()
    @State private var name = ""
    @State private var note = ""
    @State private var submitAnimation = false
    
    @FocusState private var focused: Bool
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    VStack {
                        header
                        
                        widgetView
                        
                        VStack(spacing: 0) {
                            ZStack {
                                Image(field_img)
                                    .resizable()
                                    .frame(height: 30)
                                
                                TextField(self.name.isEmpty ? "Enter Note Name..." : self.name, text: self.$name)
                                    .focused($focused)
                                    .font(self.name.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                                    .foregroundColor(Color.black)
                                    .padding(.leading, 8)
                            }
                            .frame(height: 30)
                            .padding(.top)
                            
                            ZStack {
                                Image(field_img)
                                    .resizable()
                                    .frame(height: 175)
                                
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        Text(self.note.isEmpty ? "Write your note..." : "")
                                            .font(._fieldCopyItalic)
                                            .foregroundColor(Color.gray)
                                            .font(._fieldCopyRegular)
                                            .padding(8)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                
                                TextEditor(text: self.$note)
                                    .font(self.note.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                                    .focused($focused)
                                    .font(._fieldCopyRegular)
                                    .padding(.leading, 5)
                            }
                            .frame(height: 175)
                            .padding(.top, 5)
                        }
                        
                        addNoteButton
                        
                        Spacer()
                    }
                }
                
            }
            .frame(width: svm.content_width)
            
            if submitAnimation {
                ZStack {
                    Color.gray
                        .frame(width: 125, height: 125)
                        .cornerRadius(10)
                    
                    VStack {
                        Image(systemName: "checkmark")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding(.vertical)
                        Text("Note Added!")
                            .foregroundColor(Color.white)
                            .font(._BTNCopy)
                            .padding(.bottom)
                    }
                }
                .onAppear() {
                    withAnimation(.easeOut(duration: 2.5)) {
                        submitAnimation.toggle()
                    }
                }
                .opacity(submitAnimation ? 0.6 : 0.0)
                .zIndex(1)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Done") {
                    focused = false
                }
                .font(._subHeadline)
                .foregroundColor(Color.DARK_PURPLE)
            }
        }
    }
}

extension JournalView {
    private var header: some View {
        VStack(spacing: 0) {
            ProfileButton()
            
            HStack {
                Text("Journal")
                    .font(._headline)
                
                Spacer()
            }
        }
    }
    private var widgetView: some View {
        Image(banner_img)
            .resizable()
            .scaledToFit()
    }
    
    private var addNoteButton: some View {
        Group {
            if self.name.isEmpty || self.note.isEmpty {
                ZStack {
                    Image(button_img)
                        .resizable()
                        .frame(width: 225, height: 40)
                    
                    Text("ADD NOTE")
                        .font(._BTNCopyUnbold)
                        .foregroundColor(Color.INPUT_FIELDS)
                }
                .padding(.top, 10)
            } else {
                Button(action: {
                    self.entries.journals.append(JournalModel(createdAt: .now, noteName:  self.name, note: self.note))
                    self.name = ""
                    self.note = ""
                    submitAnimation = true
                }) {
                    SubmissionButton(label: "ADD NOTE")
                        .padding(.top, 10)
                }
            }
        }
    }
    
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}
