//
//  MiniAudioInterface.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/11/23.
//


import SwiftUI
//import AVKit
import Foundation
import SwiftUI
import Combine
import AVFoundation

struct MiniAudioInterface: View {
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    @Binding var audioPlayer: AVAudioPlayer!
    
    @State var progress: CGFloat = 0.0
    @State private var playing: Bool = false
    @State var duration: Double = 0.0
    @State var formattedDuration: String = ""
    @State var formattedProgress: String = "00:00"
    
    let date: Date
    let svm = SharedViewModel()
    
    var body: some View {
        // the control buttons
        HStack(alignment: .center, spacing: 15) {
            Button(action: {
                let decrease = self.audioPlayer.currentTime - 5
                if decrease < 0.0 {
                    self.audioPlayer.currentTime = 0.0
                } else {
                    self.audioPlayer.currentTime -= 5
                }
            }) {
                Image(svm.backward_img_black)
                    .resizable()
                    .frame(width: 17.5, height: 17.5)
            }
            
            Button(action: {
                if audioPlayer.isPlaying {
                    playing = false
                    self.audioPlayer.pause()
                } else if !audioPlayer.isPlaying {
                    //audioPlayer.delegate = self
                    initialiseAudioPlayer()
                    audioPlayer.play()
                    playing = true
                    self.audioPlayer.play()
                }
            }) {
                Image(playing ? svm.stop_playback_img : svm.start_playback_img)
                    .resizable()
                    .frame(width: 17.5, height: 17.5)
                    .padding(.horizontal, 3.5)
            }
            
            Button(action: {
                let increase = self.audioPlayer.currentTime + 5
                if increase < self.audioPlayer.duration {
                    self.audioPlayer.currentTime = increase
                } else {
                    self.audioPlayer.currentTime = duration
                }
            }) {
                Image(svm.forward_img_black)
                    .resizable()
                    .frame(width: 17.5, height: 17.5)
            }
        }
        .onAppear {
            initialiseAudioPlayer()
        }
        .onDisappear() {
            if audioPlayer != nil {
                audioPlayer.stop()
            }
        }
        /*.onChange(of: audioPlayer.isPlaying) { change in
            playing = change
        }*/
    }
    
    func initialiseAudioPlayer() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        
        /*
         func startPlayback (audio: URL) {
             
             let playbackSession = AVAudioSession.sharedInstance()
             
             do {
                 try playbackSession.setCategory(.playAndRecord, mode: .default)
                 try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
             } catch {
                 print("Playing over the device's speakers failed")
             }
             
             do {
                 audioPlayer = try AVAudioPlayer(contentsOf: audio)
                 audioPlayer.delegate = self
                 audioPlayer.play()
                 isPlaying = true
             } catch {
                 print("Playback failed.")
             }
         }
         */
        
        for target in audioRecorder.recordings {
            if date == target.createdAt {
                /*self.audioPlayer = try! AVAudioPlayer(contentsOf: target.fileURL)
                self.audioPlayer.prepareToPlay()*/
                
                //let sound = Bundle.main.path(forResource: svm.audio[exercise], ofType: "wav")
                //audioPlayer.startPlayback(audio: URL(fileURLWithPath: sound!))
                
                let playbackSession = AVAudioSession.sharedInstance()
                do {
                    try playbackSession.setCategory(.playback, mode: .default)
                    try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                } catch {
                    print("Playing over the device's speakers failed")
                }
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: target.fileURL)
                } catch {
                    print("Playback failed.")
                }
            }
        }
        
        //The formattedDuration is the string to display
        // unwrap
        guard let player = audioPlayer else { return }
        let interval = TimeInterval(player.duration)
        formattedDuration = formatter.string(from: interval) ?? "00"
        duration = self.audioPlayer.duration
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
           if !audioPlayer.isPlaying {
               playing = false
           }
           progress = CGFloat(audioPlayer.currentTime / audioPlayer.duration)
           formattedProgress = formatter.string(from: TimeInterval(self.audioPlayer.currentTime))!
        }
    }
}

struct MiniAudioInterface_Previews: PreviewProvider {
    static var previews: some View {
        MiniAudioInterface(audioPlayer: .constant(nil), date: .now)
            .previewLayout(PreviewLayout.fixed(width: 400, height: 300))
            .previewDisplayName("Default preview")
            .environmentObject(AudioRecorder())
        MiniAudioInterface(audioPlayer: .constant(nil), date: .now)
            .previewLayout(PreviewLayout.fixed(width: 400, height: 300))
            .environment(\.sizeCategory, .accessibilityExtraLarge)
            .environmentObject(AudioRecorder())
    }
}
