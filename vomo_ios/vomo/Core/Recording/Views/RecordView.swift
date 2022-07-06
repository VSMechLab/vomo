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
    @EnvironmentObject var recordingState: RecordState
    @State private var audioPlayerPrerecordings: AVAudioPlayer?
    
    @State private var svm = SharedViewModel()
    @State private var vm = RecordingViewModel()
    @State private var exercise = 0
    @State private var playLast = false
    @State private var timer = 0
    
    var body: some View {
        ZStack {
            if exercise < 3 {
                RecordBackground(timerCount: self.$timer)
            }
            
            HStack(spacing: 0) {
                backSection
                    .padding(.leading, 2)
                    .background(Color.gray.opacity(0.2))
                
                Spacer()
                
                VStack(spacing: 0) {
                    switch exercise {
                    case 0..<3:
                        vocalSection
                    case 3:
                        QuestionnaireView()
                    case 4:
                        VocalEffortView()
                    case 5:
                        JournalView()
                        Spacer()
                    default:
                        Text("ERROR")
                    }
                }
                .frame(width: svm.content_width - 10)
                .background(Color.green.opacity(0.1))
                
                Spacer()
                
                nextSection
                    .padding(.trailing, 2)
                    .background(Color.gray.opacity(0.2))
            }
            .padding()
            .onAppear() {
                initTasks()
            }
            
            if self.recordingState.state == 2 {
                CompleteMenu(playLast: self.$playLast, promptSelect: self.$exercise, timer: self.$timer)
            }
        }
    }
}

extension ContentView {
    private var vocalSection: some View {
        VStack {
            VStack {
                Spacer()
                Text("\(recordingState.status())")
                    .font(._recordStateStatus)
                    .foregroundColor(Color.BODY_COPY)
                    .padding()
                Text(exercise != 3 ? vm.prompt[exercise] : "")
                    .multilineTextAlignment(.center)
                    .font(._headline)
                Spacer()
                promptPlaybackButton
            }
            .frame(height: UIScreen.main.bounds.height / 3)
            
            Spacer()
        }
    }
    
    private var backSection: some View {
        Group {
            if self.exercise > 0 && moveBackHold() {
                VStack {
                    Spacer()
                    Button(action: {
                        if self.exercise == 3 {
                            self.recordingState.state = 0
                        }
                        decreaseExercise()
                        self.recordingState.task = self.exercise + 1
                    }) {
                        Image(vm.next_img)
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(Angle(degrees: 180))
                    }
                    Spacer()
                }
                .frame(width: vm.navArrowWidth)
            } else {
                Spacer().frame(width: vm.navArrowWidth)
            }
        }
    }
    
    private var nextSection: some View {
        Group {
            if self.exercise < 5 {
                VStack {
                    Spacer()
                    Button(action: {
                        if self.exercise == 2 {
                            self.recordingState.state = 0
                        }
                        increaseExercise()
                    }) {
                        Image(vm.next_img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: vm.navArrowWidth, height: vm.navArrowHeight)
                    }
                    Spacer()
                }
                .frame(width: vm.navArrowWidth)
            } else {
                Spacer().frame(width: vm.navArrowWidth)
            }
        }
    }
    
    private var promptPlaybackButton: some View {
        Button(action: {
            if self.audioPlayerPrerecordings?.isPlaying == true {
                self.audioPlayerPrerecordings?.stop()
            } else {
                let sound = Bundle.main.path(forResource: vm.audio[exercise], ofType: "wav")
                audioPlayerPrerecordings = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                
                self.audioPlayerPrerecordings?.play()
            }
        }) {
            SubmissionButton(label: "PLAY EXAMPLE")
        }
    }
    
    func initTasks() {
        if vm.taskList.contains("vowel") {
            self.exercise = 0
        } else if vm.taskList.contains("max_pt") {
            self.exercise = 1
        } else if vm.taskList.contains("rainbow_s") {
            self.exercise = 2
        }
    }
    
    func increaseExercise() {
        if exercise == 0 {
            if vm.taskList.contains("max_pt") {
                self.exercise += 1
            } else if vm.taskList.contains("rainbow_s") {
                self.exercise += 2
            } else {
                self.exercise += 3
            }
        } else if exercise == 1 {
            if vm.taskList.contains("rainbow_s") {
                self.exercise += 1
            } else {
                self.exercise += 2
            }
        } else {
            self.exercise += 1
        }
        
        self.recordingState.task = self.exercise + 1
    }
    
    func decreaseExercise() {
        if self.exercise == 3 {
            if vm.taskList.contains("rainbow_s") {
                self.exercise -= 1
            } else if vm.taskList.contains("max_pt") {
                self.exercise -= 2
            } else if vm.taskList.contains("vowel") {
                self.exercise -= 3
            }
        } else if self.exercise == 2 {
            if vm.taskList.contains("max_pt") {
                self.exercise -= 1
            } else if vm.taskList.contains("vowel") {
                self.exercise -= 2
            }
        } else if self.exercise == 1 {
            if vm.taskList.contains("vowel") {
                self.exercise -= 1
            }
        } else {
            self.exercise -= 1
        }
        
        self.recordingState.task = self.exercise + 1
    }
    
    func moveBackHold() -> Bool {
        if exercise == 3 {
            if vm.taskList.contains("vowel") || vm.taskList.contains("max_pt") || vm.taskList.contains("rainbow_s") {
                return true
            } else {
                return false
            }
        } else if exercise == 2 {
            if vm.taskList.contains("vowel") || vm.taskList.contains("max_pt") {
                return true
            } else {
                return false
            }
        } else if exercise == 1 {
            if vm.taskList.contains("vowel") {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
