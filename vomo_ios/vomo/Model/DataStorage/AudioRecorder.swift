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

struct Processings {
    var duration = Float(0) // Seconds
    var intensity = Float(0) // Decibels
    var pitch_mean = Float(0) // Hertz
    var pitch_min = Float(0) // Hertz
    var pitch_max = Float(0) // Hertz
}

/// AudioRecorder - stores audio files, saved processings of files and functions for the files
class AudioRecorder: NSObject, ObservableObject {
    
    @EnvironmentObject var settings: Settings
    
    // Attributes
    let processedDataKey: String = "saved_data"
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var recording = false {
        didSet { objectWillChange.send(self) }
    }
    var processedData: [MetricsModel] = [] {
        didSet { saveProcessedData() }
    }

    // Q: What is this used for?
    //var processings = Processings()
    
    // Live Recording Values
    // TODOSW seperate out into additional file where applicable
    
    @Published var gain: Float = 0.025
    @Published var zeroReference: Double = 1000
    @Published var nyqFreq: Float = 0

    // MARK: Properties
    // TODOSW
    //let audioEngine = AVAudioEngine()
    //let inputNode = AVAudioInputNode()
    /// The number of samples per frame — the height of the spectrogram.
    var average:Float = 0
    static let sampleCount = 1024
    
    /// The number of displayed buffers — the width of the spectrogram.
    static let bufferCount = 768
    
    /// Determines the overlap between frames.
    static let hopCount = 512

    let captureSession = AVCaptureSession()
    let audioOutput = AVCaptureAudioDataOutput()
    let captureQueue = DispatchQueue(label: "captureQueue",
                                     qos: .userInitiated,
                                     attributes: [],
                                     autoreleaseFrequency: .workItem)
    let sessionQueue = DispatchQueue(label: "sessionQueue",
                                     attributes: [],
                                     autoreleaseFrequency: .workItem)
    
    let forwardDCT = vDSP.DCT(count: sampleCount,
                              transformType: .II)!
    
    /// The window sequence for reducing spectral leakage.
    let hanningWindow = vDSP.window(ofType: Float.self,
                                    usingSequence: .hanningDenormalized,
                                    count: sampleCount,
                                    isHalfWindow: false)
    
    let dispatchSemaphore = DispatchSemaphore(value: 1)
    
    /// The highest frequency that the app can represent.
    ///
    /// The first call of `AudioSpectrogram.captureOutput(_:didOutput:from:)` calculates
    /// this value.
    var nyquistFrequency: Float = 0
    
    /// A buffer that contains the raw audio data from AVFoundation.
    var rawAudioData = [Int16]()
    
    /// Raw frequency-domain values.
    var frequencyDomainValues = [Float](repeating: 0,
                                        count: bufferCount * sampleCount)
 


    /// A reusable array that contains the current frame of time-domain audio data as single-precision
    /// values.
    var timeDomainBuffer = [Float](repeating: 0,
                                   count: sampleCount)
    
    /// A resuable array that contains the frequency-domain representation of the current frame of
    /// audio data.
    var frequencyDomainBuffer = [Float](repeating: 0,
                                        count: sampleCount)
    
// MARK: INIT
    override init() {
        super.init()
        fetchRecordings()
        getProcessedData()
        
        // Live Recording Setup
        // see AudioRecorderLive
        configureCaptureSession()
        audioOutput.setSampleBufferDelegate(self,
                                            queue: captureQueue)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func grantedPermission() -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        
        switch audioSession.recordPermission {
        case .granted:
            return true// User has granted permission to record audio
        case .denied:
            return false// User has denied permission to record audio
        case .undetermined:
            var ret = false
            // User has not yet been asked for permission to record audio
            audioSession.requestRecordPermission { granted in
                if granted {
                    ret = true// User has granted permission to record audio
                } else {
                    ret = false// User has denied permission to record audio
                }
            }
            return ret
        default:
            return false
        }
    }
    
    func setProcessedData(recording: Recording, metrics: [Double]) {
        self.processedData.append(MetricsModel(createdAt: recording.createdAt,
                                                duration: metrics[0],
                                                intensity: metrics[1],
                                                pitch_mean: metrics[2],
                                                pitch_min: metrics[3],
                                                pitch_max: metrics[4],
                                                cppMean: metrics[5],
                                                favorite: false))
    }
    
    func getProcessedData() {
        guard
            let data = UserDefaults.standard.data(forKey: processedDataKey),
            let savedItems = try? JSONDecoder().decode([MetricsModel].self, from: data)
        else { return }
        self.processedData = savedItems
    }
    
    func saveProcessedData() {
        if let encodedData = try? JSONEncoder().encode(processedData) {
            UserDefaults.standard.set(encodedData, forKey: processedDataKey)
        }
    }
    
    func returnProcessing(createdAt: Date) -> MetricsModel {
        var ret = MetricsModel(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false)
        for data in processedData {
            if createdAt == data.createdAt {
                ret = MetricsModel(createdAt: data.createdAt, duration: data.duration, intensity: data.intensity, pitch_mean: data.pitch_mean, pitch_min: data.pitch_min, pitch_max: data.pitch_max, cppMean: data.cppMean, favorite: false)
            }
        }
        return ret
    }
    
    /// Baseline for vowel
    func baselineVowel() -> MetricsModel {
        for index in recordings.indices {
            if recordings[index].taskNum == 1 {
                return processedData[index]
            }
        }
        
        return MetricsModel(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false)
    }
    
    /// Baseline for duration
    func baselineDuration() -> MetricsModel {
        for index in recordings.indices {
            if recordings[index].taskNum == 2 {
                return processedData[index]
            }
        }
        
        return MetricsModel(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false)
    }
    
    /// Baseline for rainbow
    func baselineRainbow() -> MetricsModel {
        for index in recordings.indices {
            if recordings[index].taskNum == 3 {
                return processedData[index]
            }
        }
        
        return MetricsModel(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false)
    }
    
    func startRecording(taskNum: Int) {
        var taskName = ""
        switch taskNum {
        case 1:
            taskName = "vowel"
        case 2:
            taskName = "MPT"
        case 3:
            taskName = "rainbow"
        default:
            taskName = ""
        }
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "MM-dd-YYYY_HH-mm-ss"))_\(taskName).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless), //Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.record()
                sessionQueue.async {
                    // CHANGESW
                    if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized {
                        self.captureSession.startRunning()
                    }
                }
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
    
    func process(recording rec: Recording, gender: String) {
        let group = DispatchGroup()
        let labelGroup = String("test")
        
        group.enter()
        
        let dispatchQueue = DispatchQueue(label: labelGroup, qos: .background)
        dispatchQueue.async(group: group, execute: {
            let metrics = self.signalProcess(fileURL: rec.fileURL, gender: gender)
            self.setProcessedData(recording: rec, metrics: metrics)
        })
        
        group.leave()
        group.notify(queue: DispatchQueue.main, execute: {
            print("Task completed!")
        })
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
    
    func returnFileURL(createdAt: Date) -> URL? {
        for record in recordings {
            if record.createdAt == createdAt {
                return record.fileURL
            }
        }
        return nil
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
        let taskString = String(file.lastPathComponent).suffix(5).prefix(1)
        
        switch taskString {
        case "l":
            taskNum = 1
        case "T":
            taskNum = 2
        case "w":
            taskNum = 3
        default:
            taskNum = 0
        }
        
        if selection == taskNum {
            return true
        } else {
            return false
        }
    }
    
    func taskNumToString(file: URL) -> String {
        let taskString = String(file.lastPathComponent).suffix(5).prefix(1)
        
        switch taskString {
        case "l":
            return "Vowel"
        case "T":
            return "Duration"
        case "w":
            return "Rainbow"
        default:
            return ""
        }
    }
    
    func uniqueDays() -> [Date] {
        var days: [Date] = []
        
        for record in recordings {
            days.append(record.createdAt.toDay().toDate() ?? . now)
        }
        
        return days.uniqued()
    }
    
    func deleteAllRecordings() {
        for record in recordings {
            do {
                try FileManager.default.removeItem(at: record.fileURL)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        processedData.removeAll()
        fetchRecordings()
        
        print("Number of files: \(recordings.count)")
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
    
    /// tasks
    /// 1 vowel
    /// 2 duration
    /// 3 rainbow
    func fileTask(file: URL!) -> String {
        var str = ""
        for record in recordings {
            if record.fileURL == file {
                str = record.fileURL.lastPathComponent.suffix(5).prefix(1) + ""
            }
        }
        switch str {
        case "l":
            return "1"
        case "T":
            return "2"
        case "w":
            return "3"
        default:
            return "1"
        }
    }
    
    func viewableTask(file: URL!) -> String {
        var str = ""
        for record in recordings {
            if record.fileURL == file {
                str = record.fileURL.lastPathComponent.suffix(5).prefix(1) + ""
            }
        }
        if str == "l" {
            return "Vowel"
        } else if str == "T" {
            return "Duration"
        } else if str == "w" {
            return "Rainbow"
        } else {
            return "Error"
        }
    }
    
    func taskNum(file: URL!) -> String {
        var str = ""
        for record in recordings {
            if record.fileURL == file {
                str = record.fileURL.lastPathComponent.suffix(5).prefix(1) + ""
            }
        }
        if str == "l" {
            return "Vowel"
        } else if str == "T" {
            return "MPT"
        } else if str == "w" {
            return "Rainbow"
        } else {
            return "Error"
        }
    }
    
    func recordingsThisWeek() -> Int {
        var ret = 0
        
        let startOfWeek: Date = .now.startOfWeek ?? .now
        for record in recordings {
            if record.createdAt > startOfWeek {
                ret += 1
            }
        }
        
        return ret
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
    
    func allFiles() -> [URL] {
        var returnable: [URL] = []
        
        for record in recordings {
            returnable.append( record.fileURL )
        }
        
        return returnable
    }
    
    func syncEntries(gender: String) {
        // Determine if the same amount, if not will further process
        
        if recordings.count != processedData.count {
            print("Mismatch in data\n\n\n")
            
            processedData.removeAll()
            
            for _ in 0..<recordings.count {
                self.processedData.append(MetricsModel(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false))
            }
            
            if recordings.count == processedData.count {
                for index in 0..<recordings.count {
                    let group = DispatchGroup()
                    let labelGroup = String("test")
                    
                    group.enter()
                    
                    let dispatchQueue = DispatchQueue(label: labelGroup, qos: .background)
                    dispatchQueue.async(group: group, execute: {
                        let metrics = self.signalProcess(fileURL: self.recordings[index].fileURL, gender: gender)
                        
                        self.processedData[index] = MetricsModel(createdAt: self.recordings[index].createdAt, duration: metrics[0], intensity: metrics[1], pitch_mean: metrics[2], pitch_min: metrics[3], pitch_max: metrics[4], cppMean: metrics[5], favorite: false)
                    })
                    
                    group.leave()
                    group.notify(queue: DispatchQueue.main, execute: {
                        print("Task completed!")
                        print("appended this: \(self.recordings[index].createdAt.toDebug())")
                    })
                    
                    //process(recording: recordings[index], gender: gender)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                
                print("Matched in count... checking each entry\n")
                
                var count = -1
                if self.recordings.isNotEmpty && self.processedData.isNotEmpty {
                    for index in 0..<self.recordings.count {
                        if self.recordings[index].createdAt.toStringDay() != self.processedData[index].createdAt.toStringDay() {
                            print("Error found, deleting and retrying")
                            count = 0
                        }
                        
                    }
                }
                
                if count == 0 {
                    print("failure")
                    
                    // reprocess
                    self.processedData.removeAll()
                    
                    for _ in 0..<self.recordings.count {
                        self.processedData.append(MetricsModel(createdAt: .now, duration: -1.0, intensity: -1.0, pitch_mean: -1.0, pitch_min: -1.0, pitch_max: -1.0, cppMean: -1.0, favorite: false))
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        print("delayed then ran")
                        
                        if self.recordings.count == self.processedData.count {
                            for index in 0..<self.recordings.count {
                                let group = DispatchGroup()
                                let labelGroup = String("test")
                                
                                group.enter()
                                
                                let dispatchQueue = DispatchQueue(label: labelGroup, qos: .background)
                                dispatchQueue.async(group: group, execute: {
                                    let metrics = self.signalProcess(fileURL: self.recordings[index].fileURL, gender: gender)
                                    
                                    self.processedData[index] = MetricsModel(createdAt: self.recordings[index].createdAt, duration: metrics[0], intensity: metrics[1], pitch_mean: metrics[2], pitch_min: metrics[3], pitch_max: metrics[4], cppMean: metrics[5], favorite: false)
                                })
                                
                                group.leave()
                                group.notify(queue: DispatchQueue.main, execute: {
                                    print("Task completed!")
                                    print("appended this: \(self.recordings[index].createdAt.toDebug())")
                                })
                                
                                //process(recording: recordings[index], gender: gender)
                            }
                        }
                    }
                    
                    
                    
                } else {
                    for index in 0..<self.recordings.count {
                        print("\(self.recordings[index].createdAt.toStringDay()) & \(self.processedData[index].createdAt.toStringDay())\n")
                    }
                }
                
            }
        }
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


//extension AudioRecorder
/*
 
 // Loop through recordings
 for record in recordings {
     /// 0 if no matches, 1 if a match
     var count = 0
     
     for process in processedData {
         
         // if there is a match change var to 1
         if record.createdAt == process.createdAt {
             
             count += 1
             print("match")
         }
     }
     
     // if there was a match on none of these then reprocess this file and add to proccessedData
     if count == 0 {
         print("Performed a reproccessing on this file: \(record.createdAt)")
         
         
         let processings = process(recording: record, gender: gender)
         saveProcessedData()
     }
 }
} else if processedData.count > recordings.count {
 print("Difference is: \(processedData.count) - \(recordings.count)")
 
 for index in 0..<recordings.count {
     if recordings[index].createdAt == processedData[index].createdAt {
         print("At index: \(index) there is a match")
     } else {
         print("At index: \(index) there is a mismatch")
     }
 }
}
 */
extension AudioRecorder {
    func processData(values: [Int16]) {
        vDSP.convertElements(of: values,
                             to: &timeDomainBuffer)
        
        vDSP.multiply(timeDomainBuffer,
                      hanningWindow,
                      result: &timeDomainBuffer)
        
        forwardDCT.transform(timeDomainBuffer,
                             result: &frequencyDomainBuffer)
        
        vDSP.absolute(frequencyDomainBuffer,
                      result: &frequencyDomainBuffer)

        vDSP.convert(amplitude: frequencyDomainBuffer,
                     toDecibels: &frequencyDomainBuffer,
                     zeroReference: Float(zeroReference))
        
        vDSP.multiply(Float(gain),
                      frequencyDomainBuffer,
                      result: &frequencyDomainBuffer)
        
        // TODOSW
        average = 10*(vDSP.maximum(frequencyDomainBuffer)-vDSP.minimum(frequencyDomainBuffer))
        
        if frequencyDomainValues.count > AudioRecorder.sampleCount {
            frequencyDomainValues.removeFirst(AudioRecorder.sampleCount)
        }
        
        frequencyDomainValues.append(contentsOf: frequencyDomainBuffer)
    }
    
}
