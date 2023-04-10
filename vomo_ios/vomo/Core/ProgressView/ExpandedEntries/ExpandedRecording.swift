//
//  ExpandedRecording.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

struct ExpandedRecording: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    let svm = SharedViewModel()
    let createdAt: Date
    @Binding var deletionTarget: (Date, String)
    @Binding var showRecordDetails: Bool
    //let defaultExpansion: Bool
    /// either Vowel, Duration or Rainbow
    let recordType: String
    var body: some View {
        VStack(alignment: .leading) {
            if !audioRecorder.recordings.isEmpty {
                AudioInterface(date: createdAt)
            }
            
            HStack {
                StarButton(type: "record", date: createdAt)
                ShareButtonByDate(date: createdAt).padding(.horizontal, 7.5)
                Spacer()
                DeleteButton(deletionTarget: $deletionTarget, type: "Voice Recording", date: createdAt)
            }
            
            if showRecordDetails {
                infoSection
            } else {
                expandButton
            }
        }
        .padding(8)
        .foregroundColor(Color.white)
        .onAppear() {
            //self.showRecordDetails = defaultExpansion
        }
    }
    
    var result: ProcessedData {
        return audioRecorder.returnProcessing(createdAt: createdAt)
    }
    
    var baseline: ProcessedData {
        return audioRecorder.baseLine()
    }
}

extension ExpandedRecording {
    private var infoSection: some View {
        Button(action: {
            withAnimation() {
                self.showRecordDetails.toggle()
            }
        }) {
            VStack {
                HStack {
                    Text("Metric")
                        .font(._bodyCopy)
                    Spacer()
                    Text("Score/Baseline")
                        .font(._bodyCopy)
                }
                .padding(.top, 2.5)
                Color.white.frame(height: 1)
                    .padding(.vertical, -2.5)
                
                if recordType == "Duration" {
                    HStack {
                        Text("Duration (seconds):")
                            .font(._bodyCopy)
                        Spacer()
                        Text(result.duration == -1 ? "N/A" : "\(result.duration, specifier: "%.2f")/\(baseline.duration, specifier: "%.2f")")
                            .font(._bodyCopyBold)
                    }
                } else {
                    HStack {
                        Text("Mean Pitch (hertz):")
                            .font(._bodyCopy)
                        Spacer()
                        Text(result.pitch_mean == -1 ? "N/A" : "\(result.pitch_mean, specifier: "%.2f")/\(baseline.pitch_mean, specifier: "%.2f")")
                            .font(._bodyCopyBold)
                    }
                    HStack {
                        Text("Mean CPP (db):")
                            .font(._bodyCopy)
                        Spacer()
                        Text(result.pitch_min == -1 ? "N/A" : "\(result.cppMean, specifier: "%.2f")/\(baseline.cppMean, specifier: "%.2f")")
                            .font(._bodyCopyBold)
                    }
                }
            }
        }
        .transition(.slideDown)
    }
    
    private var expandButton: some View {
        Button(action: {
            withAnimation() {
                self.showRecordDetails.toggle()
            }
        }) {
            Text("Show more details")
                .font(._bodyCopyBold)
        }
        .transition(.opacity)
    }
}

struct ExpandedRecording_Previews: PreviewProvider {
    static var previews: some View {
        ExpandedRecording(createdAt: .now, deletionTarget: .constant((.now, "vowel")), showRecordDetails: .constant(false), recordType: "Hello")
    }
}
