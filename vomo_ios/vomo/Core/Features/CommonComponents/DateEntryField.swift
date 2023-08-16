//
//  DateEntryField.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI

struct DateEntryField: View {
    @Binding var toggle: Bool
    @Binding var date: Date
    let svm = SharedViewModel()
    var body: some View {
        ZStack {
            EntryField()
            Button(action: {
                withAnimation() {
                    self.toggle.toggle()
                }
            }) {
                HStack {
                    Text("\(self.date.formatted(date: .numeric, time: .omitted))")
                        .font(._bodyCopy)
                    Spacer()
                    Arrow()
                        .rotationEffect(Angle(degrees: toggle ? 90 : 0))
                }
                .padding(.horizontal, svm.fieldPadding)
            }
        }
    }
}

struct DateEntryField_Previews: PreviewProvider {
    static var previews: some View {
        DateEntryField(toggle: .constant(true), date: .constant(.init()))
    }
}
