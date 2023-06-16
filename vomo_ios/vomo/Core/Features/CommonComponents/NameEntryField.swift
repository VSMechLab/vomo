//
//  TextEntryField.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI

struct NameEntryField: View {
    @Binding var topic: String
    @EnvironmentObject var settings: Settings
    @FocusState private var focused: Bool
    let label: String
    let svm = SharedViewModel()
    
    let type: UITextContentType
    
    var body: some View {
        ZStack {
            EntryField()
            
            TextField(self.topic.isEmpty ? label : self.topic, text: $topic)
                .font(self.topic.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                .padding(.horizontal, svm.fieldPadding)
                .focused($focused)
                .textContentType(type)
        }
        .onChange(of: focused) { focus in
            settings.keyboardShown = focus
        }
    }
}
