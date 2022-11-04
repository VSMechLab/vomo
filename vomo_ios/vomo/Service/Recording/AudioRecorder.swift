//
//  AudioRecorder.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine
import UIKit
import Accelerate // CHANGED: imported for vector math
import AudioKit // CHANGED: also a package dependency
import AVFAudio

class AudioRecorder: NSObject,ObservableObject {
    var processings = Processings()
    
    @Published var processedData: [ProcessedData] = [] {
        didSet { saveProcessedData() }
    }
    let processedDataKey: String = "saved_data"
    func getProcessedData() {
        guard
            let data = UserDefaults.standard.data(forKey: processedDataKey),
            let savedItems = try? JSONDecoder().decode([ProcessedData].self, from: data)
        else { return }
        self.processedData = savedItems
    }
    func saveProcessedData() {
        if let encodedData = try? JSONEncoder().encode(processedData) {
            UserDefaults.standard.set(encodedData, forKey: processedDataKey)
        }
    }
    
    override init() {
        super.init()
        fetchRecordings()
        getProcessedData()
    }
    
    func returnProcessing(createdAt: Date) -> ProcessedData {
        var ret = ProcessedData(createdAt: .now, duration: 99.1, intensity: 99.1, pitch_mean: 99.1, star: false)
        for data in processedData {
            if createdAt == data.createdAt {
                ret = ProcessedData(createdAt: data.createdAt, duration: data.duration, intensity: data.intensity, pitch_mean: data.pitch_mean, star: false)
            }
        }
        return ret
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recordings = [Recording]()
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording(taskNum: Int) {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_HH:mm:ss"))_task\(taskNum).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless), //Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()

            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        fetchRecordings()
    }
    
    func process(fileURL: URL) -> Processings {
        let metrics = signalProcess(fileURL: fileURL)
        
        return Processings(duration: metrics[0], intensity: metrics[1], pitch_mean: metrics[2], pitch_min: 1.0, pitch_max: 1.0)
    }
    
    func returnCreatedAt(fileURL: URL) -> Date {
        var createdAt = Date()
        for record in recordings {
            if record.fileURL == fileURL {
                createdAt = record.createdAt
            }
        }
        return createdAt
    }
    
    /// fetchRecordings fetches recordings from the files then orders them in the data model: Recording
    func fetchRecordings() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        recordings.removeAll()
        
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        objectWillChange.send(self)
    }
    
    func taskNum(selection: Int, file: URL) -> Bool {
        var taskNum = 0
        taskNum = Int(String(file.lastPathComponent).suffix(5).prefix(1))!
        
        if selection == taskNum {
            return true
        } else {
            return false
        }
    }
    
    func uniqueDays() -> [Date] {
        var days: [Date] = []
        
        for record in recordings {
            days.append(record.createdAt.toDay().toDate() ?? . now)
        }
        
        return days.uniqued()
    }
    
    func deleteRecording(urlToDelete: URL) {
        print("deleted: \(urlToDelete.lastPathComponent)")
        do {
           try FileManager.default.removeItem(at: urlToDelete)
        } catch {
            print("File could not be deleted!")
        }
        
        fetchRecordings()
    }
    
    func fileName(file: URL!) -> String {
        var str = ""
        for record in recordings {
            if record.fileURL == file {
                str = record.createdAt.toStringHour()
            }
        }
        return str
    }
    
    func fileTask(file: URL!) -> String {
        var str = ""
        for record in recordings {
            if record.fileURL == file {
                str = record.fileURL.lastPathComponent.suffix(5).prefix(1) + ""
            }
        }
        return str
    }
    
    func viewableTask(file: URL!) -> String {
        var str = ""
        for record in recordings {
            if record.fileURL == file {
                str = record.fileURL.lastPathComponent.suffix(5).prefix(1) + ""
            }
        }
        if str == "1" {
            return "Vowel"
        } else if str == "2" {
            return "Duration"
        } else if str == "3" {
            return "Rainbow"
        } else {
            return "Rainbow"
        }
    }
    
    func taskNum(file: URL!) -> String {
        var str = ""
        for record in recordings {
            if record.fileURL == file {
                str = record.fileURL.lastPathComponent.suffix(5).prefix(1) + ""
            }
        }
        if str == "1" {
            return "vowel"
        } else if str == "2" {
            return "mpt"
        } else if str == "3" {
            return "rainbow"
        } else {
            return "rainbow"
        }
    }
    
    func saveFile(file: URL!) -> Void {
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
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(av, animated: true, completion: nil)
        
        // UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
     }
}

func getCreationDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}

extension AudioRecorder {
    func tasksPresent(day: Date) -> [String] {
        var target: [String] = []
        var filtered: String = ""
        
        for record in recordings {
            if day.toDay() == record.createdAt.toDay() {
                filtered = String(String(record.fileURL.lastPathComponent).suffix(5).prefix(1))
                target.append(filtered)
            }
        }
        
        return target
    }
    
    func months() -> [Date] {
        var model: [Date] = []
        
        for record in recordings {
            model.append(record.createdAt.filterToMonthYear!)
        }
        return model.uniqued().reversed()
    }
    
    func monthsTotal() -> [Double] {
        var total: [Double] = []
        var count = 0.0
        
        for month in months() {
            for record in recordings {
                if month == record.createdAt.filterToMonthYear {
                    count += 1
                }
            }
            total.append(count)
            count = 0
        }
        
        return total.reversed()
    }
    
    func assetTime(file: URL!) -> Double {
        var time: Double = 0.0
        let asset = AVAsset(url: file)
        time = asset.duration.seconds
        
        return time
    }
    
    func filterRecordingsDay(focus: Date) -> [Recording] { return [] }
    func filterRecordingsDayExercise(focus: Date, taskNum: Int) -> [Recording] { return [] }
}

class ProcessedData: Identifiable, Codable {
    var createdAt: Date
    /// Value of duration measured in seconds
    var duration: Float
    var intensity: Float
    /// Mean value of pitch measured in decibles
    var pitch_mean: Float
    /// Boolean value of wether or not the entry is started
    /// to remove this delete the line bellow and debug until working again
    var star: Bool
    
    init(createdAt: Date, duration: Float, intensity: Float, pitch_mean: Float, star: Bool) {
        self.createdAt = createdAt
        self.duration = duration
        self.intensity = intensity
        self.pitch_mean = pitch_mean
        self.star = star
    }
}

struct Recording {
    let fileURL: URL
    let createdAt: Date
}

struct Processings {
    var duration = Float(0) // Seconds
    var intensity = Float(0) // Decibels
    var pitch_mean = Float(0) // Hertz
    var pitch_min = Float(0) // Hertz
    var pitch_max = Float(0) // Hertz
}


/*
 
 class RecordingModel: Identifiable, Codable {
     var createdAt: Date
     var duration: Float
     var intensity: Float
     
     init(createdAt: Date, duration: Float, intensity: Float) {
         self.createdAt = createdAt
         self.duration = duration
         self.intensity = intensity
     }
 }
 
 func filterRecordingsDay(focus: Date) -> [Recording] {
     var filtered: [Recording] = []
     for day in recordings {
         if day.createdAt.toDay() == focus.toDay() {
             filtered.append(day)
         }
     }
     return filtered
 }
 
 func filterRecordingsDayExercise(focus: Date, taskNum: Int) -> [Recording] {
     var filtered: [Recording] = []
     let standardRight: String = String(taskNum) + ".m4a"
     var standardLeft: String = ""
     for day in recordings {
         standardLeft = String(day.fileURL.lastPathComponent)
         if day.createdAt.toDay() == focus.toDay() && standardLeft.suffix(5) == standardRight {
             filtered.append(day)
         }
     }
     return filtered
 }
 */

