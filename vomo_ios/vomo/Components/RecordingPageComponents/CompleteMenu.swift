//
//  CompleteMenu.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/12/22.
//

import SwiftUI

struct CompleteMenu: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var recordingState: RecordingState
    
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    
    @Binding var playLast: Bool
    @Binding var showMenu: Bool
    @Binding var audioRecorded: Bool
    @Binding var promptSelect: Int
    
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
                        HStack {
                            Spacer()
                            
                            Button("X") {
                                self.showMenu.toggle()
                                self.audioRecorded.toggle()
                                self.recordingState.recordingState = 0
                            }
                                .font(.title3.weight(.light))
                                .padding(.top, -10)
                                .padding(.horizontal)
                        }
                        
                        Text("Recording Complete!")
                            .font(Font.vomoHeader)
                        
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
                            VStack {
                                Button(action: {
                                    if audioPlayer.isPlaying == false {
                                        self.audioPlayer.startPlayback(audio: retreiveLastRecording())
                                    } else {
                                        self.audioPlayer.stopPlayback()
                                    }
                                }) {
                                    Image(audioPlayer.isPlaying ? stop_play_img : play_img)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                                
                                Text(audioPlayer.isPlaying ? "Stop" : "Play")
                                    .font(Font.vomoRecordingDay)
                                    .foregroundColor(Color.BODY_COPY)
                            }
                            .frame(width: 55)
                            
                            VStack {
                                Button(action: {
                                    self.showMenu.toggle()
                                    self.audioRecorded.toggle()
                                    self.recordingState.recordingState = 0
                                    self.entries.recordings.append(RecordingModel(createdAt: audioRecorder.recordings.last?.createdAt as! Date, taskNum: promptSelect + 1))
                                    self.entries.saveItems()
                                }) {
                                    Image(approved_img)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                                
                                Text("Approved")
                                    .font(Font.vomoRecordingDay)
                                    .foregroundColor(Color.BODY_COPY)
                            }
                            .frame(width: 55)
                            .padding(.horizontal, 25)
                            VStack {
                                Button(action: {
                                    deleteLastRecording()
                                    self.recordingState.recordingState = 0
                                    self.showMenu.toggle()
                                    self.audioRecorded.toggle()
                                }) {
                                    Image(retry_img)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                                
                                Text("Try Again")
                                    .font(Font.vomoRecordingDay)
                                    .foregroundColor(Color.BODY_COPY)
                            }
                            .frame(width: 55)
                        }
                    }.frame(width: 275, height: 150)
                }
                
                Color.white.opacity(0.1)
            }
            
            Color.white.opacity(0.1)
        }.padding(.top, 175)
    }
    
    func retreiveLastRecording() -> URL {
        let lastRecording = audioRecorder.recordings.last?.fileURL as! URL
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
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}
