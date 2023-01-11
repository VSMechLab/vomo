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
        // Create AVAudioFile
        let audioFile = try! AVAudioFile(forReading: fileURL)
        
        // Read AVAudioFile properties
        let audioFormat = audioFile.processingFormat
        let audioSamplingRate = Float(audioFormat.sampleRate)
        let audioLengthSamples = Float(audioFile.length)
        
        // Initialize output vector
        let numMetrics: Int = 5
        var audioMetrics = Array<Float>(repeating: 0.0, count: numMetrics)
        
        // Define processing parameters
        let audioSegmentSize_sec: Float = 40e-3
        let overlapPercentage: Float = 0.90

        // Calculate the segment sizes needed for processing based off parameters
        let audioSegmentSize_samples = Int( floor( audioSegmentSize_sec * audioSamplingRate ) )
        let audioSegmentSize_overlap = Int( floor( Float(audioSegmentSize_samples) * overlapPercentage ) )

        // Calculate the start position offset and number of segments
        let newStartPositionOffset: Int = audioSegmentSize_samples - audioSegmentSize_overlap
        let numberOfSegments = Int( floor( (audioLengthSamples - Float(audioSegmentSize_samples)) / Float(newStartPositionOffset) ) + 1 )
        
        // For each recording, create an array of intensity values
        for record in recordings {
            if fileURL == record.fileURL {
                // Create array of floats for the values calculated and audio buffer
                var signalIntensityValues = Array<Float>(repeating: 0.0, count: numberOfSegments)
                var signalPitchValues = Array<Float>(repeating: 0.0, count: numberOfSegments)
                var buffer = AVAudioPCMBuffer()

                do {
                    buffer = try AVAudioPCMBuffer(url: fileURL)!
                }
                catch {
                    print("ERROR: Could not create buffer!")
                }

                // Call the getIntensity function for the recording's buffer
                signalIntensityValues = buffer.getIntensity(segmentSize: audioSegmentSize_samples,
                                                            startOffset: newStartPositionOffset,
                                                            segments: numberOfSegments)

                // Call the getPitch function for the recording's buffer
                signalPitchValues = buffer.getPitch(segmentSize: audioSegmentSize_samples,
                                                    startOffset: newStartPositionOffset,
                                                    segments: numberOfSegments,
                                                    sampRate: audioSamplingRate)

                // Create arrays with non-zero values only
                // for both intensity and pitch results
                var filteredIntensityValues = [Float]()
                var filteredPitchValues = [Float]()

                for idx in 0 ..< signalPitchValues.count {
                    if signalPitchValues[idx] != 0 {
                        filteredIntensityValues.append(signalIntensityValues[idx])
                        filteredPitchValues.append(signalPitchValues[idx])
                    }
                }

                // Call helper functions for metrics and save the values into the recording data model
                let dur: Float = calcDuration(filteredIntensityValues, audioSegmentSize_sec, overlapPercentage)
                let inten: Float = calcMeanIntensity(filteredIntensityValues)
                let meanP: Float = calcMeanPitch(filteredPitchValues)
                let minP: Float = calcMinPitch(filteredPitchValues)
                let maxP: Float = calcMaxPitch(filteredPitchValues)
                
                //processings.duration = dur
                //processings.intensity = inten
                //processings.pitch_mean = meanP
                //processings.pitch_min = minP
                //processings.pitch_max = maxP
                
                print("Duration: \(dur) s")
                print("Intensity: \(inten) dB")
                print("Mean Pitch: \(meanP) Hz")
                print("Min Pitch: \(minP) Hz")
                print("Max Pitch: \(maxP) Hz")

                // Return array of metrics
                audioMetrics = [dur, inten, meanP, minP, maxP]
            } // End if
        } // End for
        // Catch all
        
        return audioMetrics
    } // End fxn: signalProcess
    
    
    // Fxn: function to calculate phonation time (seconds)
    private func calcDuration(_ intensityArray: [Float],
                      _ segSize_sec: Float,
                      _ overlapPercentage: Float) -> Float {
        var duration: Float = 0.0
        let num_samples = Float(intensityArray.count)

        duration = num_samples * (segSize_sec * (1 - overlapPercentage))

        return duration
    } // End fxn: calcDuration
    
    // Fxn: function to calculate mean intensity (dB)
    private func calcMeanIntensity(_ intensityValues: [Float]) -> Float {
        var intensity: Float = 0.0
         
        // Take the mean of the pitch values, uses filtered array
        vDSP_meanv(intensityValues, 1, &intensity, vDSP_Length(intensityValues.count))

        return intensity
    } // End fxn: calcMeanIntensity
    
    // Fxn: function to calculate mean pitch (Hz)
    private func calcMeanPitch(_ pitchValues: [Float]) -> Float {
        var pitch_mean: Float = 0.0
         
        // Take the mean of the pitch values, uses filtered array
        vDSP_meanv(pitchValues, 1, &pitch_mean, vDSP_Length(pitchValues.count))

        return pitch_mean
    } // End fxn: calcMeanPitch
    
    // Fxn: function to calculate minimum pitch (Hz)
    private func calcMinPitch(_ pitchValues: [Float]) -> Float {
        var pitch_min: Float = 0.0

        // Take the min of the non-zero pitch values, uses filtered array
        let temp = pitchValues.filter( {$0 > 0.0} )
        vDSP_minv(temp, 1, &pitch_min, vDSP_Length(temp.count))

        return pitch_min
    } // End fxn: calcMinPitch
     
    // Fxn: function to calculate maximum pitch (Hz)
    private func calcMaxPitch(_ pitchValues: [Float]) -> Float {
        var pitch_max: Float = 0.0

        // Take the min of the pitch values, uses filtered array
        vDSP_maxv(pitchValues, 1, &pitch_max, vDSP_Length(pitchValues.count))

        return pitch_max
    } // End fxn: calcMaxPitch
}
