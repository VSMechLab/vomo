//
//  ContentView.swift
//  VoMo
//
//  Created by Neil McGrogan on 1/19/22.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var recordingState: RecordingState
    
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    
    @State var audioPlayerPrerecordings: AVAudioPlayer!
    @State private var promptSelect = 0
    @State private var playing = false
    @State private var audioRecorded = false
    @State private var showMenu = false
    @State private var playLast = false
    @State private var timerCount = 0
    
    let default_audio = ""
    let button_img = "VM_Gradient-Btn"
    let next_img = "VM_next-nav-btn"
    let stop_img = "VM_stop-nav-icon"
    let navArrowWidth = CGFloat(20)
    let navArrowHeight = CGFloat(25)
    let prompts: [String] = ["Say 'ahh' for\n5 seconds", "say 'ahhh' for\nas long as you can", "Say 'A raindbow is a\ndivision of white light\ninto many beautiful colors'"]
    
    let content_width: CGFloat = 317.5
    
    var body: some View {
        ZStack {
            if promptSelect < 3 {
                RecordBackground(timerCount: self.$timerCount, playing: self.playing)
            }
            
            HStack {
                if self.promptSelect > 0 {
                    Button(action: {
                        if self.promptSelect == 3 {
                            self.recordingState.recordingState = 0
                        }
                        self.promptSelect -= 1
                    }) {
                        Image(next_img)
                            .resizable()
                            .rotationEffect(Angle(degrees: 180))
                            .frame(width: navArrowWidth, height: navArrowHeight)
                    }
                } else {
                    Spacer().frame(width: navArrowWidth)
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    switch promptSelect {
                    case 0..<3:
                        VStack {
                            Group {
                                if self.recordingState.recordingState == 0 && self.promptSelect != 3 {
                                    Text("Tap the mic to record")
                                } else if self.recordingState.recordingState == 1 {
                                    Text("Recording...")
                                        .onAppear {
                                            if self.recordingState.recordingState == 2 {
                                                self.playing.toggle()
                                                self.audioRecorder.stopRecording()
                                                self.audioRecorded.toggle()
                                                self.showMenu.toggle()
                                                self.timerCount = 0
                                            } else if self.recordingState.recordingState == 1 {
                                                self.playing.toggle()
                                                self.audioRecorder.startRecording(taskNum: self.promptSelect + 1)
                                            }
                                        }
                                } else if self.recordingState.recordingState == 2 {
                                    Text("Stopped...")
                                        .onAppear {
                                            if self.recordingState.recordingState == 2 {
                                                self.playing.toggle()
                                                self.audioRecorder.stopRecording()
                                                self.audioRecorded.toggle()
                                                self.showMenu.toggle()
                                                self.timerCount = 0
                                            } else if self.recordingState.recordingState == 1 {
                                                self.playing.toggle()
                                                self.audioRecorder.startRecording(taskNum: self.promptSelect + 1)
                                            }
                                        }
                                }
                            }
                            .font(Font.vomoLightBodyText)
                            .foregroundColor(Color.BODY_COPY)
                            
                            Text(promptSelect != 3 ? prompts[promptSelect] : "")
                                .multilineTextAlignment(.center)
                                .font(Font.vomoTitle)
                                .frame(height: 125)
                                .padding(.top, 75)
                            
                            Button(action: {
                                if audioPlayer.isPlaying == false {
                                    self.audioPlayerPrerecordings.play()
                                } else {
                                    self.audioPlayerPrerecordings.pause()
                                }
                            }) {
                                ZStack {
                                    Image(button_img)
                                        .resizable()
                                        .frame(width: 185, height: 45)
                                    
                                    Text("Play Example")
                                        .font(Font.vomoHeader)
                                        .foregroundColor(Color.white)
                                }
                            }.onAppear {
                                let sound = Bundle.main.path(forResource: "default_audio", ofType: "mp3")
                                self.audioPlayerPrerecordings = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                            }
                            
                            Spacer()
                        }
                    case 3:
                        Questionnaire()
                    case 4:
                        VocalEffort()
                    default:
                        Text("ERROR")
                    }
                }
                .frame(width: content_width)
                
                Spacer()
                
                if self.promptSelect < 4 {
                    Button(action: {
                        if self.promptSelect == 2 {
                            self.recordingState.recordingState = 2
                        }
                        self.promptSelect += 1
                    }) {
                        Image(next_img)
                            .resizable()
                            .frame(width: navArrowWidth, height: navArrowHeight)
                    }
                } else {
                    Spacer().frame(width: navArrowWidth)
                }
            }.padding()
            
            VStack {
                if audioRecorded && showMenu {
                    CompleteMenu(audioRecorder: self.audioRecorder, playLast: self.$playLast, showMenu: self.$showMenu, audioRecorded: self.$audioRecorded, promptSelect: self.$promptSelect)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
