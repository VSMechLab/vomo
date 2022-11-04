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

// Fxn: helper function to calculate the intensity of a segment
func calcSegmentIntensity(_ intensityArray: [Float]) -> Float {
     var intensity_rms: Float = 0.0

     // Take the root mean square of the intensity values, uses filtered array
     vDSP_rmsqv(intensityArray, 1, &intensity_rms, vDSP_Length(intensityArray.count))

     // Return the rms intensity converted to dB SPL
     return 20 * log10f(intensity_rms / 20e-6)
 } // End fxn

// Fxn: helper function to replicate MATLAB's linspace
func linspace<T: BinaryFloatingPoint>(from start: T, through end: T, in samples: T) -> StrideThrough<T> where T == T.Stride {
    return Swift.stride(from: start, through: end, by:  (end - start) / T(samples))
} // End fxn

// Fxn: helper function to replicate MATLAB's findpeks
func findpeaks(_ readings: [Float], _ startI: Int, _ endI: Int) -> ([Float], [Int]) {
    var ascending = false
    var peaks: [Float] = []
    var peaks_idxs: [Int] = []
    
    // Possible solution??
    var adjusted_readings: [Float] = []
    for i in startI...endI {
        adjusted_readings.append(readings[i])
    }

    // FIX: how to track index? Parallel run of code below but for readings.indices or figur out how to keep offsetting index value to match actual or figure out how to offset array before doing code below
    
    if var last = adjusted_readings.first {
        adjusted_readings.enumerated().dropFirst().forEach {
            if last < $0.1 {
                ascending = true
            }
            if $0.1 < last && ascending  {
                ascending = false
                peaks.append(last)
                // FIX: I don't think logic below works bc I think it's chopping off elements at front so index will always be 0/1/something
                peaks_idxs.append($0.0)
                //peaks_idxs.append(adjusted_readings.firstIndex(where: {$0 < last && ascending} )!) // Idk if this logic checks out
            }
            last = $0.1
        }
    }
    return (peaks, peaks_idxs)
} // End fxn

// CHANGED: extended AVAudioPCMBuffer to calculate intensity
 extension AVAudioPCMBuffer {
     // CHANGED: new function to calculate the intensity on a signal's buffer
     public func getIntensity(segmentSize segmentSize_samples: Int, startOffset startPositionOffset: Int, segments numOfSegments: Int) -> [Float]? {
         guard frameLength > 0 else { return nil } // FIX: EXC_BAD_ACCESS error
         guard let floatData = floatChannelData else { return nil }

         var intensityValues = Array(repeating: Float(0), count: numOfSegments) // FIX: change anything named value
         var position = 0
         let chunkLength = segmentSize_samples
         let channelCount = Int(format.channelCount)

         for segment in 0 ..< intensityValues.count {
             var blockIntensity = Float(-10)

             for channel in 0 ..< channelCount {
                 var block = Array(repeating: Float(0), count: chunkLength)

                 // Fill the block with frameLength samples
                 for i in 0 ..< block.count {
                     if i + position >= frameLength {
                         break
                     }
                     block[i] = floatData[channel][i + position]
                 } // End for
                 
                 // Scan the block
                 blockIntensity = calcSegmentIntensity(block)


                 // Increment the start position
                 position += startPositionOffset
             } // End for
             
             intensityValues[segment] = Float(blockIntensity) // FIX: something is up with indexing
         } // End for
         
         // Return array of filtered intensity values, all values in array are above noise level
         return intensityValues
     } // End fxn, getIntensity

     // CHANGED: new function to calculate the pitch on a signal's buffer
     public func getPitch(segmentSize segmentSize_samples: Int, startOffset startPositionOffset: Int, segments numOfSegments: Int, sampRate samplingRate: Float) -> [Float]? {
         guard frameLength > 0 else { return nil } // FIX: EXC_BAD_ACCESS error
         guard let floatData = floatChannelData else { return nil }

         var pitchValues = Array(repeating: Float(0), count: numOfSegments)
         var position = 0
         let chunkLength = segmentSize_samples
         let channelCount = Int(format.channelCount)

         for segment in 0 ..< pitchValues.count {
             var blockPitch = Float(0)

             for channel in 0 ..< channelCount {
                 var block = Array(repeating: Float(0), count: chunkLength)

                 // Fill the block with frameLength samples
                 for i in 0 ..< block.count {
                     if i + position >= frameLength {
                         break
                     }
                     block[i] = floatData[channel][i + position]
                 } // End for
                 
                 // Scan the block
                 blockPitch = getSegmentPitch(from: block, segSize: segmentSize_samples, sampRate: samplingRate)

                 // Increment the start position
                 position += startPositionOffset
             } // End for
             
             pitchValues[segment] = Float(blockPitch)
         } // End for
         
         // Returns array of filtered pitch values
         return pitchValues
     } // End fxn, getPitch
     
     // CHANGED: new private helper function to find the pitch value of the buffer segment
     private func getSegmentPitch(from block: [Float], segSize segmentSize: Int, sampRate samplingRate: Float) -> Float {
//         return Float(0)
         // Initialize variables with defaults
         //let f0_range = [75, 500]
         let f0_range_min = 75
         let f0_range_max = 500
         let peakThreshold: Float = 0.75
         let autoCorrelationScalingMin = 0.5
         var fs = samplingRate
         
         // Create the window for filtering input signal based on the window type
         var window: [Float] = Array(repeating: 0, count: segmentSize)
         
         vDSP_hann_window(&window, vDSP_Length(segmentSize), Int32(vDSP_HANN_NORM))
         
         // Apply filtering window to input signal
         let in_signal = vDSP.multiply(block, window) //
         
         // Initialize vectors
         var ac_Sig = Array(repeating: Float(0), count: segmentSize)
         var ac_Lags_s = Array(repeating: Float(0), count: in_signal.count)
         //var ac_Lags_s_D = Array(linspace(from: Double(0), through: Double(in_signal.count-1), in: Double(in_signal.count)))
         //vDSP_vdpsp(ac_Lags_s_D, 1, &ac_Lags_s, 1, vDSP_Length(ac_Lags_s.count))
         vDSP_vsdiv(ac_Lags_s, 1, &fs, &ac_Lags_s, 1, vDSP_Length(in_signal.count)) // Element-wise division by scalar
         //var ac_Scaling = linspace(from: 1.0, through: autoCorrelationScalingMin, in: Double(segmentSize))
         let ac_Scaling_D = Array(linspace(from: 1.0, through: autoCorrelationScalingMin, in: Double(segmentSize-1)))
         
         // Calculate auto-crrelation of window
         let padding = Array(repeating: Float(0), count: segmentSize)
         let padded_window = window + padding // Padded window should be window with padding concatenated to the end
         let ac_Win = vDSP.correlate(padded_window, withKernel: window)
         
         // Define lag search range
         var lag_range_idx = Array(repeating: 0, count: 2)
         var max_found = false
         var min_found = false
         
         for i in 0..<ac_Lags_s.count {
             if ac_Lags_s[i] >= Float(1 / f0_range_max) && !min_found {
                 lag_range_idx[0] = Int(i)
                 min_found = true
             }
             if ac_Lags_s[i] > Float(1 / f0_range_min) && !max_found {
                 lag_range_idx[1] = Int(i - 1)
                 max_found = true
             }
         }
         print("One: \(lag_range_idx[0]), Two: \(lag_range_idx[1])")
         
         /*
          let hasLagRangeIndexes = ac_Lags_s.contains { lag in
             print("Lag value: \(lag)")
             if case (lag) >= (1/f0_range_max) {
                 lag_range_idx[0] = Float(index(ofAccessibilityElement: lag))
                 return true
             }
             else if case lag > (1/f0_range_min) {
                 lag_range_idx[1] = Float(index(ofAccessibilityElement: lag) - 1)
                 return true
             }
             else {
                 return false
             }
         }*/
         
             // Calculate auto-correlation of signal
            let padded_signal = in_signal + padding // FIX: same as above
         let ac_temp = vDSP.correlate(padded_signal, withKernel: in_signal)
         
            // Scale signal's auto-correlation by window's auto-correlation, and scale result to add more towards smaller lags
            let temp_div = vDSP.divide(ac_temp, ac_Win)
            //ac_Scaling = vDSP.multiply(temp_div, ac_Scaling)
            var ac_Scaling = Array(repeating: Float(0), count: ac_Scaling_D.count)
            vDSP_vdpsp(ac_Scaling_D, 1, &ac_Scaling, 1, vDSP_Length(ac_Scaling_D.count))
            ac_Sig = vDSP.multiply(temp_div, ac_Scaling)
         
            // Find peaks in search range
            let results = findpeaks(ac_Sig, lag_range_idx[0], lag_range_idx[1])
            let peaks_mag: [Float] = results.0 // Value of ac_Sig at that point
            let locs: [Int] = results.1 // Location of peaks
            
            
            
            // filter out peaks with magnitude smaller than peak threshold
            //var peak_loc = find(peaks_mag > peakThreshold, 10) // FIX: syntax, replace find fxn, find first 10 peaks > threshold
            let pk_mag = peaks_mag.filter({$0 > peakThreshold})
            let peak_locs = pk_mag.prefix(10)
         
         // Plan: filter peaks_mag > peakThreshold -> then remove items after index 9
         
         // To find the actual index of the peak in the in_signal, add offset of starting location of lag_range_index[1] to element index
         
         
         // Calculate f0 based on location of peaks
         var ac_f0_hz: Float
             
         if peak_locs.isEmpty {
             // If no peaks are above threshold, set f0 to 0 Hz
             ac_f0_hz = 0 // FIX: syntax
         }
         else {
             // Find first largest, if none found, use first peak as largest peak
             var max_index = 0
             
             for peak_index in 1...(peak_locs.count - 1) {
                 if ( peaks_mag[ Int(peak_locs[peak_index]) ] > peaks_mag[ Int(peak_locs[peak_index-1]) ] ) &&
                        ( peaks_mag[ Int(peak_locs[peak_index]) ] > peaks_mag[ Int(peak_locs[peak_index+1]) ] ) {
                     max_index = peak_index
                 }
             } // End for
             
             // Calculate f0, in Hz, using largest peak of auto-correlation
             ac_f0_hz = Float(1) / ( ac_Lags_s[Int(lag_range_idx[1] + locs[Int(peak_locs[max_index])])] )
         } // end else
         
         // Returns the calculated peak in Hz for the section
         return ac_f0_hz
          
         //return Float(0)
     } // End fxn, getSegmentPitch
 }
