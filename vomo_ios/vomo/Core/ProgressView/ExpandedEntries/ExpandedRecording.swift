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
            if showMore {
                infoSection
            } else {
                expandButton
            }
            
            if !audioRecorder.recordings.isEmpty {
                AudioInterface(date: audioRecorder.recordings.last?.createdAt ?? .now)
            }
            
            HStack {
                Spacer()
                ShareButtonByDate(date: createdAt)
                StarButton(type: "record", date: createdAt).padding(.horizontal, 7.5)
                DeleteButton(deletionTarget: $deletionTarget, type: "Voice Recording", date: createdAt)
            }
        }
        .padding(8)
        .foregroundColor(Color.white)
    }
    
    var result: ProcessedData {
        return audioRecorder.returnProcessing(createdAt: createdAt)
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
                    Text("Duration:")
                        .font(._bodyCopy)
                    Spacer()
                    Text("\(result.duration, specifier: "%.2f")")
                        .font(._bodyCopyBold)
                }
                HStack {
                    Text("Intensity:")
                        .font(._bodyCopy)
                    Spacer()
                    Text("\(result.intensity, specifier: "%.2f")")
                        .font(._bodyCopyBold)
                }
                HStack {
                    Text("Mean Pitch:")
                        .font(._bodyCopy)
                    Spacer()
                    Text("\(result.pitch_mean, specifier: "%.2f")")
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
