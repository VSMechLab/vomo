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
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    @State private var audioPlayerPrerecordings: AVAudioPlayer?
    @State private var exercise = 0
    @State private var completePopUp = false
    @State private var landingPopUp = true
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
                grayButton
                
                exercises
                
                Spacer()
                
                arrows
            }
            .frame(width: svm.content_width)
            
            if landingPopUp {
                ZStack {
                    Color.white.opacity(0.001)
                    landingPopUpSection
                }
            } else if completePopUp {
                ZStack {
                    Color.white.opacity(0.001)
                    CompleteMenu(popUp: $completePopUp)
                }
            }
        }
        .onAppear() {
            settings.allTasks = true
        }
    }
}

extension RecordView {
    private var grayButton: some View {
        HStack {
            Button(action: {
                self.viewRouter.currentPage = .home
            }) {
                Text("EXIT")
                    .font(Font._subTitle)
                    .padding(.horizontal)
                    .padding(.vertical, 7.5)
                    .foregroundColor(Color.HEADLINE_COPY)
                    .background(Color.INPUT_FIELDS)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
    }
    
    private var landingPopUpSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: {
                    self.landingPopUp.toggle()
                }) {
                    Image(svm.exit_button)
                        .resizable()
                        .frame(width: 17, height: 17)
                }
                
            }
            
            VStack {
                Text("Find a quiet place indoors, hold your phone at a comfortable distance away from your face")
                    .font(._recordingPopUp)
                    .multilineTextAlignment(.leading)
            }
            .padding(5)
            .background(Color.INPUT_FIELDS)
            .cornerRadius(12)
            .padding(5)
            
            HStack {
                Button(action: {
                    self.landingPopUp.toggle()
                }) {
                    Text("I'M READY")
                        .font(._BTNCopy)
                        .foregroundColor(Color.white)
                }
            }
            .frame(width: svm.content_width * 0.80)
            .background(Color.DARK_PURPLE)
        }
        .padding(.top)
        .background(Color.white)
        .shadow(color: Color.gray, radius: 1)
        .frame(width: svm.content_width * 0.80)
    }
    
    private var exercises: some View {
        VStack(spacing: 10) {
            Text("\(audioRecorder.recording ? "Recording..." : " ")")
                .font(._subTitle)
                .foregroundColor(Color.BODY_COPY)
            
            Text("\(settings.taskList[exercise].prompt)")
                .multilineTextAlignment(.center)
                .font(._title)
            
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
                    self.completePopUp.toggle()
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
            if (audioRecorder.recording || self.completePopUp) {
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
            
            if (audioRecorder.recording || self.completePopUp) && self.exercise != settings.endIndex {
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
            .environmentObject(ViewRouter())
            .environmentObject(Settings())
            .environmentObject(AudioRecorder())
    }
}
