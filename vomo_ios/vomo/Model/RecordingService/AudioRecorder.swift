//
//  AudioRecorder.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/26/22.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

class AudioRecorder: NSObject,ObservableObject {
    
    override init() {
        super.init()
        fetchRecordings()
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
            AVSampleRateKey: 12000,
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
    
    func fetchRecordings() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        objectWillChange.send(self)
    }
    
    func filterRecordingsDay(focus: Date) -> [Recording] {
        var filtered: [Recording] = []
        for day in recordings {
            if day.createdAt.toStringDay() == focus.toStringDay() {
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
            if day.createdAt.toStringDay() == focus.toStringDay() && standardLeft.suffix(5) == standardRight {
                filtered.append(day)
            }
        }
        return filtered
    }
    
    func uniqueDays() -> [Date] {
        var days: [Date] = []
        
        for record in recordings {
            days.append(record.createdAt.toStringDay().toDate() ?? . now)
        }
        
        return days.uniqued()
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        
        for url in urlsToDelete {
            print("deleted: \(url.lastPathComponent)")
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
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
            if day.toStringDay() == record.createdAt.toStringDay() {
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
}

extension AudioRecorder {
    func signalProcess(file: URL!) -> Int {
        /*
         x: ndarray
             Signal array
         n: int
             Number of data segments
         p: int
             Number of values to overlap
         opt: str
             Initial condition options. default sets the first `p` values to zero,
             while 'nodelay' begins filling the buffer immediately.
         */
        
        /*
        var x: [(Int, Int)] = []
        var n: Int = 0
        var p: Int = 0
        var opt: String = ""
        
        var pitch = AVAudioUnitTimePitch()
        */
        
        //AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:locationUrl]];
        
        for record in recordings {
            if file == record.fileURL {
                _ = AVAsset(url: record.fileURL)
                /*
                do {
                    _ = try AVAssetReader(asset: asset) as AVAssetReader
                    //print("Time in seconds: \(assetReader.timeRange)")
                    
                } catch {
                    print("error")
                }
                //AVAssetReader.timeRange
                if let firstTrack = asset.tracks.first {
                    print("bitrate: \(firstTrack.estimatedDataRate), for file: \(record.fileURL.lastPathComponent)")
                }
                */
                
                
                
                /*
                let url = NSBundle.mainBundle.URLForResource(String(contentsOf: record.fileURL), withExtension: "m4a")
                let file = try! AVAudioFile(forReading: url!)
                let format = AVAudioFormat(commonFormat: .PCMFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)

                let buf = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: 1024)
                try! file.readIntoBuffer(buf)

                // this makes a copy, you might not want that
                let floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData[0], count:Int(buf.frameLength)))
                
                print("floatArray \(floatArray)\n")
                */
            }
        }
        return 1
    }
}
