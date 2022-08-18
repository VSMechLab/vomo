//
//  CompleteMenu.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/12/22.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

struct CompleteMenu: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var recordingState: RecordState
    @EnvironmentObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @EnvironmentObject var goal: Goal
    
    @Binding var playLast: Bool
    @Binding var promptSelect: Int
    @Binding var timer: Int
    
    let stop_play_img = "VM_stop_play-btn"
    let approved_img = "VM_appr-btn"
    let play_img = "VM_play-btn"
    let retry_img = "VM_retry-btn"
    
    var body: some View {
        VStack(spacing: 0) {
            Color.white.opacity(0.1)
            
            HStack(spacing: 0) {
                Color.white.opacity(0.1)
                
                ZStack {
                    Color.white.frame(width: 275, height: 150).opacity(0.95).shadow(color: Color.black.opacity(0.2), radius: 5)
                    
                    VStack {
                        Text("Recording Complete!")
                            .font(._coverBodyCopy)
                        
                        if playLast {
                            if audioPlayer.isPlaying == false {
                                Button(action: {
                                    self.audioPlayer.startPlayback(audio: retreiveLastRecording())
                                }) {
                                    Image(systemName: "play.circle")
                                        .imageScale(.large)
                                }
                            } else {
                                Button(action: {
                                    self.audioPlayer.stopPlayback()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .imageScale(.large)
                                }
                            }
                        }
                        
                        HStack {
                            play
                            
                            approved
                            
                            tryAgain
                        }
                    }.frame(width: 275, height: 150)
                }
                
                Color.white.opacity(0.1)
            }
            
            Color.white.opacity(0.1)
        }.padding(.top, 175)
    }
    
    func retreiveLastRecording() -> URL {
        let lastRecording: URL = audioRecorder.recordings.last!.fileURL
        return lastRecording
    }
    
    func deleteLastRecording() {
        if audioRecorder.recordings.count > 0 {
            delete(at: [audioRecorder.recordings.count-1])
        } else {
            print("set is empty")
        }
    }
    
    func delete(at offsets: IndexSet) {
            
        var urlsToDelete = [URL]()
        
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlToDelete: urlsToDelete.first!)
    }
}

extension CompleteMenu {
    private var play: some View {
        VStack {
            Button(action: {
                if audioPlayer.isPlaying == false {
                    self.audioPlayer.startPlayback(audio: retreiveLastRecording())
                } else {
                    self.audioPlayer.stopPlayback()
                }
                self.timer = 0
            }) {
                Image(audioPlayer.isPlaying ? stop_play_img : play_img)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Text(audioPlayer.isPlaying ? "Stop" : "Play")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
        }
        .frame(width: 55)
    }
    
    private var approved: some View {
        VStack {
            Button(action: {
                // old code
                self.recordingState.state = 0
                // saves recording under entries.recordings
                let processings = audioRecorder.process(fileURL: audioRecorder.recordings.last!.fileURL)
                self.entries.recordings.append(RecordingModel(createdAt: audioRecorder.recordings.last?.createdAt ?? .now, duration: processings.duration, intensity: processings.intensity))
                self.entries.saveItems()
                self.timer = 0
                
                for entry in entries.recordings {
                    print("Entry: \(entry.createdAt)")
                }
                for audio in audioRecorder.recordings {
                    print("Audio: \(audio.createdAt)")
                }
                
                if goal.isActive() {
                    goal.entered += 1
                }
            }) {
                Image(approved_img)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Text("Approved")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
        }
        .frame(width: 55)
        .padding(.horizontal, 25)
    }
    
    private var tryAgain: some View {
        VStack {
            Button(action: {
                deleteLastRecording()
                self.recordingState.state = 0
                self.timer = 0
            }) {
                Image(retry_img)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Text("Try Again")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
        }
        .frame(width: 55)
    }
}
