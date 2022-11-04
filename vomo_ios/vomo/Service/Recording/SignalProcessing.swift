//
//  SignalProcessing.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/12/22.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine
import UIKit
import Accelerate // CHANGED: imported for vector math
import AudioKit // CHANGED: also a package dependency
import AVFAudio

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
        for record in recordings {
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
                 
                 
                 print([dur, inten, meanP, minP, maxP])
                 
                 // Return array of metrics
                 return [dur, inten, meanP, minP, maxP]
             }// End if
         } //End for
         // Catch all
        
        
        print("got here2")
        
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
