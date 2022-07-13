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
    
    let banner_img = "VoMo-App-Assets_2_13-freewrite-banner-FPO"
    
    let tag_img = "VM_12-tags-entry-field"
    let field_img = "VM_12-entry-field"
    
    let button_img = "VM_Gradient-Btn"

    
    @State private var svm = SharedViewModel()
    
    @State private var name = ""
    @State private var note = ""
    
    
    @FocusState private var focused: Bool
    
    init() {
            UITextView.appearance().backgroundColor = .clear
        }
    
    var body: some View {
        VStack(spacing: 0) {
            ProfileButton()
            
            HStack {
                Text("Journal")
                    .font(._headline)
                
                Spacer()
            }
            
            widgetView
            
            VStack(spacing: 0) {
                ZStack {
                    Image(field_img)
                        .resizable()
                        .frame(height: 30)
                    
                    TextField(self.name.isEmpty ? "Enter Note Name" : self.name, text: self.$name)
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
        }
        .frame(width: svm.content_width)
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
    private var widgetView: some View {
        ZStack {
            Image(banner_img)
                .resizable()
                .scaledToFit()
            
            VStack(alignment: .leading) {
                Spacer()
                Text("How does")
                    .foregroundColor(.white)
                Text("your voice")
                    .foregroundColor(.BRIGHT_PURPLE.opacity(0.8))
                HStack(spacing: 0) {
                    Text("feel today")
                        .foregroundColor(.white)
                    Text("?")
                        .foregroundColor(.TEAL)
                    Spacer()
                }
            }
            .padding()
            .font(._subHeadline)
            .frame(width: svm.content_width, height: 190)
        }
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
