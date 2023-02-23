//
//  AudioInterface.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/30/22.
//


import SwiftUI
//import AVKit
import Foundation
import SwiftUI
import Combine
import AVFoundation

struct AudioInterface: View {
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    @State var audioPlayer: AVAudioPlayer!
    @State var progress: CGFloat = 0.0
    @State private var playing: Bool = false
    @State var duration: Double = 0.0
    @State var formattedDuration: String = ""
    @State var formattedProgress: String = "00:00"
    
    let date: Date
    let svm = SharedViewModel()
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text(formattedProgress)
                    .font(.caption.monospacedDigit())
                
                // this is a dynamic length progress bar
                GeometryReader { gr in
                    Capsule()
                        .stroke(Color.DARK_PURPLE, lineWidth: 1)
                        .background(
                            Capsule()
                                .foregroundColor(Color.DARK_PURPLE)
                                .frame(width: gr.size.width * progress, height: 6), alignment: .leading)
                }
                .frame( height: 6)
                
                Text(formattedDuration)
                    .font(.caption.monospacedDigit())
            }
            .padding(5)
            .frame(height: 30, alignment: .center)
            
            // the control buttons
            HStack(alignment: .center, spacing: 20) {
                Spacer()

                Button(action: {
                    let decrease = self.audioPlayer.currentTime - 5
                    if decrease < 0.0 {
                        self.audioPlayer.currentTime = 0.0
                    } else {
                        self.audioPlayer.currentTime -= 5
                    }
                }) {
                    Image(svm.backward_img)
                        .resizable()
                        .frame(width: 22.5, height: 22.5)
                }
                
                Button(action: {
                    if audioPlayer.isPlaying {
                        playing = false
                        self.audioPlayer.pause()
                    } else if !audioPlayer.isPlaying {
                        do {
                            //audioPlayer.delegate = self
                            audioPlayer.play()
                            playing = true
                            self.audioPlayer.play()
                        } catch {
                            print("error")
                        }
                        
                    }
                }) {
                    Image(playing ? svm.stop_playback_img : svm.start_playback_img)
                        .resizable()
                        .frame(width: 22.5, height: 22.5)
                        .padding(.horizontal, 7.5)
                }
                
                Button(action: {
                    let increase = self.audioPlayer.currentTime + 5
                    if increase < self.audioPlayer.duration {
                        self.audioPlayer.currentTime = increase
                    } else {
                        self.audioPlayer.currentTime = duration
                    }
                }) {
                    Image(svm.forward_img)
                        .resizable()
                        .frame(width: 22.5, height: 22.5)
                }

                Spacer()
            }
        }
        .onAppear {
            initialiseAudioPlayer()
        }
        .onDisappear() {
            audioPlayer.stop()
        }
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
        formattedDuration = formatter.string(from: TimeInterval(self.audioPlayer.duration))!
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

struct AudioInterface_Previews: PreviewProvider {
    static var previews: some View {
        AudioInterface(date: .now)
            .previewLayout(PreviewLayout.fixed(width: 400, height: 300))
            .previewDisplayName("Default preview")
            .environmentObject(AudioRecorder())
        AudioInterface(date: .now)
            .previewLayout(PreviewLayout.fixed(width: 400, height: 300))
            .environment(\.sizeCategory, .accessibilityExtraLarge)
            .environmentObject(AudioRecorder())
    }
}


