//
//  RecordView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

struct RecordView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    @State private var audioPlayerPrerecordings: AVAudioPlayer?
    @State private var exercise = 0
    @State private var popUp = false
    @State private var time: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let svm = SharedViewModel()
    
    var body: some View {
        ZStack {
            ZStack {
                Wave(color: Color.DARK_BLUE, offset: 1.5, recording: $audioRecorder.recording)
                Wave(color: Color.TEAL, offset: 1.0, recording: $audioRecorder.recording)
                Wave(color: Color.DARK_PURPLE, offset: 2.0, recording: $audioRecorder.recording)
            }.frame(height: UIScreen.main.bounds.height / 2)
            
            VStack {
                if exercise == 0 {
                    landing
                } else {
                    exercises
                }
                
                Spacer()
                arrows
            }
            .frame(width: svm.content_width)
            
            if popUp {
                ZStack {
                    Color.white.opacity(0.001)
                    CompleteMenu(popUp: $popUp)
                }
            }
        }
        .onAppear() {
            settings.allTasks = true
        }
    }
}

extension RecordView {
    private var landing: some View {
        VStack {
            Text("Record your voice")
                .multilineTextAlignment(.center)
                .font(._headline)
            
            Text("Hold the phone 5 inches from your face")
                .font(._recordStateStatus)
                .foregroundColor(Color.BODY_COPY)
        }
    }
    
    private var exercises: some View {
        VStack(spacing: 10) {
            Text("\(audioRecorder.recording ? "Recording..." : " ")")
                .font(._recordStateStatus)
                .foregroundColor(Color.BODY_COPY)
            
            Text("\(settings.taskList[exercise - 1].prompt)")
                .multilineTextAlignment(.center)
                .font(._headline)
            
            if !audioRecorder.recording {
                promptPlaybackButton
            } else {
                Text("\(time)s")
                    .padding(.horizontal)
                    .background(Color.red.opacity(0.90))
                    .cornerRadius(10)
                    .onReceive(timer) { _ in
                        time += 1
                    }
            }
            
            Spacer()
            
            Button(action: {
                if audioRecorder.recording {
                    audioRecorder.stopRecording()
                    self.popUp.toggle()
                    self.time = 0
                } else {
                    audioRecorder.startRecording(taskNum: exercise)
                }
            }) {
                Image(audioRecorder.recording ? svm.stop_img : svm.record_img)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
        }
    }
    
    private var arrows: some View {
        HStack {
            if (audioRecorder.recording || self.popUp) {
                GrayArrow()
                    .rotationEffect(Angle(degrees: -180))
                Text("Back")
                    .foregroundColor(Color.BODY_COPY)
                    .font(._pageNavLink)
            } else if !audioRecorder.recording && self.exercise != 0 {
                Button(action: {
                    self.exercise -= 1
                }) {
                    Arrow()
                        .rotationEffect(Angle(degrees: -180))
                    Text("Back")
                        .foregroundColor(Color.DARK_PURPLE)
                        .font(._pageNavLink)
                }
            }
            
            Spacer()
            
            if (audioRecorder.recording || self.popUp) && self.exercise != settings.endIndex {
                Text("Next")
                    .foregroundColor(Color.BODY_COPY)
                    .font(._pageNavLink)
                GrayArrow()
            } else if !audioRecorder.recording && self.exercise != settings.endIndex {
                Button(action: {
                    self.exercise += 1
                }) {
                    Text("Next")
                        .foregroundColor(Color.DARK_PURPLE)
                        .font(._pageNavLink)
                    Arrow()
                }
            }
        }
    }
    
    private var promptPlaybackButton: some View {
        Button(action: {
            if self.audioPlayerPrerecordings?.isPlaying == true {
                self.audioPlayerPrerecordings?.stop()
            } else {
                let sound = Bundle.main.path(forResource: svm.audio[exercise], ofType: "wav")
                audioPlayerPrerecordings = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                self.audioPlayerPrerecordings?.play()
            }
        }) {
            SubmissionButton(label: "PLAY EXAMPLE")
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
            .environmentObject(Settings())
            .environmentObject(AudioRecorder())
    }
}
