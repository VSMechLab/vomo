//
//  TextEntryField.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI

struct TextEntryField: View {
    @Binding var topic: String
    let svm = SharedViewModel()
    var body: some View {
        ZStack {
            EntryField()
            
            TextField(self.topic.isEmpty ? "First Name" : self.topic, text: $topic)
                .font(self.topic.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                .padding(.horizontal, svm.fieldPadding)
        }
    }
}
