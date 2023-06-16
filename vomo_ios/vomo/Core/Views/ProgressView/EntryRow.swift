//
//  EntryRow.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI
//import AVKit
import Foundation
import SwiftUI
import Combine
import AVFoundation

/// Stores types of information when you expand upon a day under the progress view
struct EntryRow: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var entries: Entries
    var expand: Bool
    let index: Int
    let element: Element
    let svm = SharedViewModel()
    
    @State private var expandEntryItem: Bool = false
    @State private var color: Color = .clear
    
    let isExpandedList: Bool
    @Binding var deletionTarget: (Date, String)
    @Binding var showRecordDetails: Bool
    
    @Binding var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation() { expandEntryItem.toggle() }
            }) {
                HStack {
                    Text("**\(element.str[index])** | \(element.preciseDate[index].toStringHour())")
                        .font(._bodyCopyUnBold)
                    Spacer()
                    if !expandEntryItem && !audioRecorder.recordings.isEmpty && (element.str[index] == "Vowel" || element.str[index] == "Duration" || element.str[index] == "Rainbow") {
                        MiniAudioInterface(audioPlayer: $audioPlayer, date: element.preciseDate[index])
                            .padding(.trailing, 10)
                    } else if !expandEntryItem && !audioRecorder.recordings.isEmpty && element.str[index] == "Survey" {
                        quickSurveyResults()
                            .font(._fieldCopyMedium)
                            .padding(.trailing, 10)
                    }
                    
                    SmallerArrow()
                        .rotationEffect(Angle(degrees: expandEntryItem ? 90 : 0))
                        .padding(.trailing, 5.5)
                }
                .padding(1)
            }
            
            if expandEntryItem {
                if element.str[index] == "Vowel" || element.str[index] == "Duration" || element.str[index] == "Rainbow" {
                    ExpandedRecording(createdAt: element.preciseDate[index], deletionTarget: $deletionTarget, showRecordDetails: $showRecordDetails, recordType: element.str[index])
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
        .padding(.horizontal, 2.5)
        .padding(.leading, 6)
        .padding(.vertical, 5)
        .foregroundColor(Color.white)
        .background(color)
        .onAppear() {
            if isExpandedList {
                self.expandEntryItem = true
            }
        }
    }
    
    func quickSurveyResults() -> Text {
        let time = element.preciseDate[index]
        
        /*
         /// This is the score for all of the following items
         /// .0 is vhi,
         /// .1 is vocal effort - Physical Effort X%
         /// .2 is vocal effort - Mental Effort X%
         /// .3 is current percent of vocal function
         */
        for survey in entries.questionnaires {
            if time == survey.createdAt {
                if survey.score.0 != -1 {
                    return Text("VHI-10: **\(survey.score.0, specifier: "%.0f")**")
                } else if survey.score.1 != -1 || survey.score.2 != -1 {
                    return Text("Effort: **\(survey.score.1, specifier: "%.0f")**% (P) / **\(survey.score.2, specifier: "%.0f")**% (M)")
                } else if survey.score.3 != -1 {
                    return Text("Vocal Function: **\(survey.score.3, specifier: "%.0f")**%")
                }
            }
        }
        
        return Text("")
    }
}
/*
struct EntryRow_Previews: PreviewProvider {
    static var previews: some View {
        EntryRow(expand: false, index: 1, element: Element(date: .now, preciseDate: [.now], str: [""])), reset: .constant(false, isExpandedList: false)
    }
}
*/
