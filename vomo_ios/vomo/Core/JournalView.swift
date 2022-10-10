//
//  JournalView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

/*
 show and hide a view when the keyboard is present
 maybe a published variable under entries
 */
struct JournalView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var settings: Settings
    
    @State private var name = ""
    @State private var note = ""
    @State private var submitAnimation = false
    
    @FocusState private var focused: Bool
    
    let svm = SharedViewModel()
    
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
                                Image(svm.field_img)
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
                                Image(svm.field_img)
                                    .resizable()
                                    .frame(width: svm.content_width, height: 175)
                                
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
                        
                        if !settings.keyboardShown {
                            addNoteButton
                        }
                        
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
        .onChange(of: focused) { focus in
            settings.keyboardShown = focus
        }
        .focused($focused)
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
        HStack {
            Text("Journal")
                .font(._title)
            Spacer()
        }
    }
    private var widgetView: some View {
        Image(svm.banner_img)
            .resizable()
            .scaledToFit()
    }
    
    private var addNoteButton: some View {
        Group {
            if self.name.isEmpty || self.note.isEmpty {
                ZStack {
                    Image(svm.button_img)
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
            .environmentObject(Entries())
            .environmentObject(Settings())
    }
}
