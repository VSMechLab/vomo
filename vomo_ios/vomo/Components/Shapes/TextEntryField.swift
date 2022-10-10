//
//  TextEntryField.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI

struct TextEntryField: View {
    @Binding var topic: String
    @EnvironmentObject var settings: Settings
    @FocusState private var focused: Bool
    let svm = SharedViewModel()
    var body: some View {
        ZStack {
            EntryField()
            
            TextField(self.topic.isEmpty ? "First Name" : self.topic, text: $topic)
                .font(self.topic.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                .padding(.horizontal, svm.fieldPadding)
                .focused($focused)
        }
        .onChange(of: focused) { focus in
            settings.keyboardShown = focus
        }
    }
}
