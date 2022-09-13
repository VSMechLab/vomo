//
//  RecordingSection.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/18/22.
//

import SwiftUI
import UIKit

struct RecordingSection: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    
    @Binding var active: Int
    
    let type: String
    let logo = "VM_record-nav-ds-icon"
    let dropdown = "VM_Dropdown-Btn"
    let timer = Timer.publish(every: 1 / 60, on: .main, in: .common).autoconnect()
    
    @State private var svm = SharedViewModel()
    @State private var selection = -1
    @State private var playAt: Date = .now
    @State private var exercisesPresent: [String] = []
    @State private var timeElapsed: Double = 0.0
    @State private var timeLeft: Double = 0.0
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack {
                Image(logo)
                    .resizable()
                    .frame(width: 55, height: 55)
                    .padding(.leading, 5)
            }
            
            VStack {
                headerSection
                
                playHeader
                
                playingSection
                
                exerciseSelectionSection
                
                recordingsList
            }
            .padding(.trailing, 5)
            .font(._coverBodyCopy)
        }
        .padding(.vertical)
        .frame(width: svm.content_width)
        .foregroundColor(Color.white)
        .background(Color.BRIGHT_PURPLE)
        .onAppear() {
            exercisesPresent = audioRecorder.tasksPresent(day: entries.focusDay)
            if audioRecorder.tasksPresent(day: entries.focusDay).contains("1") {
                selection = 1
                entries.focusDayExercise = selection
            } else if audioRecorder.tasksPresent(day: entries.focusDay).contains("2") {
                selection = 2
                entries.focusDayExercise = selection
            } else if audioRecorder.tasksPresent(day: entries.focusDay).contains("3") {
                selection = 3
                entries.focusDayExercise = selection
            }
            //self.entries.preciseRecord = audioRecorder.filterRecordingsDayExercise(focus: self.entries.focusDay, taskNum: selection).first?.createdAt ?? .now
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        print("Deleting url here: \(urlsToDelete)")
        audioRecorder.deleteRecording(urlToDelete: urlsToDelete.last!)
    }
}

extension RecordingSection {
    private var headerSection: some View {
        HStack {
            Text(type)
                .font(._fieldLabel)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    self.active = 0
                }
            }) {
                Image(dropdown)
                    .resizable()
                    .rotationEffect(.degrees(-180))
                    .frame(width: 20, height: 8.5, alignment: .center)
            }
        }
    }
    
    func returnMMSS(num: Double) -> String {
        let minutes = Int(num) / 60 % 60
        let seconds = Int(num) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var playHeader: some View {
        Group {
            HStack {
                Text(entries.preciseRecord.toStringHour())
                Spacer()
                ForEach(audioRecorder.filterRecordingsDayExercise(focus: self.entries.focusDay, taskNum: self.entries.focusDayExercise), id: \.createdAt) { record in
                    if entries.preciseRecord == record.createdAt {
                        Text("\(returnMMSS(num: audioRecorder.assetTime(file: record.fileURL)))")
                            .foregroundColor(entries.preciseRecord == record.createdAt ? Color.white : Color.BODY_COPY)
                    }
                }
            }
            .font(._fieldLabel)
            
            GeometryReader { geometry in
                ZStack {
                    HStack(spacing: 0) {
                        Color.TEAL
                            .frame(width: geometry.size.width * self.timeElapsed / endTime(), height: 2)
                        Color.white
                            .frame(width: geometry.size.width * self.timeLeft / endTime(), height: 2)
                    }
                    HStack {
                        Color.clear.frame(width: geometry.size.width * self.timeElapsed / endTime())
                        Circle()
                            .foregroundColor(Color.TEAL)
                            .frame(width: 6)
                        Color.clear.frame(width: geometry.size.width * self.timeLeft / endTime())
                    }
                }
                .frame(width: geometry.size.width)
            }
            .frame(height: 6)
            
            HStack {
                Text("\(returnMMSS(num: self.timeElapsed))")
                Spacer()
                Text("\(returnMMSS(num: self.timeLeft))")
            }
            .foregroundColor(Color.white)
            .font(._fieldLabel)
            .onAppear() {
                self.timeLeft = endTime()
            }
            .onReceive(timer) { _ in
                if timeElapsed < endTime() && audioPlayer.isPlaying {
                    self.timeElapsed += 1 / 60
                    self.timeLeft -= 1 / 60
                } else {
                    self.timeElapsed = 0
                    self.timeLeft = endTime()
                }
            }
        }
    }
    
    private var exerciseSelectionSection: some View {
        HStack {
            if !exercisesPresent.contains("1") {
                ZStack {
                    Rectangle()
                        .frame(height: 30)
                        .foregroundColor(Color.BODY_COPY.opacity(0.5))
                        .cornerRadius(10)
                    Text("VOWEL")
                        .foregroundColor(Color.white)
                        .font(._fieldLabel)
                }
            } else {
                Button(action: {
                    selection = 1
                    entries.focusDayExercise = selection
                    self.entries.preciseRecord = audioRecorder.filterRecordingsDayExercise(focus: self.entries.focusDay, taskNum: selection).first?.createdAt ?? .now
                }) {
                    ZStack {
                        Rectangle()
                            .frame(height: 30)
                            .foregroundColor(selection == 1 ? .TEAL : .white)
                            .cornerRadius(10)
                        Text("VOWEL")
                            .foregroundColor(selection == 1 ? .white : .black)
                            .font(._fieldLabel)
                    }
                }
            }
            
            if !exercisesPresent.contains("2") {
                ZStack {
                    Rectangle()
                        .frame(height: 30)
                        .foregroundColor(Color.BODY_COPY.opacity(0.5))
                        .cornerRadius(10)
                    Text("MPT")
                        .foregroundColor(Color.white)
                        .font(._fieldLabel)
                }
            } else {
                Button(action: {
                    selection = 2
                    entries.focusDayExercise = selection
                    self.entries.preciseRecord = audioRecorder.filterRecordingsDayExercise(focus: self.entries.focusDay, taskNum: selection).first?.createdAt ?? .now
                }) {
                    ZStack {
                        Rectangle()
                            .frame(height: 30)
                            .foregroundColor(selection == 2 ? .TEAL : .white)
                            .cornerRadius(10)
                        Text("MPT")
                            .foregroundColor(selection == 2 ? .white : .black)
                            .font(._fieldLabel)
                        
                    }
                }
            }
            
            if !exercisesPresent.contains("3") {
                ZStack {
                    Rectangle()
                        .frame(height: 30)
                        .foregroundColor(Color.BODY_COPY.opacity(0.5))
                        .cornerRadius(10)
                    Text("RAINBOW")
                        .foregroundColor(Color.white)
                        .font(._fieldLabel)
                }
            } else {
                Button(action: {
                    selection = 3
                    entries.focusDayExercise = selection
                    self.entries.preciseRecord = audioRecorder.filterRecordingsDayExercise(focus: self.entries.focusDay, taskNum: selection).first?.createdAt ?? .now
                }) {
                    ZStack {
                        Rectangle()
                            .frame(height: 30)
                            .foregroundColor(selection == 3 ? .TEAL : .white)
                            .cornerRadius(10)
                        Text("RAINBOW")
                            .foregroundColor(selection == 3 ? .white : .black)
                            .font(._fieldLabel)
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    private var recordingsList: some View {
        Group {
            List {
                ForEach(audioRecorder.recordings, id: \.createdAt) { record in
                    if record.createdAt.toDay() == entries.focusDay.toDay()  && audioRecorder.taskNum(selection: selection, file: record.fileURL) {
                        Button(action: {
                            self.entries.preciseRecord = record.createdAt
                        }) {
                            HStack(spacing: 0) {
                                Text("Task: \(audioRecorder.fileTask(file: record.fileURL))")
                                Spacer()
                                Text("\(audioRecorder.fileName(file: record.fileURL))")
                            }
                            .foregroundColor(entries.preciseRecord == record.createdAt ? Color.white : Color.BODY_COPY)
                            .font(._fieldLabel)
                        }
                        .listRowBackground(Color.clear)
                        
                    }
                }
                .onDelete(perform: delete)
            }
            .listStyle(PlainListStyle())
            .listRowInsets(.none)
            .listRowSeparator(.hidden)
        }
    }
    
    private var playingSection: some View {
        HStack {
            Button(action: {
                for record in audioRecorder.recordings {
                    if record.createdAt == entries.preciseRecord {
                        audioRecorder.saveFile(file: record.fileURL)
                    }
                }
            }) {
                Image(systemName: "square.and.arrow.up")
            }
            
            Spacer()
            
            Group {
                if audioPlayer.isPlaying == false {
                    Button(action: {
                        for record in audioRecorder.recordings {
                            if record.createdAt == entries.preciseRecord {
                                self.audioPlayer.startPlayback(audio: record.fileURL)
                            }
                        }
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
            }.frame(height: 20)
            
            Spacer()
            
            Button(action: {
            }) {
                Image(systemName: "ellipsis")
            }
        }
        .foregroundColor(Color.white)
    }
    
    func endTime() -> Double {
        var endTime = 1.0
        
        for record in audioRecorder.filterRecordingsDayExercise(focus: self.entries.focusDay, taskNum: self.entries.focusDayExercise) {
            if entries.preciseRecord == record.createdAt {
                endTime = audioRecorder.assetTime(file: record.fileURL)
            }
        }
        
        return endTime
    }
}
