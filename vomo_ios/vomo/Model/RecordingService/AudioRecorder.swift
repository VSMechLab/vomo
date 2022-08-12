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

class AudioRecorder: NSObject,ObservableObject {
    
    var processings = Processings()
    
    override init() {
        super.init()
        fetchRecordings()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    /// Fix ToDo
    //var recordings = [Recording]()
    @Published var recordings = [Recording]()
    
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
        
        return Processings(duration: metrics[0], intensity: metrics[1], pitch_mean: 1.0, pitch_min: 1.0, pitch_max: 1.0)
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
    
    func fetchRecordings() {
        // Delete function was not working because fetchRecordings removes all and replaces 'recordings' with what is read from file
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        /*
         Within fetchRecordings we will run 2 checks.
         
         Check one reads the contents of directoryContents. It will match the contents with the recordings and ensure that all saved recordings exist
         Check two erases an entry recording if it is no longer present
         
         
         */
        
        for audio in directoryContents {
            /*
            let metrics = signalProcess(fileURL: audio)
            
            print("Duration: \(metrics[0]), from: \(directoryContents.count), from recording count: \(recordings.count)")
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio), duration: metrics[0], intensity: metrics[1], pitch_mean: 1.0, pitch_min: 1.0, pitch_max: 1.0)
            */
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
            days.append(record.createdAt.toStringDay().toDate() ?? . now)
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
     // NOTE: command to get into Kermit's vomo project folder
     // cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/VoMoApp/vomo
     
    func signalProcess(fileURL: URL!) -> Array<Float> {
        // Create AVAudioFile and extract some properties
        let audioFile = try! AVAudioFile(forReading: fileURL)
        let audioFormat = audioFile.processingFormat
        let audioSamplingRate = Float(audioFormat.sampleRate)
        let audioLengthSamples = Float(audioFile.length)

        // Define processing parameters
        let audioSegmentSize_sec: Float = 40e-3
        let overlapPercentage: Float = 0.90

        // Calculate the segment sizes needed for processing based off parameters
        let audioSegmentSize_samples = Int(floor(audioSegmentSize_sec * audioSamplingRate))
        let audioSegmentSize_overlap = Int(floor(Float(audioSegmentSize_samples) * overlapPercentage))

        // Calculate the start position offset and number of extensions
        let newStartPositionOffset = audioSegmentSize_samples - audioSegmentSize_overlap
        let numberOfSegments = Int( floor( (audioLengthSamples - Float(audioSegmentSize_samples)) / Float(newStartPositionOffset) ) + 1 )

         // For each recording, create an array of intensity values
         for var record in recordings where !record.processed {
             if fileURL == record.fileURL {
                 // Create array of floats for the values calculated and audio buffer
                 var signalIntensityValues: [Float]
                 var signalPitchValues: [Float]
                 var buffer = AVAudioPCMBuffer()

                 do {
                     buffer = try AVAudioPCMBuffer(url: fileURL)!
                 }
                 catch {
                     print("ERROR: Could not create buffer!")
                 }

                 // Call the getIntensity function for the recording's buffer, returns unfiltered array
                 signalIntensityValues = buffer.getIntensity(segmentSize: audioSegmentSize_samples, startOffset: newStartPositionOffset, segments: numberOfSegments)!

                 // Call the getPitch function for the recording's buffer, returns unfiltered array
                 signalPitchValues = buffer.getPitch(segmentSize: audioSegmentSize_samples, startOffset: newStartPositionOffset, segments: numberOfSegments, sampRate: audioSamplingRate)!

                 // Determine noise level
                 var noise_level: Float = 0.0
                 vDSP_meanv(signalIntensityValues, 1, &noise_level, 10)
                 noise_level += 10
             
                 // Filter out all values above noise level into a new filtered array
                 var filteredIntensityValues = Array(repeating: Float(0), count: 1)
                 var filteredPitchValues = [Float(0)]
             
                 for iv in signalIntensityValues.startIndex..<signalIntensityValues.endIndex {
                     if signalIntensityValues[iv] > noise_level {
                         filteredIntensityValues.append(signalIntensityValues[iv])
                         filteredPitchValues.append(signalPitchValues[iv])
                     }
                 }

                 // Remove initial zero in filtered arrays
                 filteredIntensityValues.removeFirst()
                 filteredPitchValues.removeFirst()

                 // Call helper functions for metrics and save the values into the recording data model
                 let dur: Float = calcDuration(filteredIntensityValues, audioSegmentSize_sec, overlapPercentage)
                 processings.duration = dur
                 
                 let inten: Float = calcMeanIntensity(filteredIntensityValues)
                 processings.intensity = inten
                 
                 let meanP: Float = calcMeanPitch(filteredPitchValues)
                 processings.pitch_mean = meanP
                 
                 let minP: Float = calcMinPitch(filteredPitchValues)
                 processings.pitch_min = minP
                 
                 let maxP: Float = calcMaxPitch(filteredPitchValues)
                 processings.pitch_max = maxP
                 
                 // Change processing state to true
                 let proc = true
                 record.processed = proc
                 
                 // Return array of metrics
                 return [dur, inten, meanP, minP, maxP]
             }// End if
         } //End for
         // Catch all
         return [0.0, 0.0, 0.0, 0.0, 0.0]
     } // End fxn
    
     func calcDuration(_ intensityArray: [Float], _ segSize_sec: Float, _ overlapPercentage: Float) -> Float {
         var duration: Float = 0.0
         let num_samples = Float(intensityArray.count)

         duration = num_samples * (segSize_sec * (1 - overlapPercentage))

         return duration
     } // End fxn
     
     func calcMeanIntensity(_ intensityValues: [Float]) -> Float {
         var intensity: Float = 0.0

         // Take the mean of the pitch values, uses filtered array
         vDSP_meanv(intensityValues, 1, &intensity, vDSP_Length(intensityValues.count))

         return intensity
     } // End fxn
     
     func calcMeanPitch(_ pitchValues: [Float]) -> Float {
         var pitch_mean: Float = 0.0

         // Take the mean of the pitch values, uses filtered array
         vDSP_meanv(pitchValues, 1, &pitch_mean, vDSP_Length(pitchValues.count))

         return pitch_mean
     } // End fxn
     
     func calcMinPitch(_ pitchValues: [Float]) -> Float {
         var pitch_min: Float = 0.0

         // Take the min of the pitch values, uses filtered array
         vDSP_minv(pitchValues, 1, &pitch_min, vDSP_Length(pitchValues.count))

         return pitch_min
     } // End fxn
     
     func calcMaxPitch(_ pitchValues: [Float]) -> Float {
         var pitch_max: Float = 0.0

         // Take the min of the pitch values, uses filtered array
         vDSP_maxv(pitchValues, 1, &pitch_max, vDSP_Length(pitchValues.count))

         return pitch_max
     } // End fxn
 }

/// Signal process 2 does not return anything
/*
 func signalProcess2() -> Void {
     // For each recording, create an array of intensity values
     for var record in recordings where !record.processed {
         // Create AVAudioFile and extract some properties
         let audioFile = try! AVAudioFile(forReading: record.fileURL)
         let audioFormat = audioFile.processingFormat
         let audioSamplingRate = Float(audioFormat.sampleRate)
         let audioLengthSamples = Float(audioFile.length)

         // Define processing parameters
         let audioSegmentSize_sec: Float = 40e-3
         let overlapPercentage: Float = 0.90

         // Calculate the segment sizes needed for processing based off parameters
         let audioSegmentSize_samples = Int(floor(audioSegmentSize_sec * audioSamplingRate))
         let audioSegmentSize_overlap = Int(floor(Float(audioSegmentSize_samples) * overlapPercentage))

         // Calculate the start position offset and number of extensions
         let newStartPositionOffset = audioSegmentSize_samples - audioSegmentSize_overlap
         let numberOfSegments = Int( floor( (audioLengthSamples - Float(audioSegmentSize_samples)) / Float(newStartPositionOffset) ) + 1 )

         // Create array of floats for the values calculated and audio buffer
         var signalIntensityValues: [Float]
         var signalPitchValues: [Float]
         var buffer = AVAudioPCMBuffer()

         do {
             buffer = try AVAudioPCMBuffer(url: record.fileURL)!
         }
         
         catch {
             print("ERROR: Could not create buffer!")
         }

         // Call the getIntensity function for the recording's buffer, returns unfiltered array
         signalIntensityValues = buffer.getIntensity(segmentSize: audioSegmentSize_samples, startOffset: newStartPositionOffset, segments: numberOfSegments)!

         // Call the getPitch function for the recording's buffer, returns unfiltered array
         signalPitchValues = buffer.getPitch(segmentSize: audioSegmentSize_samples, startOffset: newStartPositionOffset, segments: numberOfSegments, sampRate: audioSamplingRate)!

         // Determine noise level
         var noise_level: Float = 0.0
         vDSP_meanv(signalIntensityValues, 1, &noise_level, 10)
         noise_level += 10

         // Filter out all values above noise level into a new filtered array
         var filteredIntensityValues = Array(repeating: Float(0), count: 1)
         var filteredPitchValues = [Float(0)]

         for iv in signalIntensityValues.startIndex..<signalIntensityValues.endIndex {
             if signalIntensityValues[iv] > noise_level {
                 filteredIntensityValues.append(signalIntensityValues[iv])
                 filteredPitchValues.append(signalPitchValues[iv])
             }
         }

         // Remove initial zero in filtered arrays
         filteredIntensityValues.removeFirst()
         filteredPitchValues.removeFirst()

         // Call helper functions for metrics and save the values into the recording data model
         let dur: Float = calcDuration(filteredIntensityValues, audioSegmentSize_sec, overlapPercentage)
         processings.duration = dur

         let inten: Float = calcMeanIntensity(filteredIntensityValues)
         processings.intensity = inten

         let meanP: Float = calcMeanPitch(filteredPitchValues)
         processings.pitch_mean = meanP

         let minP: Float = calcMinPitch(filteredPitchValues)
         processings.pitch_min = minP

         let maxP: Float = calcMaxPitch(filteredPitchValues)
         processings.pitch_max = maxP

         // Change processing state to true
         let proc = true
         record.processed = proc

     } //End for
 } // End fxn
 */

// Deleting urls
/*
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
 */
