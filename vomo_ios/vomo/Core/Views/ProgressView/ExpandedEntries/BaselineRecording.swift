//
//  BaselineRecording.swift
//  VoMo
//
//  Created by Neil McGrogan on 2/27/23.
//

import SwiftUI

struct BaselineRecording: View {
    @ObservedObject var settings = Settings.shared
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Binding var deletionTarget: (Date, String)
    let showing: Int
    
    @State private var showMoreVowel = true
    @State private var showMoreDuration = true
    @State private var showMoreRainbow = true
    
    let svm = SharedViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            if showing == 0 || showing == 1 {
                if !baselineDate.1 {
                    Button(action: {
                        viewRouter.currentPage = .record
                        settings.hyperLinkedRecording = 0
                        // To do, hyperlink to propper task
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                
                            Text("Create Baseline Vowel Recording")
                                .underline()
                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
                } else {
                    vowelSection
                }
            }
            
            if showing == 0 || showing == 2 {
                if !baselineDate.3 {
                    Button(action: {
                        viewRouter.currentPage = .record
                        settings.hyperLinkedRecording = 1
                        // To do, hyperlink to propper task
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                
                            Text("Create Baseline Maximum Duration Recording")
                                .underline()
                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
                } else {
                    durationSection
                }
            }
            
            if showing == 0 || showing == 3 {
                if !baselineDate.5 {
                    Button(action: {
                        viewRouter.currentPage = .record
                        settings.hyperLinkedRecording = 2
                        // To do, hyperlink to propper task
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                
                            Text("Create Baseline Rainbow Recording")
                                .underline()
                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
                } else {
                    rainbowSection
                }
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
        .background(Color.MEDIUM_PURPLE)
    }
    
    var result: (MetricsModel, MetricsModel, MetricsModel) {
        var ret: (MetricsModel, MetricsModel, MetricsModel) = (MetricsModel(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false), MetricsModel(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false), MetricsModel(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false))
        
        ret.0 = audioRecorder.returnProcessing(createdAt: baselineDate.0)
        ret.1 = audioRecorder.returnProcessing(createdAt: baselineDate.2)
        ret.2 = audioRecorder.returnProcessing(createdAt: baselineDate.4)
        
        return ret
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
            
            Group {
                HStack {
                    Text("Mean Pitch (Hertz):")
                        .font(._bodyCopy)
                    Spacer()
                    Text(result.0.pitch_mean == -1 ? "N/A" : "\(result.0.pitch_mean, specifier: "%.0f")")
                        .font(._bodyCopy)
                }
                HStack {
                    Text("Mean CPP (dB):")
                        .font(._bodyCopy)
                    Spacer()
                    Text(result.0.pitch_min == -1 ? "N/A" : "\(result.0.cppMean, specifier: "%.1f")")
                        .font(._bodyCopy)
                }
            }
            .padding(.horizontal, 95)
            
            
            ZStack {
                HStack {
                    ShareButtonByDate(date: result.0.createdAt)
                    Spacer()
                    DeleteButton(deletionTarget: $deletionTarget, type: "Vowel", date: result.0.createdAt)
                }
                .padding(.horizontal, 5)
                
                AudioInterface(date: baselineDate.0)
                    .scaleEffect(0.7)
                    .padding(.vertical, -7.5)
            }
        }
        .transition(.slideDown)
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Maximum Duration Baseline **\(result.1.createdAt.weekAndDay())**")
            
            Group {
                HStack {
                    Text("Time (seconds):")
                        .font(._bodyCopy)
                    Spacer()
                    Text(result.1.duration == -1 ? "N/A" : "\(result.1.duration, specifier: "%.1f")")
                        .font(._bodyCopy)
                }
            }
            .padding(.horizontal, 95)
            
            
            ZStack {
                HStack {
                    ShareButtonByDate(date: result.1.createdAt)
                    Spacer()
                    DeleteButton(deletionTarget: $deletionTarget, type: "Duration", date: result.1.createdAt)
                }
                .padding(.horizontal, 5)
                
                AudioInterface(date: baselineDate.2)
                    .scaleEffect(0.7)
                    .padding(.vertical, -7.5)
            }
        }
        .transition(.slideDown)
    }
    
    private var rainbowSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Sentences Baseline **\(result.2.createdAt.weekAndDay())**")
            
            
            VStack {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Mean Pitch (Hertz):")
                        Text("Mean CPP (dB):")
                    }
                    .font(._bodyCopy)
                    .frame(width: 1.20 * svm.content_width / 3)
                    
                    VStack(alignment: .trailing) {
                        Text(result.2.pitch_mean == -1 ? "N/A" : "\(result.2.pitch_mean, specifier: "%.0f")")
                        Text(result.2.cppMean == -1 ? "N/A" : "\(result.2.cppMean, specifier: "%.1f")")
                    }
                    .font(._bodyCopyBold)
                    .frame(width: 0.70 * svm.content_width / 3)
                    
                    VStack(alignment: .trailing) {
                        Color.clear
                    }
                    .font(._bodyCopyMedium)
                    .frame(width: 0.70 * svm.content_width / 3)
                }
            }
            
            ZStack {
                HStack {
                    ShareButtonByDate(date: result.2.createdAt)
                    Spacer()
                    DeleteButton(deletionTarget: $deletionTarget, type: "Rainbow", date: result.2.createdAt)
                }
                .padding(.horizontal, 5)
                
                AudioInterface(date: baselineDate.4)
                    .scaleEffect(0.7)
                    .padding(.vertical, -7.5)
            }
        }
        .transition(.slideDown)
    }
}
