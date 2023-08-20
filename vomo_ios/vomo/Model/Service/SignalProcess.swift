//
//  SignalProcess.swift
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
            _ = Float(audioFormat.sampleRate)
            _ = Float(audioFile.length)
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
                        Logging.signalProcessLog.error("Could not create buffer: \(error.localizedDescription)")
                    }

                    //["Other", "Genderqueer", "Non-binary", "Female", "Male"]
                    // Define minPitch based on gender
                    var minPitch, maxPitch: Double
                    
                    switch gender {
                    case "3":
                        minPitch = 90.0
                        maxPitch = 500.0
                    case "4":
                        minPitch = 60.0
                        maxPitch = 300.0
                    default:
                        minPitch = 60.0
                        maxPitch = 500.0
                    }
                    
                    // Call the getIntensity function for the recording's buffer
                    let signalIntensityValues = buffer.getIntensity(minimumPitch: minPitch)

                    // Call the getPitch function for the recording's buffer
                    let signalPitchValues = buffer.getPitch(minimumPitch: minPitch,
                                                        maximumPitch: maxPitch)

                    let (signalCPPValues, _) = buffer.getCPPS(minimumFrequency: minPitch,
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
                    
                    Logging.signalProcessLog.notice("""
                        Duration: \(dur) s
                        Intensity: \(inten) dB
                        Mean Pitch: \(meanP) Hz
                        Min Pitch: \(minP) Hz
                        Max Pitch: \(maxP) Hz
                    """)

                    // Return array of metrics
                    audioMetrics = [dur, inten, meanP, minP, maxP, meanCPP]
                } // End if
            } // End for
            // Catch all
        } catch {
            Logging.signalProcessLog.error("Processing failed: \(error.localizedDescription)")
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


extension AudioRecorder {
    // NOTE: command to get into Kermit's vomo project folder
    // cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/VoMoApp/vomo
    func signalProcessLive(values:[Int16], gender: String) -> Array<Double> {
        // Initialize output vector
        //let numMetrics: Int = 6
        //var audioMetrics = Array<Double>(repeating: 0.0, count: numMetrics)
        
        // Create AVAudioFile
        do {
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
            // Create array of floats for the values calculated and audio buffer
            //var signalIntensityValues = Array<Double>(repeating: 0.0, count: numberOfSegments)
            //var signalPitchValues = Array<Double>(repeating: 0.0, count: numberOfSegments)
            /*
             var valuesFloat = [Float](repeating: 0, count: values.count)
             vDSP_vflt16(values, 1, &valuesFloat, 1, vDSP_Length(values.count))
             let audioBuffer = valuesFloat.buffer()
             
             var bufferList = AudioBufferList(
             mNumberBuffers: 2,
             mBuffers: audioBuffer)
             
             let sampleRate = Double(AudioSpectrogram.sampleCount)
             let audioFormat = AVAudioFormat(
             commonFormat: AVAudioCommonFormat.pcmFormatFloat64,
             sampleRate: sampleRate,
             interleaved: false,
             channelLayout: AVAudioChannelLayout(
             layoutTag: kAudioChannelLayoutTag_Stereo
             )!
             )
             
             guard let pcmBuffer = AVAudioPCMBuffer(
             pcmFormat: audioFormat,
             bufferListNoCopy: &bufferList
             ) else {
             fatalError("pcmBuffer failed to construct")
             }
             */
            
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
            var floats = vDSP.integerToFloatingPoint(values, floatingPointType: Float.self)
            // Call the getIntensity function for the recording's buffer
            
            
            let dbReturn = getIntensity(floatChannelData:[floats],
                                        minimumPitch:minPitch,
                                        sampleRate:Double(AudioRecorder.sampleCount),
                                        frameLength:AudioRecorder.bufferCount)
            
            let pitchReturn = getPitch(floatChannelData:[floats],
                                       minimumPitch: minPitch,
                                       maximumPitch: maxPitch,
                                       sampleRate: Double(AudioRecorder.sampleCount),
                                       frameLength:AudioRecorder.bufferCount)
            /*
            // Below is massive hit to efficiency
            let (signalCPPValues, _) = getCPPS(floatChannelData: [floats],
                                               minimumFrequency: minPitch,
                                               timeStep: 0.002,
                                               preEmphasisFrequency: 50.0,
                                               quefrencyAvgWindow: 0.001,
                                               timeAvgWindow: 0.01,
                                               maximumFrequency: maxPitch,
                                               sampleRate: Double(AudioSpectrogram.sampleCount),
                                               frameLength: AudioSpectrogram.bufferCount
                                        )
            */
            return [vDSP.mean(dbReturn), vDSP.mean(pitchReturn)]//vDSP.mean(signalCPPValues)]
        }
    }
}

func getPitch(floatChannelData:[[Float]], minimumPitch pitchFloor: Double, maximumPitch ceiling: Double, sampleRate:Double, frameLength:Int) -> [Double] {
    
    // Read data from buffer
    let floatData = floatChannelData

    // Read format data
    let channelNumber: Int = 0
    let samplingRate: Double = sampleRate
    let numSamples: Int = frameLength
    
    // Analysis parameters
    let acScalingMin: Double = 0.1
    let segmentSize: Double = 3.0 / pitchFloor
    let timeStepSize: Double = 0.75 / pitchFloor
    let segmentSamples: Int = Int( floor(segmentSize * samplingRate) )
    let timeStepSamples: Int = Int( floor(timeStepSize * samplingRate) )
    
    var numSegments = Int( floor(Double(numSamples - segmentSamples) / Double(timeStepSamples)) ) + 1
    if (numSegments * timeStepSamples) < numSamples {
        numSegments += 1
    }
    
    // Initialize parameters
    var globalPeak: Double = 0.0
    var mean: Double = 0.0
    var posOffset: Int = 0
    
    // Initialize vectors
    var pitchValues = Array<Double>(repeating: -1.0, count: numSegments)
    var pitchFrames = Array<pitchFrame>(repeating: pitchFrame(), count: numSegments)
    var frameValues = Array<Double>(repeating: 0.0, count: numSamples)
    
    // Convert input signal to type Double
    vDSP_vspdp(floatData[channelNumber], 1, &frameValues, 1, vDSP_Length(numSamples))
     
    // Compute mean, and change sign
    vDSP_meanvD(frameValues, 1, &mean, vDSP_Length(numSamples))
    mean = -mean
     
    // Substract mean from input signal and compute absolute value
    vDSP_vsaddD(frameValues, 1, &mean, &frameValues, 1, vDSP_Length(numSamples))
    vDSP_vabsD(frameValues, 1, &frameValues, 1, vDSP_Length(numSamples))
     
    // Find global peak
    vDSP_maxvD(frameValues, 1, &globalPeak, vDSP_Length(numSamples))
     
    // Analysis per segment
    for segment in 0 ..< numSegments {
        var block = Array<Double>(repeating: 0.0, count: segmentSamples)

        // Fill the block with frameLength samples
        for idx in 0 ..< segmentSamples {
            // If at the end of the buffer,
            // leave remaining values at zero
            if (posOffset + idx) >= numSamples {
                break
            }
             
            // Read buffer data
            block[idx] = Double(floatData[channelNumber][posOffset + idx])
        } // End for
        
        // Compute pitch for current segment
        pitchFrames[segment] = getSegmentPitch(from: block,
                                               segSize: segmentSamples,
                                               sampRate: samplingRate,
                                               minimumPitch: pitchFloor,
                                               ceiling: ceiling,
                                               globalPeak: globalPeak,
                                               acScalingMin: acScalingMin)

        // Increment the start position
        posOffset += timeStepSamples
    } // End for
     
    // Compute pitch values from candidates
    pitchValues = pitch_PathFinder(pitchFrame: pitchFrames,
                                   minimumPitch: pitchFloor,
                                   ceiling: ceiling)
     
    // Returns array of pitch values
    return pitchValues
} // End fxn, getPitch

func getSegmentPitch(from block: [Double],
                             segSize segmentSize: Int,
                             sampRate samplingRate: Double,
                             minimumPitch minPitch: Double,
                             ceiling maxPitch: Double,
                             globalPeak globalPeakValue: Double,
                             acScalingMin acScaleMin: Double) -> pitchFrame {
     
    // Parameters
    let voicingThreshold: Double = 0.45
    let octaveCost: Double = 0.01
    let maxnCandidates = 15
    
    // Create local version of input arguments
    let segSize: Double = Double(segmentSize)
    var fs: Double = samplingRate
     
    // Define lag search range
    var lag_range_idx = Array<Int>(repeating: 0, count: 2)
    var max_found = false
    var min_found = false
     
    // Initialize parameters
    var localMean: Double = 0.0
    var localPeak: Double = 0.0
    var pitchFrame = pitchFrame()
    pitchFrame.nCandidates = 1
     
    // Initialize vectors
    let acScaling = Array<Double>(linspace(from: 1.0,
                                           to: acScaleMin,
                                           with: segSize))
    var in_signal = Array<Double>(repeating: 0.0, count: segmentSize)
    var window = Array<Double>(repeating: 0.0, count: segmentSize)
    var ac_Win = Array<Double>(repeating: 0.0, count: segmentSize)
    var ac_Sig = Array<Double>(repeating: 0.0, count: segmentSize)
    var ac_Lags_s = Array(Swift.stride(from: 0.0 as Double,
                                       through: segSize-1,
                                       by: 1.0))
    vDSP_vsdivD(ac_Lags_s, 1, &fs, &ac_Lags_s, 1, vDSP_Length(ac_Lags_s.count))
    
    // Create a Hann window
    DSP_createHann(windowLength: segmentSize,
                   window: &window)
    
    // Compute local mean
    vDSP_meanvD(block, 1, &localMean, vDSP_Length(segSize))
    localMean = -localMean
     
    // Substract mean and apply window to input signal
    vDSP_vsaddD(block, 1, &localMean, &in_signal, 1, vDSP_Length(segSize))
    in_signal = vDSP.multiply(in_signal, window)
     
    // Compute frame intensity
    vDSP_maxvD(in_signal.map{ abs($0) }, 1, &localPeak, vDSP_Length(segSize))
    pitchFrame.Intensity = (localPeak > globalPeakValue) ? 1.0 : localPeak / globalPeakValue
     
    // Compute lag search range
    for idx in 0 ..< ac_Lags_s.count {
        if ac_Lags_s[idx] >= (1.0 / maxPitch) && !min_found {
            lag_range_idx[0] = idx
            min_found = true
        }
        if ac_Lags_s[idx] > (1.0 / minPitch) && !max_found {
            lag_range_idx[1] = idx - 1
            max_found = true
        }
    }
     
    // Calculate normilized auto-crrelation of window
    ac_Win = xcorr(window, window, normalized: true)
    
    // Calculate normalized auto-correlation of input signal
    ac_Sig = xcorr(in_signal, in_signal, normalized: true)
    
    // Scale signal's correlation by window's correlation
    ac_Sig = vDSP.divide(ac_Sig, ac_Win)
     
    // Find peaks in search range and filter out
    // those with a magnitude smaller than half voicingThreshold
    for idxLag in 1 ... lag_range_idx[1] {
        if (ac_Sig[idxLag] > (0.5 * voicingThreshold)) &&
            (ac_Sig[idxLag] > ac_Sig[idxLag-1]) &&
            (ac_Sig[idxLag] >= ac_Sig[idxLag+1]) {
            var place: Int = 0
            
            let dr = 0.5 * (ac_Sig[idxLag+1] - ac_Sig[idxLag-1])
            let d2r = 2 * ac_Sig[idxLag] - ac_Sig[idxLag-1] - ac_Sig[idxLag+1]
            
            // Compute frequency and strength
            let freqMax = fs / (Double(idxLag) + (dr / d2r))
            var strMax = ac_Sig[idxLag] + 0.5 * dr * dr / d2r
             
            if strMax > 1 {
                strMax = 1 / strMax
            }
             
            // Determine if current candidate should be added to the list
            if pitchFrame.nCandidates < maxnCandidates {
                pitchFrame.candidates.append(Candidates())
                place = pitchFrame.nCandidates
                pitchFrame.nCandidates += 1
            } else {
                var weakest: Double = 2.0
                for iweak in 1 ..< maxnCandidates {
                    let localStrength = pitchFrame.candidates[iweak].strength -
                                        octaveCost * log2(minPitch / pitchFrame.candidates[iweak].frequency)
                    if localStrength < weakest {
                        weakest = localStrength
                        place = iweak
                    }
                }
                 
                if (strMax - octaveCost * log2(minPitch / freqMax)) <= weakest {
                    place = 0
                }
            }
             
            if (place != 0) {
                pitchFrame.candidates[place].frequency = freqMax
                pitchFrame.candidates[place].strength = strMax * acScaling[idxLag]
            }
        }
    }
     
    // Return pitchFrame with candidates
    return pitchFrame
} // End fxn, getSegmentPitch


func getIntensity(floatChannelData:[[Float]], minimumPitch pitchFloor: Double, sampleRate:Double, frameLength:Int) -> [Double] {
    
    // Read data from buffer
    let floatData = floatChannelData

    // Read format data
    let channelNumber: Int = 0
    let samplingRate: Double = sampleRate
    let numSamples: Int = frameLength
    
    // Analysis parameters
    let segmentSize: Double = 3.0 / pitchFloor
    let timeStepSize: Double = 0.75 / pitchFloor
    let segmentSamples: Int = Int( floor(segmentSize * samplingRate) )
    let timeStepSamples: Int = Int( floor(timeStepSize * samplingRate) )
    
    var posOffset: Int = 0
    var numSegments = Int( floor(Double(numSamples - segmentSamples) / Double(timeStepSamples)) ) + 1
    if (numSegments * timeStepSamples) < numSamples {
        numSegments += 1
    }
    
    // Initialize intensity output vector
    var intensityValues = Array<Double>(repeating: -1.0, count: numSegments)

    // Analysis per segment
    for segment in 0 ..< numSegments {
        // If more than one channel, sum intensity of all channels together
        var block = Array<Double>(repeating: 0.0, count: segmentSamples)

        // Fill the block with frameLength samples
        for idx in 0 ..< segmentSamples {
            // If at the end of the buffer,
            // leave remaining values at zero
            if (posOffset + idx) >= numSamples {
                break
            }
            
            // Read buffer data
            block[idx] = Double(floatData[channelNumber][posOffset + idx])
        } // End for
             
        // Compute intensity for current segment
        intensityValues[segment] = calcSegmentIntensity(block) // FIX: something is up with indexing
        
        // Move to next frame
        posOffset += timeStepSamples
    } // End for
     
    // Return array of intensity values
    return intensityValues
} // End fxn, getIntensity
