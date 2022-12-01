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
                .frame(width: 18, height: 20)
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
                        audioRecorder.processedData[index].favorite.toggle()
                        star = audioRecorder.processedData[index].favorite
                        audioRecorder.saveProcessedData()
                    }
                }
            } else if type == "survey" {
                for index in 0..<entries.questionnaires.count {
                    if entries.questionnaires[index].createdAt == date {
                        entries.questionnaires[index].favorite.toggle()
                        star = entries.questionnaires[index].favorite
                        entries.saveQuestionnaireItems()
                    }
                }
            } else if type == "journal" {
                for index in 0..<entries.journals.count {
                    if entries.journals[index].createdAt == date {
                        entries.journals[index].favorite.toggle()
                        star = entries.journals[index].favorite
                        entries.saveJournalItems()
                    }
                }
            }
        }) {
            Image(star ? svm.heart_img : svm.heart_gray_img)
                .resizable()
                .frame(width: 20, height: 20)
        }
        .onAppear() {
            reconfig()
        }
    }
    
    func reconfig() {
        if type == "record" {
            for index in 0..<audioRecorder.processedData.count {
                if audioRecorder.processedData[index].createdAt == date {
                    star = audioRecorder.processedData[index].favorite
                }
            }
        } else if type == "survey" {
            for index in 0..<entries.questionnaires.count {
                if entries.questionnaires[index].createdAt == date {
                    star = entries.questionnaires[index].favorite
                }
            }
        } else if type == "journal" {
            for index in 0..<entries.journals.count {
                if entries.journals[index].createdAt == date {
                    star = entries.journals[index].favorite
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
                .frame(width: 18, height: 20)
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
