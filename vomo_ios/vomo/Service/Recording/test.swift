//
//  test.swift
//  VoMo
//
//  Created by Neil McGrogan on 10/18/22.
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
    
    
}

/*
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
         let f0_range = [75, 500]
         let f0_range_min = 75
         let f0_range_max = 500
         let peakThreshold: Float = 0.75
         let autoCorrelationScalingMin = 0.5
         var fs = samplingRate
         
         // Create the window for filtering input signal based on the window type
         var window: [Float] = Array(repeating: 0, count: segmentSize)
         
         vDSP_hann_window(&window, vDSP_Length(segmentSize), Int32(vDSP_HANN_NORM))
         
         // Apply filtering window to input signal
         var in_signal = vDSP.multiply(block, window) // FIX: add new axis to window, element-wise multiplication check
         
         // Initialize output pitch vector
         var f0_Hz = Array(repeating: Float(0), count: segmentSize)
         
         // Initialize vectors
         var ac_Sig = Array(repeating: Float(0), count: segmentSize)
                //transpose(in_signal) / samplingRate // FIX: syntax, creating array with incremental numbers
         var ac_Lags_s = Array(repeating: Float(0), count: in_signal.count)
         vDSP_mtrans(in_signal, 1, &ac_Lags_s, 1, 1, vDSP_Length(in_signal.count)) // Matrix transpose
         vDSP_vsdiv(in_signal, 1, &fs, &ac_Lags_s, 1, vDSP_Length(in_signal.count)) // Element-wise division by scalar
         var ac_Scaling = linspace(from: 1.0, through: autoCorrelationScalingMin, in: Double(segmentSize))
         
         // Calculate auto-crrelation of window
         var padding = Array(repeating: Float(0), count: segmentSize-1)
         var padded_window = window + padding // Padded window should be window with padding concatenated to the end
         var ac_temp = vDSP.correlate(padded_window, withKernel: window)
         
         // Define lag search range
         var lag_range_idx = Array(repeating: Float(0), count: 2)
         //temp_results = filter(enumerate(ac_Lags_s), {(idx, elem) in elem > 0}) // Results format will be [(i1, el1), (i2, el2)]
         //     lag_range_idx[1] = find(ac_Lags_s >= (1/f0_range[2]), 1) // FIX: syntax, replace find, find first # >
         //     lag_range_idx[2] = find(ac_Lags_s > (1/f0_range[1]), 1) - 1 // FIX: syntax
         
         // FIX: rewrite... use for loop to check if exists at every element, if return true ten do min/max value set
         let hasLagRangeIndexes = ac_Lags_s.contains { lag in
             print("Lag value: \(lag)")
             if case (lag) >= (1/f0_range_max) {
                 lag_range_idx[1] = Float(index(ofAccessibilityElement: lag))
                 return true
             }
             else if case lag > (1/f0_range_min) {
                 lag_range_idx[2] = Float(index(ofAccessibilityElement: lag) - 1)
                 return true
             }
             else {
                 return false
             }
         }
         
         
             // Calculate auto-correlation of signal
             var padded_signal = in_signal + padding // FIX: same as above
             ac_temp = vDSP.correlate(padded_signal, withKernel: in_signal)
         
            // Scale signal's auto-correlation by window's auto-correlation, and scale result to add more towards smaller lags
            var temp_div = vDSP.divide(ac_temp, window)
            //ac_Sig = vDSP.multiply(temp_div, ac_Scaling)
         
            // Find peaks in search range
            var peaks_mag: Array<Float> // Value of ac_Sig at that point
            var locs: Array<Float> // Location of peaks
            [peaks_mag, locs] = findpeaks( ac_Sig(lag_range_idx[1]:lag_range_idx[2]) ) // FIX: syntax, replace findpeaks fxn
            
            
            // filter out peaks with magnitude smaller than peak threshold
            //var peak_loc = find(peaks_mag > peakThreshold, 10) // FIX: syntax, replace find fxn, find first 10 peaks > threshold
            var pk_mag = peaks_mag.filter({$0 > peakThreshold})
            var peak_locs = pk_mag.prefix(10)
         
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
                 if ( peaks_mag(peak_locs[peak_index]) > peaks_mag(peak_locs[peak_index-1]) ) &&
                        ( peaks_mag(peak_locs[peak_index]) > peaks_mag(peak_locs[peak_index+1]) ) { // FIX: syntax of arrays/matrices
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
*/
