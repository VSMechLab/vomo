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
    @EnvironmentObject var retrieve: Retrieve
    @Binding var active: Int
    
    let focus: Date
    let type: String
    
    @State private var svm = SharedViewModel()
    
    let logo = "VM_record-nav-ds-icon"
    let dropdown = "VM_Dropdown-Btn"
    let timer = Timer.publish(every: 1 / 60, on: .main, in: .common).autoconnect()
    
    @State private var selection = -1
    @State private var playAt: Date = .now
    @State private var deletionSelection: Date = .now
    
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
                Spacer()
            }
            
            VStack {
                headerSection
                
                playHeader
                
                playingSection
                
                exerciseSelectionSection
                
                recordingsList
                
                Spacer()
            }
            .padding(.trailing, 5)
            .font(._coverBodyCopy)
        }
        .padding(.vertical)
        .frame(width: svm.content_width)
        .foregroundColor(Color.white)
        .background(Color.BRIGHT_PURPLE)
        .onAppear() {
            exercisesPresent = audioRecorder.tasksPresent(day: retrieve.focusDay)
            if audioRecorder.tasksPresent(day: retrieve.focusDay).contains("1") {
                selection = 1
                retrieve.focusDayExercise = selection
            } else if audioRecorder.tasksPresent(day: retrieve.focusDay).contains("2") {
                selection = 2
                retrieve.focusDayExercise = selection
            } else if audioRecorder.tasksPresent(day: retrieve.focusDay).contains("3") {
                selection = 3
                retrieve.focusDayExercise = selection
            }
            self.retrieve.preciseRecord = audioRecorder.filterRecordingsDayExercise(focus: self.retrieve.focusDay, taskNum: selection).first?.createdAt ?? .now
            print("by default: \(retrieve.focusDayExercise), and choosing record: \(retrieve.preciseRecord)")
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

extension RecordingSection {
    private var exerciseSelectionSection: some View {
        HStack {
            if !exercisesPresent.contains("1") {
                ZStack {
                    Rectangle()
                        .frame(height: 30)
                        .foregroundColor(Color.BODY_COPY.opacity(0.5))
                        .cornerRadius(10)
                    Text("Vowel")
                        .foregroundColor(Color.white)
                        .font(._fieldLabel)
                }
            } else {
                Button(action: {
                    selection = 1
                    retrieve.focusDayExercise = selection
                }) {
                    ZStack {
                        Rectangle()
                            .frame(height: 30)
                            .foregroundColor(selection == 1 ? .TEAL : .white)
                            .cornerRadius(10)
                        Text("Vowel")
                            .foregroundColor(selection == 1 ? .white : .black)
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
                }
            } else {
                Button(action: {
                    selection = 2
                    retrieve.focusDayExercise = selection
                }) {
                    ZStack {
                        Rectangle()
                            .frame(height: 30)
                            .foregroundColor(selection == 2 ? .TEAL : .white)
                            .cornerRadius(10)
                        Text("MPT")
                            .foregroundColor(selection == 2 ? .white : .black)
                    }
                }
            }
            
            if !exercisesPresent.contains("3") {
                ZStack {
                    Rectangle()
                        .frame(height: 30)
                        .foregroundColor(Color.BODY_COPY.opacity(0.5))
                        .cornerRadius(10)
                    Text("Rainbow")
                        .foregroundColor(Color.white)
                }
            } else {
                Button(action: {
                    selection = 3
                    retrieve.focusDayExercise = selection
                }) {
                    ZStack {
                        Rectangle()
                            .frame(height: 30)
                            .foregroundColor(selection == 3 ? .TEAL : .white)
                            .cornerRadius(10)
                        Text("Rainbow")
                            .foregroundColor(selection == 3 ? .white : .black)
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    private var playHeader: some View {
        Group {
            HStack {
                Text(focus.toStringHour())
                Spacer()
                ForEach(audioRecorder.filterRecordingsDayExercise(focus: self.retrieve.focusDay, taskNum: self.retrieve.focusDayExercise), id: \.createdAt) { record in
                    if retrieve.preciseRecord == record.createdAt {
                        Text("\((audioRecorder.assetTime(file: record.fileURL)), specifier: "%.2f")")
                            .foregroundColor(retrieve.preciseRecord == record.createdAt ? Color.white : Color.BODY_COPY)
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
            /*
            ZStack {
                HStack(spacing: 0) {
                    Color.TEAL
                    Color.white
                }.frame(height: 2)
                
                Circle()
                    .foregroundColor(Color.TEAL)
                    .frame(width: 6)
            }
            .frame(height: 6)
            */
            HStack {
                Text("\(self.timeElapsed, specifier: "%.2f")")
                Spacer()
                Text("\(self.timeLeft, specifier: "%.2f")")
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
    
    private var recordingsList: some View {
        List {
            ForEach(audioRecorder.filterRecordingsDayExercise(focus: self.retrieve.focusDay, taskNum: self.retrieve.focusDayExercise), id: \.createdAt) { record in
                Button(action: {
                    self.retrieve.preciseRecord = record.createdAt
                }) {
                    HStack(spacing: 0) {
                        Text("Task: \(audioRecorder.fileTask(file: record.fileURL))")
                        Spacer()
                        Text("\(audioRecorder.fileName(file: record.fileURL))")
                    }
                    .foregroundColor(retrieve.preciseRecord == record.createdAt ? Color.white : Color.BODY_COPY)
                    .font(._fieldLabel)
                }.listRowBackground(Color.clear)
            }
            //.onDelete(perform: delete)
        }
        .listStyle(PlainListStyle())
        .listRowInsets(.none)
        .listRowSeparator(.hidden)
    }
    
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
    
    private var playingSection: some View {
        HStack {
            Button(action: {
                for record in audioRecorder.recordings {
                    if record.createdAt == retrieve.preciseRecord {
                        audioRecorder.saveFile(file: record.fileURL)
                    }
                }
            }) {
                Image(systemName: "square.and.arrow.up.circle")
            }
            
            Spacer()
            Button(action: {}) {
                Image(systemName: "gobackward.5")
            }
            
            Group {
                if audioPlayer.isPlaying == false {
                    Button(action: {
                        for record in audioRecorder.recordings {
                            if record.createdAt == retrieve.preciseRecord {
                                self.audioPlayer.startPlayback(audio: record.fileURL)
                            }
                        }
                    }) {
                        Image(systemName: "play.circle")
                            .imageScale(.large)
                    }
                    .onAppear() {
                        //retrieve.preciseRecord = audioRecorder.
                    }
                } else {
                    Button(action: {
                        //self.audioPlayer.stopPlayback()
                    }) {
                        Image(systemName: "stop.fill")
                            .imageScale(.large)
                    }
                }
            }.frame(height: 20)
            
            Button(action: {}) {
                Image(systemName: "goforward.5")
            }
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
        
        for record in audioRecorder.filterRecordingsDayExercise(focus: self.retrieve.focusDay, taskNum: self.retrieve.focusDayExercise) {
            if retrieve.preciseRecord == record.createdAt {
                endTime = audioRecorder.assetTime(file: record.fileURL)
            }
        }
        
        return endTime
    }
}

/*
.onAppear() {
    if entries.tasksPresent(day: playAt).contains("One") {
        self.selection = 1
    } else {
        if entries.tasksPresent(day: playAt).contains("Two") {
            self.selection = 2
        } else {
            if entries.tasksPresent(day: playAt).contains("Three") {
                self.selection = 3
            }
        }
    }
}
*/

/*
VStack(alignment: .leading) {
    HStack {
        Text(type)
        
        Spacer()
        
        Button(action: {
            self.active = 0
        }) {
            Image(dropdown)
                .resizable()
                .rotationEffect(.degrees(-180))
                .frame(width: 25, height: 10, alignment: .center)
        }
    }
    
    if selection != -1 {
        playbackBarSection
        
    }
    
    exerciseSectionSelection
    
    /*
     
     HStack {
         Button(action: {
             self.playAt = recording.createdAt
             print(playAt)
         }) {
             HStack {
                 Text("Recording at \(recording.taskNum): \(recording.createdAt.toString(dateFormat: "h:mm a"))").padding()
                 
                 Spacer()
             }
             .foregroundColor(playAt == recording.createdAt ? Color.white : Color.DARK_BLUE)
             .background(playAt == recording.createdAt ? Color.TEAL : Color.white)
             .cornerRadius(10)
             .padding(2)
             .onAppear() {
                 playAt = entries.firstRecordingFromSpecifiedDay(day: focus, filterTask: selection)
             }
         }
     }
     
     */
}
*/
