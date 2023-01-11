//
//  AVAduioPCMBuffer.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/2/22.
//

import SwiftUI
import AVFoundation
import Combine
import UIKit
import Accelerate // CHANGED: imported for vector math
import AudioKit // CHANGED: also a package dependency
import AVFAudio


// Struct containing frequency and strength of pitch candidates
struct Candidates {
    var frequency: Float = 0.0
    var strength: Float = 0.0
}

// Struct containing pitch candidates, intensity, and num of candidates
// for a given analysis frame
struct pitchFrame {
    var nCandidates: Int = 1
    var candidates: [Candidates] = Array(repeating: Candidates(), count: 1)
    var Intensity: Float = 0.0
}

// Fxn: helper function to calculate the intensity of a segment
func calcSegmentIntensity(_ intensityArray: [Float]) -> Float {
    
    // Parameters
    let hearingThreshold_in_Pa: Float = 20e-6
    
    // Initialize window vector
    var window = Array<Float>(repeating: 0.0, count: intensityArray.count)
    
    // Create Hann window
    vDSP_hann_window(&window, vDSP_Length(intensityArray.count), Int32(vDSP_HANN_DENORM))

    // Apply window and compute sum of squared values of windowed signal
    let sumxw = vDSP.multiply(intensityArray, window).reduce(0, {x, y in x + y*y})
    
    // Compute sum of window
    let sumw = window.reduce(0, {x, y in x + y})
    
    // Compute intensity
    let intensity_in_Pa2: Float = sumxw / sumw
    
    // Return the rms intensity converted to dB SPL
    return 10 * log10f(intensity_in_Pa2 / powf(hearingThreshold_in_Pa, 2))
} // End fxn: calcSegmentIntensity

// Fxn: helper function to replicate MATLAB's linspace, must cast Array(return StrideThrough)
func linspace<T: BinaryFloatingPoint>(from start: T,
                                      through end: T,
                                      in samples: T) -> StrideThrough<T> where T == T.Stride {
    
    return Swift.stride(from: start, through: end, by:  (end - start) / T(samples-1))
} // End fxn: linspace

// Fxn: helper function to replicate MATLAB's xcorr
func xcorr(_ x: [Float],
           _ y: [Float],
           normalized norm: Bool) -> [Float] {

    // Initialize variables
    let resultSize = x.count
    var result = Array<Float>(repeating: 0.0, count: resultSize)
    
    // Create and apply zero padding
    let xPad = Array<Float>(repeating: 0.0, count: y.count - 1)
    let xPadded = x + xPad
    
    // Compute cross-correlation between xPadded and y
    vDSP_conv(xPadded, 1, y, 1, &result, 1,
              vDSP_Length(resultSize), vDSP_Length(y.count))
    
    // Normalize correlation (if applicable)
    if norm {
        var maxCorr = result.first ?? 1.0
        vDSP_vsdiv(result, 1, &maxCorr, &result, 1, vDSP_Length(resultSize))
    }
    
    return result
} // End fxn: xcorr

// Fxn: helper function to determine if candidates are voiced
func candidatesAreVoiced(pitchFrames frames: pitchFrame,
                         ceiling maxPitch: Float) -> Bool {

    for idx in 0 ..< frames.nCandidates {
        if (frequencyIsVoiced(frequency: frames.candidates[idx].frequency, ceiling: maxPitch)) {
            return true
        } else {
            continue
        }
    }
    
    return false
} // End fxn: candidatesAreVoiced

// Fxn: helper function to determine if frequency is voiced
func frequencyIsVoiced(frequency freq: Float,
                       ceiling maxPitch: Float) -> Bool {

    return (freq > 0.0 && freq < maxPitch) ? true : false
} // End fxn: frequencyIsVoiced

// Fxn: helper function to determine pitch path from candidates
func pitch_PathFinder(pitchFrame frames: [pitchFrame],
                      minimumPitch minPitch: Float,
                      ceiling maxPitch: Float) -> [Float] {
    
    // Parameters
    let silenceThreshold: Float = 0.03
    let voicingThreshold: Float = 0.45
    let octaveCost: Float = 0.01
    let octaveJumpCost: Float = 0.35
    let voicedUnvoicedCost: Float = 0.14
    
    // Initialize output frequency vector
    var f0_Hz = Array<Float>(repeating: 0.0, count: frames.count)
    
    for frameIdx in 0 ..< frames.count {
        var maximum: Float = 1e-30
        let pFrame: pitchFrame = frames[frameIdx]
        
        // Compute unvoiced strength threshold
        var unvoicedStrength: Float = (silenceThreshold <= 0) ? 0.0 :
            2.0 - (pFrame.Intensity / (silenceThreshold / (1.0 + voicingThreshold)))
        unvoicedStrength = voicingThreshold + max(0.0, unvoicedStrength)
        
        // Initial candidate, freq = 0 Hz
        f0_Hz[frameIdx] = pFrame.candidates[0].frequency
        
        if (frameIdx > 0) && (pFrame.nCandidates > 1) {
            var transitionCost = Array<Float>(repeating: 0.0, count: pFrame.nCandidates)
            
            // Determine if previous and current frame are voiceless or not
            let previousVoiceless: Bool = !frequencyIsVoiced(frequency: f0_Hz[frameIdx-1], ceiling: maxPitch)
            let currentVoiceless: Bool = !candidatesAreVoiced(pitchFrames: pFrame, ceiling: maxPitch)
            
            // Compute transition cost
            if currentVoiceless {
                if previousVoiceless {
                    transitionCost = Array<Float>(repeating: 0.0, count: pFrame.nCandidates)
                } else {
                    transitionCost = Array<Float>(repeating: voicedUnvoicedCost, count: pFrame.nCandidates)
                }
            } else {
                if previousVoiceless {
                    transitionCost = Array<Float>(repeating: voicedUnvoicedCost, count: pFrame.nCandidates)
                } else {
                    for idx in 0 ..< pFrame.nCandidates {
                        transitionCost[idx] = octaveJumpCost * abs(log2f(f0_Hz[frameIdx-1] / pFrame.candidates[idx].frequency))
                    }
                }
            }
            
            // Find candidate with maximum strength and add it to frequency output vector
            for candidate in 1 ..< pFrame.nCandidates {
                let localStrength = pFrame.candidates[candidate].strength -
                    transitionCost[candidate] - octaveCost * log2f(minPitch / pFrame.candidates[candidate].frequency)
                
                if (localStrength > unvoicedStrength) && (localStrength > maximum) &&
                    (frequencyIsVoiced(frequency: pFrame.candidates[candidate].frequency, ceiling: maxPitch)) {
                    maximum = localStrength
                    f0_Hz[frameIdx] = pFrame.candidates[candidate].frequency
                }
            }
        }
    }
    
    return f0_Hz
} // End fxn: pitch_PathFinder

// Fxn: helper function to replicate MATLAB's findpeaks
func findpeaks(_ readings: [Float],
               _ startI: Int,
               _ endI: Int) -> ([Float], [Int]) {
    var ascending = false
    var peaks: [Float] = []
    var peaks_idxs: [Float] = []
    
    var adjusted_readings: [Float] = []
    for i in startI...endI {
        adjusted_readings.append(readings[i])
    }
    
    if var last = adjusted_readings.first {
        adjusted_readings.enumerated().dropFirst().forEach {
            if last < $0.1 {
                ascending = true
            }
            if $0.1 <= last && ascending  {
                ascending = false
                peaks.append(last)
                peaks_idxs.append(Float($0.0 - 1))
            }
            last = $0.1
        }
    }
    
    // Offset enumerated indices in array to match overall readings array
    var pks_idxs: [Int] = []
    var offset = Float(startI)
    
    vDSP_vsadd(peaks_idxs, 1, &offset, &peaks_idxs, 1, vDSP_Length(peaks_idxs.count))
    peaks_idxs.forEach { pks_idxs.append(Int($0)) }
    
    // Return array of peak magnitudes and peak indices
    return (peaks, pks_idxs)
} // End fxn: findpeaks

// CHANGED: extended AVAudioPCMBuffer to calculate intensity
 extension AVAudioPCMBuffer {
     // CHANGED: new function to calculate the intensity on a signal's buffer
     public func getIntensity(segmentSize segmentSize_samples: Int,
                              startOffset startPositionOffset: Int,
                              segments numOfSegments: Int) -> [Float] {
         
         // Initialize intensity output vector
         var intensityValues = Array<Float>(repeating: -1.0, count: numOfSegments) // FIX: change anything named value
         
         // If guard fails, return vector with -1 values
         guard frameLength > 0 else { return intensityValues } // FIX: EXC_BAD_ACCESS error
         guard let floatData = floatChannelData else { return intensityValues }

         // Initialize parameters
         var posOffset: Int = 0
         let chunkLength: Int = segmentSize_samples
         let channelCount: Int = Int(format.channelCount)

         // Analysis per segment
         for segment in 0 ..< numOfSegments {
             intensityValues[segment] = 0.0
             
             // If more than one channel, sum intensity of all channels together
             for channel in 0 ..< channelCount {
                 var block = Array<Float>(repeating: 0.0, count: chunkLength)

                 // Fill the block with frameLength samples
                 for idx in 0 ..< block.count {
                     // If at the end of the buffer,
                     // leave remaining values at zero
                     if (posOffset + idx) >= frameLength {
                         break
                     }
                     
                     // Read buffer data
                     block[idx] = floatData[channel][posOffset + idx]
                 } // End for
                 
                 // Compute intensity for current segment
                 intensityValues[segment] += calcSegmentIntensity(block) // FIX: something is up with indexing
             } // End for
             // Increment the start position
             posOffset += startPositionOffset
         } // End for
         
         // Return array of intensity values
         return intensityValues
     } // End fxn, getIntensity

     // CHANGED: new function to calculate the pitch on a signal's buffer
     public func getPitch(segmentSize segmentSize_samples: Int,
                          startOffset startPositionOffset: Int,
                          segments numOfSegments: Int,
                          sampRate samplingRate: Float) -> [Float] {
         
         // Initialize pitch output vector
         var pitchValues = Array<Float>(repeating: -1.0, count: numOfSegments)
         
         // If guard fails, return vector with -1 values
         guard frameLength > 0 else { return pitchValues } // FIX: EXC_BAD_ACCESS error
         guard let floatData = floatChannelData else { return pitchValues }
         
         // Parameters
         let CHAN_MONO: Int = 0
         let f0_range_min: Float = 70.0
         let f0_range_max: Float = 500.0
         
         // Initialize parameters
         var globalPeak: Float = 0.0
         var mean: Float = 0.0
         var posOffset: Int = 0
         let chunkLength: Int = segmentSize_samples
         
         // Initialize vectors
         var pitchFrames = Array<pitchFrame>(repeating: pitchFrame(), count: numOfSegments)
         var frameValues = Array<Float>(repeating: 0.0, count: Int(frameLength))
         
         // Compute mean, and change sign
         vDSP_meanv(floatData[CHAN_MONO], 1, &mean, vDSP_Length(frameLength))
         mean = -mean
         
         // Substract mean from input signal and compute absolute value
         vDSP_vsadd(floatData[CHAN_MONO], 1, &mean, &frameValues, 1, vDSP_Length(frameLength))
         vDSP_vabs(frameValues, 1, &frameValues, 1, vDSP_Length(frameLength))
         
         // Find global peak
         vDSP_maxv(frameValues, 1, &globalPeak, vDSP_Length(frameLength))
         
         // Analysis per segment
         for segment in 0 ..< numOfSegments {
             var block = Array<Float>(repeating: 0.0, count: chunkLength)

             // Fill the block with frameLength samples
             for idx in 0 ..< block.count {
                 // If at the end of the buffer,
                 // leave remaining values at zero
                 if (posOffset + idx) >= frameLength {
                     break
                 }
                 
                 // Read buffer data
                 block[idx] = floatData[CHAN_MONO][posOffset + idx]
             } // End for
             
             // Compute pitch for current segment
             pitchFrames[segment] = getSegmentPitch(from: block,
                                                    segSize: segmentSize_samples,
                                                    sampRate: samplingRate,
                                                    minimumPitch: f0_range_min,
                                                    ceiling: f0_range_max,
                                                    globalPeak: globalPeak)

             // Increment the start position
             posOffset += startPositionOffset
         } // End for
         
         // Compute pitch values from candidates
         pitchValues = pitch_PathFinder(pitchFrame: pitchFrames,
                                        minimumPitch: f0_range_min,
                                        ceiling: f0_range_max)
         
         // Returns array of pitch values
         return pitchValues
     } // End fxn, getPitch

     // CHANGED: new private helper function to find the pitch value of the buffer segment
     private func getSegmentPitch_old(from block: [Float],
                                      segSize segmentSize: Int,
                                      sampRate samplingRate: Float) -> Float {
         
         let f0_range_min: Float = 75.0
         let f0_range_max: Float = 500.0
         let peakThreshold: Float = 0.6
         let autoCorrelationScalingMin: Float = 0.5
         
         var fs: Float = samplingRate
         var segSize: Float = Float(segmentSize)
         
         // Create the window for filtering input signal based on the window type
         var window = Array<Float>(repeating: 0.0, count: segmentSize)
         vDSP_hann_window(&window, vDSP_Length(segmentSize), Int32(vDSP_HANN_DENORM))
         
         // Apply filtering window to input signal
         let in_signal = vDSP.multiply(block, window)
         
         // Initialize vectors
         var ac_Sig = Array<Float>(repeating: 0.0, count: segmentSize)
         
         //let ac_Lags_s_D = Array<Double>(linspace(from: Double(0), through: Double(in_signal.count-1), in: Double(in_signal.count-1)))
         //var ac_Lags_s = Array<Float>(repeating: 0.0, count: in_signal.count)
         var ac_Lags_s = Array(Swift.stride(from: 0.0 as Float,
                                            through: segSize-1,
                                            by: 1.0))
         
         //let ac_Scaling_D = Array<Double>(linspace(from: 1.0, through: Double(autoCorrelationScalingMin), in: Double(segmentSize-1)))
         //var ac_Scaling = Array<Float>(repeating: 0.0, count: ac_Scaling_D.count)
         let ac_Scaling = Array(linspace(from: 1.0 as Float,
                                         through:autoCorrelationScalingMin,
                                         in: segSize))
         
         //vDSP_vdpsp(ac_Lags_s_D, 1, &ac_Lags_s, 1, vDSP_Length(ac_Lags_s.count))
         //vDSP_vdpsp(ac_Scaling_D, 1, &ac_Scaling, 1, vDSP_Length(ac_Scaling_D.count))
         vDSP_vsdiv(ac_Lags_s, 1, &fs, &ac_Lags_s, 1, vDSP_Length(ac_Lags_s.count))
         
         // Calculate auto-crrelation of window and normalize
         let padding = Array<Float>(repeating: 0.0, count: segmentSize)
         let padded_window = window + padding // Padded window = window w/ padding concatenated
         var ac_Win = vDSP.correlate(padded_window, withKernel: window)
         
         vDSP_vsdiv(ac_Win, 1, &segSize, &ac_Win, 1, vDSP_Length(ac_Win.count))
         
         // Define lag search range
         var lag_range_idx = Array<Int>(repeating: 0, count: 2)
         var max_found = false
         var min_found = false
         
         for idx in 0..<ac_Lags_s.count {
             if ac_Lags_s[idx] >= (1.0 / f0_range_max) && !min_found {
                 lag_range_idx[0] = idx
                 min_found = true
             }
             if ac_Lags_s[idx] > (1.0 / f0_range_min) && !max_found {
                 lag_range_idx[1] = idx - 1
                 max_found = true
             }
         }
         
         // Calculate auto-correlation of signal and normalize
         let padded_signal = in_signal + padding // FIX: same as above
         var ac_Sig_temp = vDSP.correlate(padded_signal, withKernel: in_signal)
         var scale = ac_Sig_temp.first!
         vDSP_vsdiv(ac_Sig_temp, 1, &scale, &ac_Sig_temp, 1, vDSP_Length(ac_Sig_temp.count))
         
         // Scale signal's corr by window's corr, and scale result to add more towards smaller lags
         let temp_div = vDSP.divide(ac_Sig_temp, ac_Win)
         ac_Sig = vDSP.multiply(temp_div, ac_Scaling)
         
         // Find peaks in search range
         let results = findpeaks(ac_Sig, lag_range_idx[0], lag_range_idx[1])
         let peaks_mag: [Float] = results.0 // Value of ac_Sig at that point
         let locs: [Int] = results.1 // Location of peaks
         
         // Filter out first 10 peaks with magnitude smaller than peak threshold
         let pk_mags = peaks_mag.filter({$0 > peakThreshold}).prefix(10)
         let peak_locs = peaks_mag.indices.filter( {peaks_mag[$0] > peakThreshold} ).prefix(10)
         
         // Calculate f0 based on location of peaks
         var ac_f0_hz: Float
         
         // If no peaks are above threshold, set f0 to 0 Hz
         if peak_locs.isEmpty {
             ac_f0_hz = 0
         }
         // Find first largest, if none found, use first peak as largest peak
         else {
             var max_index = 0
             
             if (peak_locs.count == 1) {
                 max_index = 0
             }
             else if (peak_locs.count == 2) {
                 if (pk_mags[1] > pk_mags[0]) { max_index = 1 }
                 else { max_index = 0 }
             }
             else { // 3+ elements
                 for peak_index in 1..<(peak_locs.count - 1) {
                     if ( pk_mags[peak_index] > pk_mags[peak_index-1] ) && ( pk_mags[peak_index] > pk_mags[peak_index+1] ) {
                     //if ( peaks_mag[ Int(peak_locs[peak_index]) ] > peaks_mag[ Int(peak_locs[peak_index-1]) ] ) &&
                            //( peaks_mag[ Int(peak_locs[peak_index]) ] > peaks_mag[ Int(peak_locs[peak_index+1]) ] ) {
                         max_index = peak_index
                     }
                 } // End for
             }
             
             // Calculate f0, in Hz, using largest peak of auto-correlation
             ac_f0_hz = Float(1) / ( ac_Lags_s[locs[Int(peak_locs[max_index])]] )
         } // end else
         
         // Returns the calculated peak in Hz for the section
         return ac_f0_hz
     } // End fxn, getSegmentPitch_old
     
     
     private func getSegmentPitch(from block: [Float],
                                  segSize segmentSize: Int,
                                  sampRate samplingRate: Float,
                                  minimumPitch minPitch: Float,
                                  ceiling maxPitch: Float,
                                  globalPeak globalPeak_: Float) -> pitchFrame {
         
         // Parameters
         let voicingThreshold: Float = 0.45
         let octaveCost: Float = 0.01
         let maxnCandidates = 15
         
         // Create local version of input arguments
         var fs: Float = samplingRate
         let segSize: Float = Float(segmentSize)
         
         // Define lag search range
         var lag_range_idx = Array<Int>(repeating: 0, count: 2)
         var max_found = false
         var min_found = false
         
         // Initialize parameters
         var localMean: Float = 0.0
         var localPeak: Float = 0.0
         var pitchFrame = pitchFrame()
         pitchFrame.nCandidates = 1
         
         // Initialize vectors
         var in_signal = Array<Float>(repeating: 0.0, count: segmentSize)
         var window = Array<Float>(repeating: 0.0, count: segmentSize)
         var ac_Win = Array<Float>(repeating: 0.0, count: segmentSize)
         var ac_Sig = Array<Float>(repeating: 0.0, count: segmentSize)
         var ac_Lags_s = Array(Swift.stride(from: 0.0 as Float,
                                            through: segSize-1,
                                            by: 1.0))
         vDSP_vsdiv(ac_Lags_s, 1, &fs, &ac_Lags_s, 1, vDSP_Length(ac_Lags_s.count))
         
         // Create a Hann window
         vDSP_hann_window(&window, vDSP_Length(segmentSize), Int32(vDSP_HANN_DENORM))
         
         // Compute local mean
         vDSP_meanv(block, 1, &localMean, vDSP_Length(segSize))
         localMean = -localMean
         
         // Substract mean and apply window to input signal
         vDSP_vsadd(block, 1, &localMean, &in_signal, 1, vDSP_Length(segSize))
         in_signal = vDSP.multiply(in_signal, window)
         
         // Compute frame intensity
         vDSP_maxv(in_signal, 1, &localPeak, vDSP_Length(segSize))
         pitchFrame.Intensity = (localPeak > globalPeak_) ? 1.0 : localPeak / globalPeak_
         
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
                 let freqMax = fs / (Float(idxLag) + (dr / d2r))
                 var strMax = ac_Sig[idxLag] + 0.8 * dr * dr / d2r
                 
                 if strMax > 1 {
                     strMax = 1 / strMax
                 }
                 
                 // Determine if current candidate should be added to the list
                 if pitchFrame.nCandidates < maxnCandidates {
                     pitchFrame.candidates.append(Candidates())
                     place = pitchFrame.nCandidates
                     pitchFrame.nCandidates += 1
                 } else {
                     var weakest: Float = 2.0
                     for iweak in 1 ..< maxnCandidates {
                         let localStrength = pitchFrame.candidates[iweak].strength -
                                             octaveCost * log2f(minPitch / pitchFrame.candidates[iweak].frequency)
                         if localStrength < weakest {
                             weakest = localStrength
                             place = iweak
                         }
                     }
                     
                     if (strMax - octaveCost * log2f(minPitch / freqMax)) <= weakest {
                         place = 0
                     }
                 }
                 
                 if (place != 0) {
                     pitchFrame.candidates[place].frequency = freqMax
                     pitchFrame.candidates[place].strength = strMax
                 }
             }
         }
         
         // Return pitchFrame with candidates
         return pitchFrame
     } // End fxn, getSegmentPitch
 }
