//
//  PlayButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/11/22.
//

import SwiftUI
import Foundation
import simd
import AVFAudio

struct PlayButtonByDate: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var date: Date
    
    var body: some View {
        Button(action: {
            if audioPlayer.isPlaying {
                self.audioPlayer.stopPlayback()
            } else {
                for target in audioRecorder.recordings {
                    if date == target.createdAt {
                        self.audioPlayer.startPlayback(audio: target.fileURL)
                    }
                }
            }
        }) {
            Image( audioPlayer.isPlaying ?
                   "VoMo-App-Outline_8_STOP_BTN_PRL" :
                   "VoMo-App-Outline_8_PLAY_BTN_PRPL")
                .resizable()
                .frame(width: 15, height: 17.5)
        }
    }
}

struct DeleteRecording: View {
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var date: Date
    
    let svm = SharedViewModel()
    
    @Binding var reset: Bool
    
    var body: some View {
        Button(action: {
            print(date)
            
            for recording in audioRecorder.recordings {
                if recording.createdAt == date {
                    audioRecorder.deleteRecording(urlToDelete: recording.fileURL)
                }
            }
            var count = -1
            for index in 0..<audioRecorder.processedData.count {
                count = index
            }
            if count != -1 {
                audioRecorder.processedData.remove(at: count)
            }
            self.reset.toggle()
        }) {
            Image(svm.trash_can)
                .resizable()
                .frame(width: 17.5, height: 17.5)
        }
    }
}

struct DeleteEntry: View {
    @EnvironmentObject var entries: Entries
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var date: Date
    
    let svm = SharedViewModel()
    
    @Binding var reset: Bool
    
    var body: some View {
        Button(action: {
            print(date)
            var count = -1
            
            for index in 0..<entries.journals.count {
                if entries.journals[index].createdAt == date {
                    count = index
                }
            }
            if count != -1 {
                entries.journals.remove(at: count)
            }
            count = -1
            for index in 0..<entries.questionnaires.count {
                if entries.questionnaires[index].createdAt == date {
                    count = index
                }
            }
            if count != -1 {
                entries.questionnaires.remove(at: count)
            }
            self.reset.toggle()
        }) {
            Image(svm.trash_can)
                .resizable()
                .frame(width: 17.5, height: 17.5)
        }
    }
}

struct StarButton: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var entries: Entries
    
    @State private var star = false
    
    /// record, survey, journal
    let type: String
    var date: Date
    let svm = SharedViewModel()
    
    var body: some View {
        Button(action: {
            if type == "record" {
                for index in 0..<audioRecorder.processedData.count {
                    if audioRecorder.processedData[index].createdAt == date {
                        audioRecorder.processedData[index].star.toggle()
                        star = audioRecorder.processedData[index].star
                        audioRecorder.saveProcessedData()
                    }
                }
            } else if type == "survey" {
                for index in 0..<entries.questionnaires.count {
                    if entries.questionnaires[index].createdAt == date {
                        entries.questionnaires[index].star.toggle()
                        star = entries.questionnaires[index].star
                        entries.saveQuestionnaireItems()
                    }
                }
            } else if type == "journal" {
                for index in 0..<entries.journals.count {
                    if entries.journals[index].createdAt == date {
                        entries.journals[index].star.toggle()
                        star = entries.journals[index].star
                        entries.saveJournalItems()
                    }
                }
            }
        }) {
            Image(star ? svm.star_img : svm.star_gray_img)
                .resizable()
                .frame(width: 17.5, height: 17.5)
        }
        .onAppear() {
            reconfig()
        }
    }
    
    func reconfig() {
        if type == "record" {
            for index in 0..<audioRecorder.processedData.count {
                if audioRecorder.processedData[index].createdAt == date {
                    star = audioRecorder.processedData[index].star
                }
            }
        } else if type == "survey" {
            for index in 0..<entries.questionnaires.count {
                if entries.questionnaires[index].createdAt == date {
                    star = entries.questionnaires[index].star
                }
            }
        } else if type == "journal" {
            for index in 0..<entries.journals.count {
                if entries.journals[index].createdAt == date {
                    star = entries.journals[index].star
                }
            }
        }
    }
}

struct ShareButtonByDate: View {
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    var date: Date
    
    let svm = SharedViewModel()
    
    var body: some View {
        Button(action: {
            print(date)
            
            for target in audioRecorder.recordings {
                if date == target.createdAt {
                    self.audioRecorder.saveFile(file: target.fileURL)
                }
            }
        }) {
            Image(svm.share_button)
                .resizable()
                .frame(width: 15, height: 17.5)
        }
    }
}


/*
struct PlayButton: View {
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var audio: URL
    
    var body: some View {
        Button(action: {
            print(audio)
            if audioPlayer.isPlaying {
                self.audioPlayer.stopPlayback()
            } else {
                self.audioPlayer.startPlayback(audio: audio)
            }
        }) {
            Image(systemName: audioPlayer.isPlaying ?  "stop.fill" : "play.fill")
        }
    }
}

struct PlaybackButton: View {
    @ObservedObject var audioPlayer = AudioPlayer()
    let file: URL
    var body: some View {
        Button(action: {
            if audioPlayer.isPlaying {
                audioPlayer.stopPlayback()
            } else {
                audioPlayer.startPlayback(audio: file)
            }
        }) {
            Image(systemName: audioPlayer.isPlaying ? "stop.circle" : "play.circle")
                .foregroundColor(audioPlayer.isPlaying ? Color.red.opacity(0.8) : Color.TEAL)
        }
    }
}
*/
