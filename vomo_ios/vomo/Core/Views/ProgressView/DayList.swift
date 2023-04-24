//
//  DayList.swift
//  VoMo
//
//  Created by Neil McGrogan on 10/27/22.
//

import SwiftUI
import AVFAudio

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
    @Binding var showRecordDetails: Bool
    
    @Binding var audioPlayer: AVAudioPlayer!
    
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
            .foregroundColor(Color.white)
            .padding(.vertical, 4)
            .background(Color.DARK_PURPLE)
            
            if showMore {
                VStack(spacing: 0) {
                    ForEach(0..<element.str.count, id: \.self) { index in
                        EntryRow(expand: expand, index: (element.str.count-1-index), element: element, isExpandedList: isExpandedList, deletionTarget: $deletionTarget, showRecordDetails: $showRecordDetails, audioPlayer: $audioPlayer)
                        Color.BRIGHT_PURPLE.frame(height: 2.5).opacity(0.6)
                    }
                }
            }
        }
        .foregroundColor(Color.BODY_COPY)
        .background(showMore ? Color.INPUT_FIELDS : Color.white)
        .onAppear() {
            if isExpandedList {
                self.showMore = true
            }
        }
    }
}
