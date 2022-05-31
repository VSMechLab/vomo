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
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @Binding var active: Int
    
    @State private var playing = false
    
    let focus: Date
    let type: String
    
    let logo = "VM_record-nav-icon"
    let dropdown = "VM_Dropdown-Btn"
    
    @State private var selection = -1
    @State private var playAt: Date = .now
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Image(logo)
                    .resizable()
                    .frame(width: 42, height: 42, alignment: .center)
                    .shadow(radius: 2)
                
                Spacer()
                
                Text("")
            }.frame(height: 100)
            
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
                    Group {
                        HStack {
                            Text("24 Oct 2022")
                            Spacer()
                            Text("01:20")
                        }
                        
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
                        
                        HStack {
                            Text("0:40")
                            Spacer()
                            Text("0:40")
                        }
                    }
                    
                    HStack {
                        Button(action: {
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "gobackward.5")
                        }
                        Button(action: {
                        }) {
                            PlayButton(audio: retrieveAudioURL(createdAt: playAt))
                                .buttonStyle(BorderlessButtonStyle())
                                .frame(width: 20)
                            //Image(systemName: playing ? "pause.fill" : "play.fill").padding(.horizontal)
                        }
                        Button(action: {}) {
                            Image(systemName: "goforward.5")
                        }
                        Spacer()
                        Button(action: {
                            saveFile(file: retrieveAudioURL(createdAt: playAt))
                        }) {
                            Image(systemName: "ellipsis")
                        }
                    }
                    .foregroundColor(Color.white)
                    .padding(.vertical)
                }
                
                HStack {
                    Button(action: { selection = 1 }) {
                        ZStack {
                            Rectangle()
                                .frame(height: 30)
                                .foregroundColor(selection == 1 ? .TEAL : .white)
                                .cornerRadius(10)
                            Text("Vowel")
                                .foregroundColor(selection == 1 ? .white : .black)
                        }
                    }
                    
                    Button(action: { selection = 2 }) {
                        ZStack {
                            Rectangle()
                                .frame(height: 30)
                                .foregroundColor(selection == 2 ? .TEAL : .white)
                                .cornerRadius(10)
                            Text("MPT")
                                .foregroundColor(selection == 2 ? .white : .black)
                        }
                    }
                    
                    Button(action: { selection = 3 }) {
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
                
                if selection == -1 {
                    ScrollView(showsIndicators: false) {
                        if !entries.recordingsPresent {
                            ForEach(entries.recordings) { recording in
                                if (focus.toStringDay() == recording.createdAt.toStringDay()) {
                                    HStack {
                                        Button(action: {
                                            self.playAt = recording.createdAt
                                        }) {
                                            HStack {
                                                Text("Recording at \(recording.taskNum): \(recording.createdAt.toString(dateFormat: "h:mm a"))").padding()
                                                
                                                Spacer()
                                            }
                                            .padding(10)
                                            .foregroundColor(playAt == recording.createdAt ? Color.white : Color.DARK_BLUE)
                                            .background(playAt == recording.createdAt ? Color.DARK_BLUE : Color.white)
                                            .cornerRadius(10)
                                            .padding(2)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    if !entries.recordingsPresent {
                        ForEach(entries.recordings) { recording in
                            if (focus.toStringDay() == recording.createdAt.toStringDay()) && (selection == recording.taskNum) {
                                HStack {
                                    Button(action: {
                                        self.playAt = recording.createdAt
                                    }) {
                                        HStack {
                                            Text("Recording at \(recording.taskNum): \(recording.createdAt.toString(dateFormat: "h:mm a"))").padding()
                                            
                                            Spacer()
                                        }
                                        .padding(10)
                                        .foregroundColor(playAt == recording.createdAt ? Color.white : Color.DARK_BLUE)
                                        .background(playAt == recording.createdAt ? Color.DARK_BLUE : Color.white)
                                        .cornerRadius(10)
                                        .padding(2)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .font(._coverBodyCopy)
        }
        .foregroundColor(Color.white)
        .padding()
        .background(Color.BRIGHT_PURPLE)
    }
    
    func retrieveAudioURL(createdAt: Date) -> URL {
        var returnURL: URL = URL(string: "https://apple.com/")!
        
        for recording in audioRecorder.recordings {
            if recording.createdAt == createdAt {
                returnURL = recording.fileURL
            }
        }
        
        return returnURL
    }
    
    func saveFile(file: URL!) -> Void{
        do {
            let data = try Data.init(contentsOf: file!)
            try data.write(to: file!, options: .atomic)
            //try contents.write(to: dir!, atomically: true, encoding: .utf8)
        } catch {
           print(error.localizedDescription)
        }
        var filesToShare = [Any]()
        filesToShare.append(file!)
        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

/// DO - not delete
/*
Button(action: {
    saveFile(file: retrieveAudioURL(createdAt: recording.createdAt))
    print("download")
}) {
    Image(systemName: "icloud.and.arrow.down")
}.buttonStyle(BorderlessButtonStyle())
    .padding()
*/
 /*
PlayButton(audio: retrieveAudioURL(createdAt: recording.createdAt))
    .buttonStyle(BorderlessButtonStyle())
    .frame(width: 20)
*/
/*
 
 func saveFile(file: URL!) -> Void{
     do {
         let data = try Data.init(contentsOf: file!)
         try data.write(to: file!, options: .atomic)
         //try contents.write(to: dir!, atomically: true, encoding: .utf8)
     } catch {
        print(error.localizedDescription)
     }
     var filesToShare = [Any]()
     filesToShare.append(file!)
     let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
     UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
 }
 
 
 */
