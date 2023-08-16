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
    @ObservedObject var settings = Settings.shared

    @State private var note = ""
    @State private var submitAnimation = false
    
    @FocusState private var focused: Bool
    
    let svm = SharedViewModel()
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    @State var timeRemaining = 2
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                                
                                
                                if #available(iOS 16.0, *) {
                                    TextEditor(text: self.$note)
                                        .font(self.note.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                                        .focused($focused)
                                        .font(._fieldCopyRegular)
                                        .padding(.leading, 5)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.INPUT_FIELDS)
                                } else {
                                    // Fallback on earlier versions
                                    TextEditor(text: self.$note)
                                        .font(self.note.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                                        .focused($focused)
                                        .font(._fieldCopyRegular)
                                        .padding(.leading, 5)
                                        .background(Color.INPUT_FIELDS)
                                }
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
                
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                    if timeRemaining == 0 {
                        self.viewRouter.currentPage = .home
                    }
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                if focused {
                    Button(action: {
                        focused = false
                    }) {
                        HStack {
                            Spacer()
                            Text("DONE")
                                .font(._bodyCopyBold)
                                .foregroundColor(Color.DARK_PURPLE)
                                .padding(5)
                                .background(Color.INPUT_FIELDS)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.5), radius: 2)
                                .padding(2)
                                .padding(.bottom, -10)
                        }
                    }
                }
            }
        }
        .onChange(of: focused) { focus in
            settings.keyboardShown = focus
        }
        .focused($focused)
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
            if self.note.isEmpty {
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
                Button("ADD NOTE") {
                    self.entries.journals.append(JournalModel(createdAt: .now, note: self.note, favorite: false))
                    self.note = ""
                    submitAnimation = true
                    
                    if settings.isActive() && settings.journalsPerWeek != 0 {
                        settings.journalEntered += 1
                    }
                }.buttonStyle(SubmitButton())
                .padding(.top, 10)
            }
        }
    }
    
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
            .environmentObject(Entries())
    }
}
