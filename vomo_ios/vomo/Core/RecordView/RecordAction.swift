//
//  RecordAction.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/9/22.
//

import Foundation
import SwiftUI

struct CompleteMenu: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    @Binding var popUp: Bool
    @Binding var exercise: Int
    
    let content_width = 285.0
    let svm = SharedViewModel()
    
    var body: some View {
        VStack {
            Text("Recording complete!")
                .font(._recordingPopUp)
                .padding(.vertical)
            
            AudioInterface(date: audioRecorder.recordings.last!.createdAt)
                .padding()
                .background(Color.BRIGHT_PURPLE)
            
            HStack {
                //play
                
                approved
                
                tryAgain
            }.padding(.vertical)
        }
        .frame(width: content_width, height: 250).opacity(0.95)
        .background(Color.white.shadow(color: Color.black.opacity(0.2), radius: 5))
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
            }) {
                Image(audioPlayer.isPlaying ? svm.stop : svm.play)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Text(audioPlayer.isPlaying ? "Stop" : "Play")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
        }
        .frame(width: content_width / 3)
    }
    
    private var approved: some View {
        VStack {
            Button(action: {
                // Appending processed data to
                self.audioRecorder.process(recording: audioRecorder.recordings.last!)
                
                if settings.isActive() && settings.recordPerWeek != 0 {
                    settings.recordEntered += 1
                }
                
                self.popUp.toggle()
                if exercise != settings.endIndex {
                    self.exercise += 1
                }
            }) {
                Image(svm.approved_img)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Text("Approved")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
        }
        .frame(width: content_width / 2)
    }
    
    private var tryAgain: some View {
        VStack {
            Button(action: {
                deleteLastRecording()
                self.popUp.toggle()
            }) {
                Image(svm.retry_img)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Text("Try Again")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
        }
        .frame(width: content_width / 2)
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

struct CompleteMenu_Previews: PreviewProvider {
    static var previews: some View {
        CompleteMenu(popUp: .constant(true), exercise: .constant(1))
            .environmentObject(Settings())
            .environmentObject(AudioRecorder())
    }
}
