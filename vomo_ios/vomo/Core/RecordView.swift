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
    @State private var landingPopUp = false
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
                    CompleteMenu(popUp: $completePopUp, exercise: $exercise)
                }
            }
        }
        .onAppear() {
            if !settings.hidePopUp{
                landingPopUp = true
            }
        }
    }
    
    var endIndex: Bool {
        if exercise == settings.endIndex {
            return true
        } else {
            return false
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
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Button(action: {
                    self.landingPopUp.toggle()
                }) {
                    Image(svm.exit_button)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(5)
                }
            }
            
            ZStack {
                Image(svm.background_img)
                    .resizable()
                    .frame(width: 250, height: 310)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Find a quiet place\nindoors. Hold your\nphone at a comfortable,\n consistent distance.\nMake sure you can\nstill read the\nscreen.")
                            .font(._recordingPopUp)
                            .multilineTextAlignment(.leading)
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
                .frame(width: 250, height: 310)
            }
            .cornerRadius(12)
            .padding(5)
            
            Button("I'M READY") {
                self.landingPopUp.toggle()
            }.buttonStyle(SubmitButton())
            
            HStack {
                Button(action: {
                    if settings.hidePopUp {
                        self.settings.hidePopUp = false
                    } else {
                        self.settings.hidePopUp = true
                    }
                }) {
                    Image(settings.hidePopUp ? svm.selected_do_not_show_img : svm.unselected_do_not_show_img)
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("Do not show again")
                }
                Spacer()
            }
            .frame(width: 225)
            .padding(.vertical, 2.5)
            .padding(.bottom, 5)
        }
        .background(Color.white)
        .frame(width: svm.content_width * 0.80)
        .shadow(color: Color.gray.opacity(0.8), radius: 1)
    }
    
    private var exercises: some View {
        VStack(spacing: 10) {
            Text("\(audioRecorder.recording ? "Recording..." : " ")")
                .font(._subTitle)
                .foregroundColor(Color.BODY_COPY)
            
            if exercise < settings.taskList.count {
                if !landingPopUp {
                    ScrollView(showsIndicators: true) {
                        if settings.taskList[exercise].taskNum == 1 {
                            Text("Say the following for 5 seconds:").foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                                .font(._title1)
                            Text("\(settings.taskList[exercise].prompt)")
                                .multilineTextAlignment(.center)
                                .font(._title)
                        } else if settings.taskList[exercise].taskNum == 2 {
                            Text("Say the following for as long\nas you can:").foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                                .font(._title1)
                            Text("\(settings.taskList[exercise].prompt)")
                                .multilineTextAlignment(.center)
                                .font(._title)
                        } else if settings.taskList[exercise].taskNum == 3 {
                            Text("Say the following:").foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                                .font(._title1)
                            Text("\(settings.taskList[exercise].prompt)")
                                .multilineTextAlignment(.center)
                                .font(._title)
                        }
                    }
                }
            }
            
            if !audioRecorder.recording && !landingPopUp {
                promptPlaybackButton
            } else if !landingPopUp {
                Text("\(time)s")
                    .font(._BTNCopy)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
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
                    audioRecorder.startRecording(taskNum: settings.taskList[exercise].taskNum)
                }
            }) {
                Image(audioRecorder.recording ? svm.stop_img : svm.record_img)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
        }
    }
    
    private var arrows: some View {
        ZStack {
            HStack(spacing: 0) {
                if (audioRecorder.recording || self.completePopUp) && self.exercise != 0 {
                    GrayArrow()
                        .rotationEffect(Angle(degrees: -180))
                    Text("Back")
                        .foregroundColor(Color.BODY_COPY)
                } else if !audioRecorder.recording && self.exercise != 0 {
                    Button("Back") {
                        self.exercise -= 1
                    }.buttonStyle(BackButton())
                }
                
                Spacer()
                
                if (audioRecorder.recording || self.completePopUp) && self.exercise != settings.endIndex {
                    Text("Next")
                        .foregroundColor(Color.BODY_COPY)
                    GrayArrow()
                } else if !audioRecorder.recording && self.exercise != settings.endIndex {
                    Button("Next") {
                        self.exercise += 1
                    }.buttonStyle(NextButton())
                }
            }
            
            .font(._pageNavLink)
            .padding(.bottom, 10)
            
            HStack {
                if settings.endIndex > 0 {
                    ForEach(0...settings.endIndex, id: \.self) { exer in
                        Circle()
                            .foregroundColor(exer == exercise ? Color.DARK_PURPLE : Color.gray)
                            .frame(width: exer == exercise ? 8.5 : 6, height: exer == exercise ? 8.5 : 6, alignment: .center)
                    }
                }
            }
            .padding(.bottom, 10)
        }
    }
    
    private var promptPlaybackButton: some View {
        Button("PLAY EXAMPLE") {
            if self.audioPlayerPrerecordings?.isPlaying == true {
                self.audioPlayerPrerecordings?.stop()
            } else {
                let sound = Bundle.main.path(forResource: svm.audio[exercise], ofType: "wav")
                audioPlayerPrerecordings = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                self.audioPlayerPrerecordings?.play()
            }
        }.buttonStyle(SubmitButton())
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
