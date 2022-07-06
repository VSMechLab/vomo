//
//  RecordingRow.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/28/22.
//

import SwiftUI

struct RecordingRow: View {
    var audioURL: URL
    var str: String
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        HStack {
            Text("\(str)")//audioURL.lastPathComponent)")
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
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
    }
}
