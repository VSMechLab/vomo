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
