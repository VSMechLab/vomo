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
    
    let banner_img = "VM_FPO-12-free-write-banner-img"
    
    let tag_img = "VM_12-tags-entry-field"
    let field_img = "VM_12-entry-field"
    
    let button_img = "VM_Gradient-Btn"
    
    let content_width: CGFloat = 317.5
    
    @State private var name = ""
    @State private var note = ""
    
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
            
            Image(banner_img)
                .resizable()
                .frame(height: 170)
            
            VStack(spacing: 0) {
                ZStack {
                    Image(field_img)
                        .resizable()
                        .frame(height: 30)
                    
                    TextField(self.name.isEmpty ? "Enter Note Name" : self.name, text: self.$name)
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
                        .font(._fieldCopyRegular)
                        .padding(.leading, 5)
                }
                .frame(height: 175)
                .padding(.top, 5)
            }
            
            Button("") {
                self.entries.journals.append(JournalModel(createdAt: .now, noteName:  self.name, note: self.note))
            }
            .buttonStyle(SubmissionButton(label: "ADD NOTE"))
            .padding(.top, 10)
        }.frame(width: content_width)
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}
