//
//  BaselineRecording.swift
//  VoMo
//
//  Created by Neil McGrogan on 2/27/23.
//

import SwiftUI

struct BaselineRecording: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Binding var deletionTarget: (Date, String)
    
    @State private var showMoreVowel = true
    @State private var showMoreDuration = true
    @State private var showMoreRainbow = true
    
    let svm = SharedViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            if !baselineDate.1 {
                Button(action: {
                    viewRouter.currentPage = .record
                    // To do, hyperlink to propper task
                }) {
                    Text("Create Baseline Vowel Recording")
                        .underline()
                }
            } else {
                vowelSection
            }
            
            Color.white.frame(height: 1.5)
                .padding(.vertical, -5)
            
            if !baselineDate.3 {
                Text("Create Baseline Maximum Duration Recording")
                    .underline()
            } else {
                durationSection
            }
            
            Color.white.frame(height: 1.5)
                .padding(.vertical, -5)
            
            if !baselineDate.5 {
                Text("Create Baseline Rainbow Recording")
                    .underline()
            } else {
                rainbowSection
            }
            
            HStack {
                Spacer()
                
                Spacer()
            }
            
            /*
            if !audioRecorder.recordings.isEmpty {
                AudioInterface(date: createdAt)
            }
            
            HStack {
                ShareButtonByDate(date: createdAt)
                Spacer()
            }
            
            if showMore {
                infoSection
            } else {
                expandButton
            }
             */
            
            
        }
        .font(._bodyCopyBold)
        .padding(8)
        .foregroundColor(Color.white)
        .frame(width: svm.content_width)
        .background(Color.MEDIUM_PURPLE)
    }
    
    var result: (ProcessedData, ProcessedData, ProcessedData) {
        var ret: (ProcessedData, ProcessedData, ProcessedData) = (ProcessedData(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false), ProcessedData(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false), ProcessedData(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false))
        
        ret.0 = audioRecorder.returnProcessing(createdAt: baselineDate.0)
        ret.1 = audioRecorder.returnProcessing(createdAt: baselineDate.2)
        ret.2 = audioRecorder.returnProcessing(createdAt: baselineDate.4)
        
        return ret
    }
    
    var baseline: ProcessedData {
        return audioRecorder.baseLine()
    }
    
    var baselineDate: (Date, Bool, Date, Bool, Date, Bool) {
        var ret: (Date, Bool, Date, Bool, Date, Bool) = (.now, false, .now, false, .now, false)
        for record in audioRecorder.recordings {
            if audioRecorder.fileTask(file: record.fileURL) == "1" && !ret.1 {
                ret.0 = record.createdAt
                ret.1 = true
            } else if audioRecorder.fileTask(file: record.fileURL) == "2" && !ret.3 {
                ret.2 = record.createdAt
                ret.3 = true
            } else if audioRecorder.fileTask(file: record.fileURL) == "3" && !ret.5 {
                ret.4 = record.createdAt
                ret.5 = true
            }
        }
        return ret
    }
}

extension BaselineRecording {
    private var vowelSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Vowel Baseline **\(result.0.createdAt.weekAndDay())**")
            
            HStack {
                Text("Mean Pitch:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.0.pitch_mean == -1 ? "N/A" : "\(result.0.pitch_mean, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
            HStack {
                Text("Mean CPP:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.0.pitch_min == -1 ? "N/A" : "\(result.0.cppMean, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
            
            ZStack {
                HStack {
                    DeleteButton(deletionTarget: $deletionTarget, type: "Vowel", date: result.0.createdAt)
                    Spacer()
                }
                .padding(.leading, 5)
                
                AudioInterface(date: baselineDate.0)
                    .scaleEffect(0.7)
                    .padding(.vertical, -7.5)
            }
        }
        .transition(.slideDown)
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Duration Baseline **\(result.1.createdAt.weekAndDay())**")
            
            HStack {
                Text("Duration:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.1.duration == -1 ? "N/A" : "\(result.1.duration, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
            
            ZStack {
                HStack {
                    DeleteButton(deletionTarget: $deletionTarget, type: "Duration", date: result.1.createdAt)
                    Spacer()
                }
                .padding(.leading, 5)
                
                AudioInterface(date: baselineDate.2)
                    .scaleEffect(0.7)
                    .padding(.vertical, -7.5)
            }
        }
        .transition(.slideDown)
    }
    
    private var rainbowSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Rainbow Baseline **\(result.2.createdAt.weekAndDay())**")
            
            HStack {
                Text("Mean Pitch:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.2.pitch_mean == -1 ? "N/A" : "\(result.2.pitch_mean, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
            HStack {
                Text("Mean CPP:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.2.pitch_min == -1 ? "N/A" : "\(result.2.cppMean, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
            
            ZStack {
                HStack {
                    DeleteButton(deletionTarget: $deletionTarget, type: "Rainbow", date: result.2.createdAt)
                    Spacer()
                }
                .padding(.leading, 5)
                
                AudioInterface(date: baselineDate.4)
                    .scaleEffect(0.7)
                    .padding(.vertical, -7.5)
            }
        }
        .transition(.slideDown)
    }
}

/*private var infoSection: some View {
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
                Text("Baseline")
                    .font(._bodyCopy)
            }
            .padding(.top, 2.5)
            Color.white.frame(height: 1)
                .padding(.vertical, -2.5)
            HStack {
                Text("Duration:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.duration == -1 ? "N/A" : "\(result.duration, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
            HStack {
                Text("Intensity:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.intensity == -1 ? "N/A" : "\(result.intensity, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
            HStack {
                Text("Maximum Pitch:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.pitch_max == -1 ? "N/A" : "\(result.pitch_max, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
            HStack {
                Text("Mean Pitch:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.pitch_mean == -1 ? "N/A" : "\(result.pitch_mean, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
            HStack {
                Text("Minimum Pitch:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.pitch_min == -1 ? "N/A" : "\(result.pitch_min, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
            HStack {
                Text("Mean CPP:")
                    .font(._bodyCopy)
                Spacer()
                Text(result.pitch_min == -1 ? "N/A" : "\(result.cppMean, specifier: "%.2f")")
                    .font(._bodyCopyBold)
            }
        }
    }
    .transition(.slideDown)
}*/
