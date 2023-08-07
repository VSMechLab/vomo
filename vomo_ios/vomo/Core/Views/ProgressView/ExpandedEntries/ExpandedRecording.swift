//
//  ExpandedRecording.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

struct ExpandedRecording: View {
    @ObservedObject var audioRecorder = AudioRecorder.shared
    let svm = SharedViewModel()
    let createdAt: Date
    @Binding var deletionTarget: (Date, String)
    @Binding var showRecordDetails: Bool
    //let defaultExpansion: Bool
    /// either Vowel, Duration or Rainbow
    let recordType: String
    
    /// 1 = vowel
    /// 2 = mpt
    /// 3 = rainbow
    @State private var type = ""
    @State private var baseline: MetricsModel = MetricsModel(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack {
                Text("Mean Pitch (Hertz):")
                    .font(._bodyCopy)
                Spacer()
                Text(result.pitch_mean == -1 ? "N/A" : "\(result.pitch_mean, specifier: "%.0f")/\(baseline.pitch_mean, specifier: "%.0f")")
                    .font(._bodyCopyBold)
            }
            HStack {
                Text("Duration (seconds):")
                    .font(._bodyCopy)
                Spacer()
                Text(result.duration == -1 ? "N/A" : "\(result.duration, specifier: "%.1f")/\(baseline.duration, specifier: "%.1f")")
                    .font(._bodyCopyBold)
            }
            HStack {
                Text("Mean CPP (dB):")
                    .font(._bodyCopy)
                Spacer()
                Text(result.cppMean == -1 ? "N/A" : "\(result.cppMean, specifier: "%.1f")/\(baseline.cppMean, specifier: "%.1f")")
                    .font(._bodyCopyBold)
            }
            
            AudioInterface(date: createdAt)
                .scaleEffect(0.7)
                .padding(.vertical, -10)
            
            HStack {
                StarButton(type: "record", date: createdAt)
                ShareButtonByDate(date: createdAt).padding(.horizontal, 7.5)
                Spacer()
                DeleteButton(deletionTarget: $deletionTarget, type: "Voice Recording", date: createdAt)
            }
            .padding(.horizontal, 5)
            
        }
        .foregroundColor(Color.white)
        .padding(8)
        .transition(.slideDown)
        .onAppear() {
            type = audioRecorder.taskNum(file: audioRecorder.returnFileURL(createdAt: createdAt))
            
            switch type {
            case "Vowel":
                baseline = audioRecorder.baselineVowel()
            case "MPT":
                baseline = audioRecorder.baselineDuration()
            case "Rainbow":
                baseline = audioRecorder.baselineRainbow()
            default:
                baseline = audioRecorder.baselineRainbow()
            }
        }
        /*
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
        }
        .padding(8)
        .foregroundColor(Color.white)*/
    }
    
    var result: MetricsModel {
        
        
        return audioRecorder.returnProcessing(createdAt: createdAt)
    }
}

/*
 
 {
     VStack(alignment: .leading, spacing: 1) {
         Text("Vowel Baseline **\(result.0.createdAt.weekAndDay())**")
         
         HStack {
             Text("Mean Pitch (Hertz):")
                 .font(._bodyCopy)
             Spacer()
             Text(result.0.pitch_mean == -1 ? "N/A" : "\(result.0.pitch_mean, specifier: "%.0f")")
                 .font(._bodyCopyBold)
         }
         HStack {
             Text("Mean CPP (dB):")
                 .font(._bodyCopy)
             Spacer()
             Text(result.0.pitch_min == -1 ? "N/A" : "\(result.0.cppMean, specifier: "%.1f")")
                 .font(._bodyCopyBold)
         }
         
         ZStack {
             HStack {
                 DeleteButton(deletionTarget: $deletionTarget, type: "Vowel", date: result.0.createdAt)
                 Spacer()
                 ShareButtonByDate(date: result.2.createdAt)
             }
             .padding(.horizontal, 5)
             
             AudioInterface(date: baselineDate.0)
                 .scaleEffect(0.7)
                 .padding(.vertical, -7.5)
         }
     }
     .transition(.slideDown)
 }
 */

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
                        Text(result.duration == -1 ? "N/A" : "\(result.duration, specifier: "%.1f")/\(audioRecorder.baselineDuration().duration, specifier: "%.1f")")
                            .font(._bodyCopyBold)
                    }
                } else {
                    HStack {
                        Text("Mean Pitch (Hertz):")
                            .font(._bodyCopy)
                        Spacer()
                        Text(result.pitch_mean == -1 ? "N/A" : "\(result.pitch_mean, specifier: "%.0f")/\(audioRecorder.baselineRainbow().pitch_mean, specifier: "%.0f")")
                            .font(._bodyCopyBold)
                    }
                    HStack {
                        Text("Mean CPP (dB):")
                            .font(._bodyCopy)
                        Spacer()
                        Text(result.pitch_min == -1 ? "N/A" : "\(result.cppMean, specifier: "%.1f")/\(audioRecorder.baselineRainbow().cppMean, specifier: "%.1f")")
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
