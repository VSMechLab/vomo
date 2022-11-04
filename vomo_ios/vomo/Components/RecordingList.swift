//
//  RecordingList.swift
//  VoMo
//
//  Created by Neil McGrogan on 10/29/22.
//

import SwiftUI

struct RecordingList: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    let svm = SharedViewModel()
    let createdAt: Date
    @Binding var reset: Bool
    var body: some View {
        VStack(alignment: .leading) {
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
            
            ZStack {
                HStack {
                    Spacer()
                    PlayButtonByDate(date: createdAt)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    StarButton(type: "record", date: createdAt)
                    DeleteRecording(date: createdAt, reset: $reset)
                    ShareButtonByDate(date: createdAt)
                }
            }
            
        }
        .padding(8)
        .foregroundColor(Color.white)
    }
    
    var result: ProcessedData {
        return audioRecorder.returnProcessing(createdAt: createdAt)
    }
}
