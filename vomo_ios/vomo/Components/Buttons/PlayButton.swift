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
