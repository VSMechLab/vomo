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
    func signalProcess(fileURL: URL!, gender: String) -> Array<Double> {
        // Initialize output vector
        let numMetrics: Int = 6
        var audioMetrics = Array<Double>(repeating: 0.0, count: numMetrics)
        
        // Create AVAudioFile
        do {
            let audioFile = try AVAudioFile(forReading: fileURL)
            // Use the audio file here
            
            // Read AVAudioFile properties
            let audioFormat = audioFile.processingFormat
            let audioSamplingRate = Float(audioFormat.sampleRate)
            let audioLengthSamples = Float(audioFile.length)
            /*
            // Define processing parameters
            let audioSegmentSize_sec: Double = 40e-3
            let overlapPercentage: Double = 0.90

            // Calculate the segment sizes needed for processing based off parameters
            let audioSegmentSize_samples = Int( floor( audioSegmentSize_sec * audioSamplingRate ) )
            let audioSegmentSize_overlap = Int( floor( Float(audioSegmentSize_samples) * overlapPercentage ) )

            // Calculate the start position offset and number of segments
            let newStartPositionOffset: Int = audioSegmentSize_samples - audioSegmentSize_overlap
            let numberOfSegments = Int( floor( (audioLengthSamples - Float(audioSegmentSize_samples)) / Float(newStartPositionOffset) ) + 1 )
            */
            // For each recording, create an array of intensity values
            for record in recordings {
                if fileURL == record.fileURL {
                    // Create array of floats for the values calculated and audio buffer
                    //var signalIntensityValues = Array<Double>(repeating: 0.0, count: numberOfSegments)
                    //var signalPitchValues = Array<Double>(repeating: 0.0, count: numberOfSegments)
                    var buffer = AVAudioPCMBuffer()

                    do {
                        buffer = try AVAudioPCMBuffer(url: fileURL)!
                    }
                    catch {
                        print("ERROR: Could not create buffer!")
                    }

                    //["Other", "Genderqueer", "Non-binary", "Female", "Male"]
                    // Define minPitch based on gender
                    var minPitch, maxPitch: Double
                    if gender == "3" {
                        minPitch = 90.0
                        maxPitch = 500.0
                    } else if gender == "4" {
                        minPitch = 60.0
                        maxPitch = 300.0
                    } else {
                        minPitch = 60.0
                        maxPitch = 500.0
                    }
                    
                    // Call the getIntensity function for the recording's buffer
                    let signalIntensityValues = buffer.getIntensity(minimumPitch: minPitch)

                    // Call the getPitch function for the recording's buffer
                    let signalPitchValues = buffer.getPitch(minimumPitch: minPitch,
                                                        maximumPitch: maxPitch)

                    let (signalCPPValues, signalCPP_f0Values) = buffer.getCPPS(minimumFrequency: minPitch,
                                                                           timeStep: 0.002,
                                                                           preEmphasisFrequency: 50.0,
                                                                           quefrencyAvgWindow: 0.001,
                                                                           timeAvgWindow: 0.01,
                                                                           maximumFrequency: maxPitch)
                    
                    /*
                    // Call the getIntensity function for the recording's buffer
                    signalIntensityValues = buffer.getIntensity(segmentSize: audioSegmentSize_samples,
                                                                startOffset: newStartPositionOffset,
                                                                segments: numberOfSegments)

                    // Call the getPitch function for the recording's buffer
                    signalPitchValues = buffer.getPitch(segmentSize: audioSegmentSize_samples,
                                                        startOffset: newStartPositionOffset,
                                                        segments: numberOfSegments,
                                                        sampRate: audioSamplingRate)*/

                    // Create arrays with non-zero values only
                    // for both intensity and pitch results
                    var filteredIntensityValues = [Double]()
                    var filteredPitchValues = [Double]()

                    for idx in 0 ..< signalPitchValues.count {
                        if signalPitchValues[idx] != 0 {
                            filteredIntensityValues.append(signalIntensityValues[idx])
                            filteredPitchValues.append(signalPitchValues[idx])
                        }
                    }
                    
                    // Call helper functions for metrics and save the values into the recording data model
                    let dur: Double = calcDuration(signalPitchValues, minPitch)
                    let inten: Double = calcMean(filteredIntensityValues)
                    let meanP: Double = calcMean(filteredPitchValues)
                    let minP: Double = calcMin(filteredPitchValues)
                    let maxP: Double = calcMax(filteredPitchValues)
                    let meanCPP: Double = calcMean(signalCPPValues)

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
                    audioMetrics = [dur, inten, meanP, minP, maxP, meanCPP]
                } // End if
            } // End for
            // Catch all
        } catch {
            print("testing\n\n\\n\ntesting")
            print("Error: \(error)")
            // Handle the error in some way (e.g. show an error message to the user)
        }
        return audioMetrics
    } // End fxn: signalProcess
    
    // Fxn: function to calculate mean pitch (Hz)
    private func calcMean(_ x: [Float]) -> Float {
        var x_mean: Float = 0.0
        
        // Take the mean of the pitch values, uses filtered array
        vDSP_meanv(x, 1, &x_mean, vDSP_Length(x.count))
        return x_mean.isNaN ? 0.0 : x_mean.isInfinite ? 0.0 : x_mean
    } // End fxn: calcMeanPitch
    
    // Fxn: function to calculate mean pitch (Hz)
    private func calcMean(_ x: [Double]) -> Double {
        var meanValue: Double = 0.0
        
        // Take the mean of the pitch values, uses filtered array
        vDSP_meanvD(x, 1, &meanValue, vDSP_Length(x.count))
        
        return meanValue.isNaN ? 0.0 : meanValue.isInfinite ? 0.0 : meanValue
        
    } // End fxn: calcMeanPitch
    
    private func calcMin(_ x: [Double]) -> Double {
        var minValue: Double = 0.0
        
        vDSP_minvD(x, 1, &minValue, vDSP_Length(x.count))
        
        return minValue.isNaN ? 0.0 : minValue.isInfinite ? 0.0 : minValue
    }
    
    private func calcMax(_ x: [Double]) -> Double {
        var maxValue: Double = 0.0
        
        vDSP_maxvD(x, 1, &maxValue, vDSP_Length(x.count))
        
        return maxValue.isNaN ? 0.0 : maxValue.isInfinite ? 0.0 : maxValue
        
    }
    
    private func calcDuration(_ x: [Double],  _ pitchFloor: Double) -> Double {
        var voicedFrames: Int = 0
        var silenceFrames: Int = 0
        let segmentSize: Double = 3.0 / pitchFloor
        let timeStepSize: Double = 0.75 / pitchFloor
        let thresholdFrames: Int = Int(floor(0.150 / timeStepSize))
        
        for idx in 0 ..< x.count {
            if x[idx] == 0.0 {
                silenceFrames += 1
            }
            
            if x[idx] > 0.0 {
                voicedFrames += 1
                if silenceFrames < thresholdFrames {
                    voicedFrames += silenceFrames
                }
                silenceFrames = 0
                
            }
            
        }
        
        return voicedFrames > 0 ? (segmentSize + Double(voicedFrames - 1) * timeStepSize) : 0.0
    }
}
