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
    @ObservedObject var audioRecorder = AudioRecorder.shared
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
            .padding(.vertical, 7.5)
            .foregroundColor(Color.HEADLINE_COPY)
            .background(Color.INPUT_FIELDS)
            
            if showMore {
                VStack(spacing: 0) {
                    recordSection
                    
                    ForEach(0..<element.str.count, id: \.self) { index in
                        if element.str[(element.str.count-1-index)] == "Survey" {
                            EntryRow(expand: expand, index: (element.str.count-1-index), element: element, isExpandedList: isExpandedList, deletionTarget: $deletionTarget, showRecordDetails: $showRecordDetails, audioPlayer: $audioPlayer)
                            Color.BRIGHT_PURPLE.frame(height: 1).opacity(0.9)
                        }
                    }
                    .background(isExpandedList ? Color.clear : Color.TEAL)
                    
                    
                    ForEach(0..<element.str.count, id: \.self) { index in
                        if element.str[(element.str.count-1-index)] == "Journal" {
                            EntryRow(expand: expand, index: (element.str.count-1-index), element: element, isExpandedList: isExpandedList, deletionTarget: $deletionTarget, showRecordDetails: $showRecordDetails, audioPlayer: $audioPlayer)
                            Color.BRIGHT_PURPLE.frame(height: 1).opacity(0.9)
                        }
                    }
                    .background(isExpandedList ? Color.clear : Color.BLUE)
                }
            }
        }
        .foregroundColor(Color.white)
        .background(showMore ? Color.INPUT_FIELDS.opacity(0.5) : Color.white)
        .onAppear() {
            if isExpandedList {
                self.showMore = true
            }
        }
    }
    
    private var recordSection: some View {
        VStack(spacing: 0) {
            ForEach(0..<element.str.count, id: \.self) { index in
                if element.str[(element.str.count-1-index)] == "Vowel"  {
                    EntryRow(expand: expand, index: (element.str.count-1-index), element: element, isExpandedList: isExpandedList, deletionTarget: $deletionTarget, showRecordDetails: $showRecordDetails, audioPlayer: $audioPlayer)
                    Color.white.frame(height: 1).opacity(0.9)
                }
            }
            .background(isExpandedList ? Color.clear : Color.MEDIUM_PURPLE)
            
            ForEach(0..<element.str.count, id: \.self) { index in
                if element.str[(element.str.count-1-index)] == "Duration" {
                    EntryRow(expand: expand, index: (element.str.count-1-index), element: element, isExpandedList: isExpandedList, deletionTarget: $deletionTarget, showRecordDetails: $showRecordDetails, audioPlayer: $audioPlayer)
                    Color.white.frame(height: 1).opacity(0.9)
                }
            }
            .background(isExpandedList ? Color.clear : Color.MEDIUM_PURPLE)
            
            ForEach(0..<element.str.count, id: \.self) { index in
                if element.str[(element.str.count-1-index)] == "Rainbow" {
                    EntryRow(expand: expand, index: (element.str.count-1-index), element: element, isExpandedList: isExpandedList, deletionTarget: $deletionTarget, showRecordDetails: $showRecordDetails, audioPlayer: $audioPlayer)
                    Color.white.frame(height: 1).opacity(0.9)
                }
            }
            .background(isExpandedList ? Color.clear : Color.MEDIUM_PURPLE)
        }
    }
}
