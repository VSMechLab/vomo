//
//  APIPlayground.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/5/22.
//

import SwiftUI
import Foundation


/*
 
 Solution:
 RecordingModel: holds only created at and task number
 AudioRecorder: Add two functions
    filterRecordingsDay(day)
    filterRecordingsDayExercise(day, task)
 takes in the day and returns an array of recordings per day or task of day
 
 
 Steps:
    Recordings are only positioned in audioRecorder.recordings
    Thus, deletion will only affect this field
    Entries.recordings is now to be removed
    export to individual views
    place into respective portions of the app
 
 */

struct EntriesList: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var retrieve: Retrieve
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(audioRecorder.uniqueDays(), id: \.self) { day in
                    Button(action: {
                        self.retrieve.focusDay = day
                    }) {
                        RecordingsTile(date: day)
                    }
                }
            }
        }
    }
}

struct ExerciseList: View {
    
    var body: some View {
        Text("hello")
    }
}

struct APIPlayground: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @EnvironmentObject var retrieve: Retrieve
    
    var body: some View {
        VStack(spacing: 0) {
            masterSection
            Divider()
            EntriesList()
            Divider()
            daySection
            Divider()
            dayTaskSection
            Divider()
            playableSection
        }
        .onAppear() {
            
        }
    }
}

extension APIPlayground {
    private var masterSection: some View {
        VStack(spacing: 0) {
            Text("Master View - Do not touch")
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRowDemo(audioURL: recording.fileURL)
            }.padding(2)
        }
        .font(.footnote)
        .background(Color.black.opacity(0.3))
        .padding(0.5)
    }
    
    private var daySection: some View {
        VStack(spacing: 0) {
            Text("Pick a task")
            List {
                ForEach(audioRecorder.filterRecordingsDay(focus: self.retrieve.focusDay), id: \.createdAt) { record in
                    HStack {
                        Text("\(record.fileURL.lastPathComponent)")
                        Spacer()
                        Button(action: {
                            let subject = String(record.fileURL.lastPathComponent).suffix(5)
                                
                            self.retrieve.focusDayExercise = Int(subject.prefix(1))!
                            print(self.retrieve.focusDayExercise)
                        }) {
                            Image(systemName: "checkmark.circle")
                                .imageScale(.large)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .listStyle(PlainListStyle())
            .listRowInsets(.none)
            .listRowSeparator(.hidden)
            .frame(maxHeight: 150)
            .onAppear() {
                for record in audioRecorder.filterRecordingsDay(focus: self.retrieve.focusDay) {
                    let subject = String(record.fileURL.lastPathComponent).suffix(5)
                    if subject.prefix(1) == "1" {
                        self.retrieve.focusDayExercise = Int(subject.prefix(1))!
                    } else if subject.prefix(1) == "2" {
                        self.retrieve.focusDayExercise = Int(subject.prefix(1))!
                    } else if subject.prefix(1) == "3" {
                        self.retrieve.focusDayExercise = Int(subject.prefix(1))!
                    }
                }
            }
        }
        .background(Color.black.opacity(0.1))
        .padding()
    }
    
    private var dayTaskSection: some View {
        VStack(spacing: 0) {
            Text("Pick one of the recordings")
            List {
                ForEach(audioRecorder.filterRecordingsDayExercise(focus: self.retrieve.focusDay, taskNum: self.retrieve.focusDayExercise), id: \.createdAt) { record in
                    HStack {
                        Text("\(record.fileURL.lastPathComponent)")
                        Spacer()
                        Button(action: {
                            self.retrieve.preciseRecord = record.createdAt
                        }) {
                            Image(systemName: "checkmark.circle")
                                .imageScale(.large)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .listStyle(PlainListStyle())
            .listRowInsets(.none)
            .listRowSeparator(.hidden)
            .frame(maxHeight: 150)
            .onAppear() {
                if audioRecorder.filterRecordingsDayExercise(focus: self.retrieve.focusDay, taskNum: self.retrieve.focusDayExercise).count > 0 {
                    self.retrieve.preciseRecord = audioRecorder.filterRecordingsDayExercise(focus: self.retrieve.focusDay, taskNum: self.retrieve.focusDayExercise).first?.createdAt ?? .now
                }
            }
        }
        .background(Color.black.opacity(0.05))
    }
    
    private var playableSection: some View {
        VStack {
            Text("Recording bellow: \(retrieve.preciseRecord.toStringHour())")
            HStack {
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
                        for record in audioRecorder.recordings.reversed() {
                            if record.createdAt == retrieve.focusDay {
                                retrieve.preciseRecord = record.createdAt
                            }
                        }
                    }
                } else {
                    Button(action: {
                        //self.audioPlayer.stopPlayback()
                    }) {
                        Image(systemName: "stop.fill")
                            .imageScale(.large)
                    }
                }
                
                /*
                Button(action: {
                    for record in audioRecorder.recordings {
                        if record.createdAt == retrieve.perciseRecord {
                            delete(at: record.createdA
                        }
                    }
                        
                }) {
                    Image(systemName: "trash.circle")
                }
                */
                
                Button(action: {
                    for record in audioRecorder.recordings {
                        if record.createdAt == retrieve.preciseRecord {
                            audioRecorder.saveFile(file: record.fileURL)
                        }
                    }
                }) {
                    Image(systemName: "square.and.arrow.up.circle")
                }
            }
            
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






















struct RecordingsListDemo: View {
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    var body: some View {
        VStack {
            // what is passed to be played, straight url
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRowDemo(audioURL: recording.fileURL)
            }
            List {
                ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                    Text("Hello")
                    RecordingRowDemo(audioURL: recording.fileURL)
                }
                    .onDelete(perform: delete)
            }
            .padding()
            .background(Color.black.opacity(0.3))
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

struct RecordingRowDemo: View {
    
    var audioURL: URL
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        HStack {
            Text("\(audioURL.lastPathComponent)")
            
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    //print("File +: \(self.audioURL)")
                    self.audioPlayer.startPlayback(audio: self.audioURL)
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
        }
    }
}























/*
struct APIPlayground: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    func post() {
        guard let url = URL (string: "https://redcap.research.cchmc.org/api/") else {return}
        let token = "05F87A6D6F0ABE682DE67381418019CA" // unique to REDCap project
        let record = "3" // set elsewhere
        let event = ""
        let field = "VoMo" // name of field in REDCap
        let path = "path_of_file_to_be_uploaded"
        let repeat_instance : Int = 1
         
        let parameters = [
            [
            "key": "token",
            "value": token,
            "type": "text"
            ],
            [
            "key": "content",
            "value": "file",
            "type": "text"
            ],
            [
            "key": "action",
            "value": "import",
            "type": "text"
            ],
            [
            "key": "record",
            "value": record,
            "type": "text"
            ],
            [
            "key": "field",
            "value": field,
            "type": "text"
            ],
            [
            "key": "event",
            "value": event,
            "type": "text"
            ],
            [
            "key": "repeat_instance",
            "value": repeat_instance,
            "type": "text"
            ],
            [
            "key": "returnFormat",
            "value": "json",
            "type": "text"
            ],
            [
            "key": "file",
            "src": path,
            "type": "file"
        ]] as [[String : Any]]
         
        // build payload
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        for param in parameters {
        if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
                body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
                //let paramValue = param["value"] as! String
                let paramValue = param["value"]
                body += "\r\n\r\n\(String(describing: paramValue))\r\n"
            } else {
                let paramSrc = param["src"] as! String
                let fileData = try? NSData(contentsOfFile:paramSrc, options:[]) as Data
                //let fileContent = String(data: fileData!, encoding: .utf8)!
                let fileContent = String(data: fileData ?? Data(), encoding: .utf8)!
                body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
         
        // create URL request and session
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
         
        request.httpMethod = "POST"
        request.httpBody = postData
         
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("REDCap")
                .font(.title)
           
            Divider()
            
            Button(action: {
                print("send data to redcap")
                post()
            }) {
                VStack {
                    Text("send data to REDCap")
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(10)
                }
                .background(Color.red)
                .cornerRadius(15)
                .padding(.bottom, 100)
            }
            .padding(.top)
            
            //WavPlayground()
        }
    }
}
*/
struct APIPlayground_Previews: PreviewProvider {
    static var previews: some View {
        APIPlayground()
    }
}

