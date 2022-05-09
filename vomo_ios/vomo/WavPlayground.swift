//
//  WavPlayground.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/9/22.
//

import SwiftUI

struct WavPlayground: View {
    @EnvironmentObject var entries: Entries
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    var body: some View {
        VStack {
            Button("convert last to .wav") {
                
            }
        }
    }
}
