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
    let svm = SharedViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            header
            
            Text("Recordings")
                .bold()
            List {
                ForEach(audioRecorder.recordings, id: \.createdAt) { record in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(record.createdAt.toStringDay())")
                                .bold()
                            Text("Duration: \(audioRecorder.returnProcessing(createdAt: record.createdAt).duration, specifier: "%.2f")s, intensity: \(audioRecorder.returnProcessing(createdAt: record.createdAt).intensity, specifier: "%.1f")hz")
                        }
                        Spacer()
                        PlaybackButton(file: record.fileURL)
                            .font(.title)
                    }
                }.onDelete(perform: delete)
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, -10)
            
            Text("Questionnaires")
                .bold()
            List {
                ForEach(entries.questionnaires) { response in
                    VStack(alignment: .leading) {
                        Text("Date: \(response.createdAt.toStringDay())")
                            .bold()
                        Text("Question 1: \(response.responses[1])")
                        Text("Question 2: \(response.responses[2])")
                        Text("Question 3: \(response.responses[3])")
                    }
                }//.onDelete(perform: nil)
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, -10)
        }
        .padding(.vertical)
        .frame(width: svm.content_width)
        .onAppear() {
            entries.getItems()
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            print(audioRecorder.recordings[index].fileURL)
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        print("Deleting url here: \(urlsToDelete)")
        audioRecorder.deleteRecording(urlToDelete: urlsToDelete.last!)
    }
}

extension ProgressView {
    private var header: some View {
        VStack(alignment: .leading) {
            Text("Progress")
                .bold()
                .font(._title)
            Text("Log some recordings, questionnaires, journals and interventions and view them bellow. The purpose of this page is to ensure that I am able to pull everything the user saves properly, without items disapearing or getting corrupted.")
                .font(._subTitle)
                .foregroundColor(Color.BODY_COPY)
                .multilineTextAlignment(.leading)
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


