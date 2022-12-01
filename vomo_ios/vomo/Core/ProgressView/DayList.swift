//
//  DayList.swift
//  VoMo
//
//  Created by Neil McGrogan on 10/27/22.
//

import SwiftUI

/// Complex view that is able to be initialized with a 'expandedList' variable that is taken in
/// this inititalizes how the view should appear and if stuff should be expanded at first or not
struct DayList: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var showMore = false
    let element: Element
    var expand = false
    let svm = SharedViewModel()
    let isExpandedList: Bool
    @Binding var deletionTarget: (Date, String)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation() {
                    self.showMore.toggle()
                }
            }) {
                HStack(spacing: 0) {
                    Text("\(element.date.dayOfWeek())  ")
                        .font(._bodyCopyLargeBold)
                    Text(element.date.toDay())
                        .font(._bodyCopyLargeMedium)
                    Spacer()
                    SmallArrow()
                        .rotationEffect(Angle(degrees: showMore ? 90 : 0))
                        .padding(.trailing, 5.5)
                }
            }
            .padding(.bottom, 4)
            
            if showMore {
                VStack(spacing: 0) {
                    ForEach(0..<element.str.count) { index in
                        Color.BODY_COPY.frame(height: 1).opacity(0.6)
                        EntryRow(expand: expand, index: index, element: element, isExpandedList: isExpandedList, deletionTarget: $deletionTarget)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .foregroundColor(Color.BODY_COPY)
        .background(showMore ? Color.INPUT_FIELDS : Color.white)
        .onAppear() {
            if isExpandedList {
                self.showMore = true
            }
        }
    }
}
