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
    @State private var showMore = false
    @Binding var deletionTarget: (Date, String)
    var body: some View {
        VStack(alignment: .leading) {
            if !audioRecorder.recordings.isEmpty {
                AudioInterface(date: createdAt)
            }
            
            HStack {
                ShareButtonByDate(date: createdAt)
                StarButton(type: "record", date: createdAt).padding(.horizontal, 7.5)
                Spacer()
                DeleteButton(deletionTarget: $deletionTarget, type: "Voice Recording", date: createdAt)
            }
            
            if showMore {
                infoSection
            } else {
                expandButton
            }
        }
        .padding(8)
        .foregroundColor(Color.white)
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
                self.showMore.toggle()
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
                HStack {
                    Text("Duration:")
                        .font(._bodyCopy)
                    Spacer()
                    Text(result.duration == -1 ? "N/A" : "\(result.duration, specifier: "%.2f")/\(baseline.duration, specifier: "%.2f")")
                        .font(._bodyCopyBold)
                }
                HStack {
                    Text("Intensity:")
                        .font(._bodyCopy)
                    Spacer()
                    Text(result.intensity == -1 ? "N/A" : "\(result.intensity, specifier: "%.2f")/\(baseline.intensity, specifier: "%.2f")")
                        .font(._bodyCopyBold)
                }
                HStack {
                    Text("Maximum Pitch:")
                        .font(._bodyCopy)
                    Spacer()
                    Text(result.pitch_max == -1 ? "N/A" : "\(result.pitch_max, specifier: "%.2f")/\(baseline.pitch_max, specifier: "%.2f")")
                        .font(._bodyCopyBold)
                }
                HStack {
                    Text("Mean Pitch:")
                        .font(._bodyCopy)
                    Spacer()
                    Text(result.pitch_mean == -1 ? "N/A" : "\(result.pitch_mean, specifier: "%.2f")/\(baseline.pitch_mean, specifier: "%.2f")")
                        .font(._bodyCopyBold)
                }
                HStack {
                    Text("Minimum Pitch:")
                        .font(._bodyCopy)
                    Spacer()
                    Text(result.pitch_min == -1 ? "N/A" : "\(result.pitch_min, specifier: "%.2f")/\(baseline.pitch_min, specifier: "%.2f")")
                        .font(._bodyCopyBold)
                }
                HStack {
                    Text("Mean CPP:")
                        .font(._bodyCopy)
                    Spacer()
                    Text(result.pitch_min == -1 ? "N/A" : "\(result.cppMean, specifier: "%.2f")/\(baseline.cppMean, specifier: "%.2f")")
                        .font(._bodyCopyBold)
                }
            }
        }
        .transition(.slideDown)
    }
    
    private var expandButton: some View {
        Button(action: {
            withAnimation() {
                self.showMore.toggle()
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
        ExpandedRecording(createdAt: .now, deletionTarget: .constant((.now, "vowel")))
    }
}
