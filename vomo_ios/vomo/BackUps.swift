//
//  BackUps.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/12/22.
//

import SwiftUI

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL, str: recording.fileURL.lastPathComponent)
            }
                .onDelete(perform: delete)
        }
    }
    
    
    func delete(at offsets: IndexSet) {
            
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        //audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
