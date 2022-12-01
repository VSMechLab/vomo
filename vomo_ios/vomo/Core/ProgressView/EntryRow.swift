//
//  EntryRow.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// Stores types of information when you expand upon a day under the progress view
struct EntryRow: View {
    var expand: Bool
    let index: Int
    let element: Element
    let svm = SharedViewModel()
    
    @State private var expandEntryItem: Bool = false
    @State private var color: Color = .clear
    
    let isExpandedList: Bool
    @Binding var deletionTarget: (Date, String)
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation() { expandEntryItem.toggle() }
            }) {
                HStack {
                    Text("\(element.str[index]) | \(element.preciseDate[index].toStringHour())")
                        .font(._bodyCopyMedium)
                        .foregroundColor(expandEntryItem ? Color.white : Color.BODY_COPY)
                    Spacer()
                    SmallerArrow()
                        .rotationEffect(Angle(degrees: expandEntryItem ? 90 : 0))
                        .padding(.trailing, 5.5)
                }
                .padding(4)
            }
            
            if expandEntryItem {
                if element.str[index] == "Vowel" || element.str[index] == "Duration" || element.str[index] == "Rainbow" {
                    ExpandedRecording(createdAt: element.preciseDate[index], deletionTarget: $deletionTarget)
                        .onAppear() { color = .MEDIUM_PURPLE }
                } else if element.str[index] == "Survey" {
                    ExpandedSurvey(createdAt: element.preciseDate[index], deletionTarget: $deletionTarget)
                        .onAppear() { color = .TEAL }
                } else if element.str[index] == "Journal" {
                    ExpandedJournal(createdAt: element.preciseDate[index], deletionTarget: $deletionTarget)
                        .onAppear() { color = .BLUE }
                }
            }
        }
        .onChange(of: expandEntryItem) { _ in
            if color == .MEDIUM_PURPLE || color == .TEAL || color == .BLUE {
                color = .clear
            }
        }
        .padding(.leading, 6)
        .padding(.vertical, 5)
        .foregroundColor(Color.BODY_COPY)
        .background(color)
        .onAppear() {
            if isExpandedList {
                self.expandEntryItem = true
            }
        }
    }
}
/*
struct EntryRow_Previews: PreviewProvider {
    static var previews: some View {
        EntryRow(expand: false, index: 1, element: Element(date: .now, preciseDate: [.now], str: [""])), reset: .constant(false, isExpandedList: false)
    }
}
*/
