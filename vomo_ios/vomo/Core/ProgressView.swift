//
//  ProgressView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var audioRecorder: AudioRecorder
    var body: some View {
        VStack {
            Button(action: {
            }) {
                Text("Progress")
                    .bold()
            }
            
            List {
                ForEach(audioRecorder.recordings, id: \.createdAt) { record in
                    HStack {
                        Text("\(record.createdAt.toStringDay())")
                            .foregroundColor(Color.DARK_BLUE)
                        Text("Duration: \(audioRecorder.returnProcessing(createdAt: record.createdAt).duration, specifier: "%.0f")s")
                        PlaybackButton(file: record.fileURL)
                    }
                }//.onDelete(perform: delete)
            }
            .onAppear() {
                print(audioRecorder.recordings)
            }
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .environmentObject(AudioRecorder())
            .environmentObject(Entries())
    }
}

private struct PlaybackButton: View {
    @ObservedObject var audioPlayer = AudioPlayer()
    let file: URL
    var body: some View {
        Button(action: {
            if audioPlayer.isPlaying {
                audioPlayer.stopPlayback()
            } else {
                audioPlayer.startPlayback(audio: file)
            }
        }) {
            Image(systemName: audioPlayer.isPlaying ? "stop.circle.fill" : "play.circle.fill")
        }
    }
}

/*
func delete(at offsets: IndexSet) {
    var urlsToDelete = [URL]()
    for index in offsets {
        print(audioRecorder.recordings[index].fileURL)
        entries.removeAtCreated(createdAt: audioRecorder.recordings[index].createdAt)
        urlsToDelete.append(audioRecorder.recordings[index].fileURL)
    }
    print("Deleting url here: \(urlsToDelete)")
    audioRecorder.deleteRecording(urlToDelete: urlsToDelete.last!)
}

func findRecord(createdAt: Date) -> Float {
    var ret: Float = 0.0
    for entry in entries.recordings {
        if createdAt == entry.createdAt {
            ret = entry.intensity
        }
    }
    return ret
}

/// - get rid of this function
/// - add function that returns processings based on the date of the entry
/// - function lives in entries.recordings
func matchEntry(createdAt: Date) -> Bool {
    var result = false
    for entry in entries.recordings {
        if createdAt == entry.createdAt {
            result = true
        }
    }
    return result
}

func syncEntry() {
    for record in audioRecorder.recordings {
        if !matchEntry(createdAt: record.createdAt) {
            let processings = audioRecorder.process(fileURL: record.fileURL)
            
            self.entries.recordings.append(RecordingModel(createdAt: record.createdAt, duration: processings.duration, intensity: processings.intensity))
            self.entries.saveItems()
        }
    }
}*/
