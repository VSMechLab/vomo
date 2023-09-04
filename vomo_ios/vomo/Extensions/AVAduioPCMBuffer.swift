//
//  AVAduioPCMBuffer.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/2/22.
//

import Foundation
import AVFoundation
import Accelerate

// Struct to store complex numbers
struct Complex {
    var count: Int
    var real: [Double]
    var imag: [Double]
    
    init(length: Int) {
        self.real = Array<Double>(repeating: 0.0, count: length)
        self.imag = Array<Double>(repeating: 0.0, count: length)
        self.count = length
    }
    
    init(real: [Double], imag: [Double]) {
        self.real = real
        self.imag = imag
        self.count = real.count
    }
}

// Struct containing frequency and
// strength of pitch candidates
struct Candidates {
    var frequency: Double = 0.0
    var strength: Double = 0.0
}

// Struct containing pitch candidates,
// intensity, and num of candidates
// for a given analysis frame
struct pitchFrame {
    var nCandidates: Int = 1
    var candidates: [Candidates] = Array(repeating: Candidates(), count: 1)
    var Intensity: Double = 0.0
}

// Fxn: helper function to perform pre-emphasis
func DSP_preEmphasis(signal x: [Double],
                     preEmphasisFrequency fc: Double,
                     samplingFrequency fs: Double,
                     output out: inout [Double]) {
    
    let preEmphasis: Double = exp( -2.0 * Double.pi * fc / fs)
    
    out = x
    for idx in (1 ..< x.count).reversed() {
        out[idx] -= preEmphasis * out[idx - 1]
    }
} // End fxn: DSP_preEmphasis

// Fxn: helper function to perform an anti-aliasing filter
// at half Nyquist frequency
func DSP_antialiasingFilter(signal x: [Double],
                            output out: inout [Double]) {
    
    let alpha: Double = sqrt(2.0) / 2
    let b0: Double = 0.5 / (1 + alpha)
    let b1: Double = 1 / (1 + alpha)
    let b2: Double = b0;
    let a1: Double = 0.0
    let a2: Double = (1 - alpha) / (1 + alpha)
    
    var z1 = 0.0, z2 = 0.0
    
    for idx in 0 ..< x.count {
        out[idx] = b0 * x[idx] + z1
        z1 = z2 + b1 * x[idx] - a1 * out[idx]
        z2 = b2 * x[idx] - a2 * out[idx]
    }
}

func DSP_createHann(windowLength winLen: Int,
                    window out: inout [Double]) {
    
    for idx in 0 ..< winLen {
        out[idx] = 0.5 - 0.5 * cos( 2 * Double.pi * Double(idx) / Double(winLen-1))
    }
}

// Fxn: helper function to create a Gaussian window
func DSP_createGaussian(windowLength winLen: Int,
                        window out: inout [Double]) {
    
    let imid: Double = 0.5 * (Double(winLen) - 1.0)
    let edge: Double = exp( -12.0 )
    
    for idx in 0 ..< winLen {
        let diff: Double = Double(idx) - imid
        out[idx] = (exp(-48.0 * diff * diff / imid / imid / 4.0) - edge) / (1.0 - edge)
    }
} // End fxn: DSP_createGaussian

// Fxn: helper function to compute DFT
func DSP_computeDFT(signal x: [Double],
                    nfft n: Int,
                    dft out: inout Complex) {
    
    // Input signal is real, imaginary part is zero
    var splitInputReal: [Double]
    let splitInputImag: [Double] = Array<Double>(repeating: 0.0, count: n)
    
    // Crop or do zero-padding as needed
    if (x.count > n) {
        splitInputReal = Array( x[0...n] )
    } else {
        splitInputReal = x
        if (x.count < n) {
            splitInputReal.append(contentsOf: Array<Double>(repeating: 0.0, count: n - x.count))
        }
    }
    
    // Compute DFT
    if let splitComplexSetup = vDSP_DFT_zop_CreateSetupD(nil,
                                                         vDSP_Length(n),
                                                         .FORWARD) {
        vDSP_DFT_ExecuteD(splitComplexSetup,
                          splitInputReal, splitInputImag,
                          &out.real, &out.imag)
        
        vDSP_DFT_DestroySetupD(splitComplexSetup)
    }
} // End fxn: DSP_computeDFT

// Fxn: helper function to compute inverse DFT
func DSP_computeIDFT(signal x: Complex,
                     nfft n: Int,
                     idft out: inout Complex) {
    
    // Initialize input split complex vector for DFT function
    var splitInputReal: [Double]
    var splitInputImag: [Double]
    
    // Crop or do zero-padding as needed
    if (x.count > n) {
        splitInputReal = Array( x.real[0 ..< n] )
        splitInputImag = Array( x.imag[0 ..< n] )
    } else {
        splitInputReal = x.real
        splitInputImag = x.imag
        if (x.count < n) {
            splitInputReal.append(contentsOf: Array<Double>(repeating: 0.0, count: n - x.count))
            splitInputImag.append(contentsOf: Array<Double>(repeating: 0.0, count: n - x.count))
        }
    }
    
    // Compute inverse DFT
    if let splitComplexSetup = vDSP_DFT_zop_CreateSetupD(nil,
                                                         vDSP_Length(n),
                                                         .INVERSE) {
        vDSP_DFT_ExecuteD(splitComplexSetup,
                          splitInputReal, splitInputImag,
                          &out.real, &out.imag)
        
        vDSP_DFT_DestroySetupD(splitComplexSetup)
    }
} // End fxn: DSP_computeIDFT

// Fxn: helper function to compute spectrum
func DSP_getSpectrum(signal x: [Double],
                     fftPoints nfft: Int,
                     samplingFrequency fs: Double,
                     spectrum out: inout Complex) {
    
    // Compute parameters
    let dx: Double = 1.0 / fs
    var scaling: Double = dx
    
    // Compute DFT
    DSP_computeDFT(signal: x,
                   nfft: nfft,
                   dft: &out)
    
    // Scale DFT
    vDSP_vsmulD(out.real, 1, &scaling, &out.real, 1, vDSP_Length(nfft))
    vDSP_vsmulD(out.imag, 1, &scaling, &out.imag, 1, vDSP_Length(nfft))
} // End fxn: DSP_getSpectrum

// Fxn: helper function to compute the power cepstrum
func DSP_getPowerCepstrum(spectrum x: Complex,
                          samplingFrequency fs: Double,
                          powerCepstrum out: inout [Double]) {
    
    // Compute parameters
    let nx: Int = x.count
    let dx: Double = 1.0 / fs
    var scaling: Double = 1.0 / (dx * Double(nx))
    
    // Initialize vectors
    var cepstrum: Complex = Complex(length: nx)
    
    // Compute log of spectrum
    for idx in 0 ..< nx {
        cepstrum.real[idx] = log(x.real[idx] * x.real[idx] + x.imag[idx] * x.imag[idx] + 1e-30)
        cepstrum.imag[idx] = 0.0
    }
    
    // Compute cepstrum using inverse DFT
    DSP_computeIDFT(signal: cepstrum,
                    nfft: nx,
                    idft: &cepstrum)
    
    // Scale cepstrum
    vDSP_vsmulD(cepstrum.real, 1, &scaling, &cepstrum.real, 1, vDSP_Length(cepstrum.real.count))
    vDSP_vsmulD(cepstrum.imag, 1, &scaling, &cepstrum.imag, 1, vDSP_Length(cepstrum.imag.count))
    
    // Compute Power Cepstrum
    for idx in 0 ..< nx {
        out[idx] = cepstrum.real[idx] * cepstrum.real[idx]
    }
} // End fxn: DSP_getPowerCepstrum

// Fxn: helper function to compute the power Cepstrogram
func DSP_getPowerCepstrogram(signal x: [Double],
                             minimumFrequency pitchFloor: Double,
                             timeStep dt: Double,
                             samplingFrequency fs: Double,
                             numFrames numberOfSegments: inout Int) -> [[Double]]{
    
    let analysisWidth: Double = 3.0 / pitchFloor
    let windowDuration: Double = 2.0 * analysisWidth
    let durationSamples: Int = Int( floor(windowDuration * fs) )
    let timeStepSamples: Int = Int( floor(dt * fs) )
    let nfft = Int( pow(2.0, ceil(log2(Double(durationSamples)))) )
    
    numberOfSegments = Int( floor(Double(x.count - durationSamples) / Double(timeStepSamples)) ) + 1
    if (numberOfSegments * timeStepSamples) < x.count {
        numberOfSegments += 1
    }
    
    var offset: Int = 0
    var meanValue: Double = 0.0
                                    
    var sframe = Array<Double>()
    var window = Array<Double>(repeating: 0.0, count: durationSamples)
    var spectrum = Complex(length: nfft)
    var cepstrum = Array<Double>(repeating: 0.0, count: nfft)
    var out = Array<[Double]>(repeating: Array<Double>(repeating: 0.0, count: nfft / 2), count: numberOfSegments)
    
    DSP_createGaussian(windowLength: durationSamples,
                       window: &window)
    
    for segment in 0 ..< numberOfSegments {
        // Get frame
        if (offset + durationSamples) >= x.count {
            sframe = Array(x[offset ..< x.count])
            sframe += Array<Double>(repeating: 0.0, count: durationSamples-sframe.count)
        } else {
            sframe = Array(x[offset ..< offset+durationSamples])
        }
        
        // Remove mean value from frame
        vDSP_meanvD(sframe, 1, &meanValue, vDSP_Length(durationSamples))
        meanValue = -meanValue
        vDSP_vsaddD(sframe, 1, &meanValue, &sframe, 1, vDSP_Length(durationSamples))
        
        // Multiply frame by window
        vDSP_vmulD(sframe, 1, window, 1, &sframe, 1, vDSP_Length(durationSamples))
        
        // Compute spectrum
        DSP_getSpectrum(signal: sframe,
                        fftPoints: nfft,
                        samplingFrequency: fs,
                        spectrum: &spectrum)
        
        // Compute power cepstrum
        DSP_getPowerCepstrum(spectrum: spectrum,
                             samplingFrequency: fs,
                             powerCepstrum: &cepstrum)
        
        // Store half cepstrum in output
        out[segment] = Array(cepstrum[0 ..< (nfft / 2)])
        
        // Increase offset to move to next segment
        offset += timeStepSamples
    }
    
    return out
} // End fxn: DSP_getPowerCepstrogram

// Fxn: helper function to compute Cepstral Peak Prominence (CPPS)
func DSP_getCPPS(powerCepstrogram x: Array<[Double]>,
                 quefrencyAvgWindow quefWin: Double,
                 timeAvgWindow timeWin: Double,
                 timeStep dx: Double,
                 samplingFrequency fs: Double,
                 minimumFrequency minPitch: Double,
                 ceiling maxPitch: Double,
                 cpps cpp: inout [Double],
                 cpp_f0 f0: inout [Double]) {
    
    let nx: Int = x.count
    let nq: Int = x[0].count
    let numFrames: Double = round(timeWin / dx)
    let numQuefBins: Double = round(quefWin / (1 / fs))
    let time_win: Int = Int(floor((numFrames - 1) / 2))
    let quef_win: Int = Int(floor((numQuefBins - 1) / 2))
    
    var x_Tsmooth = Array<[Double]>(repeating: Array<Double>(repeating: 0.0, count: nq), count: nx)
    var x_Qsmooth = Array<[Double]>(repeating: Array<Double>(repeating: 0.0, count: nq), count: nx)
    var x_Slice = Array<Double>(repeating: 0.0, count: Int(numFrames))
    
    // Create quefrency vector
    let range = 0 ..< nq
    let quefrencyRange = range.map{ Double($0) / fs }
    
    // CPP search range
    var cppSearchRangeStartIdx: Int = quefrencyRange.indices.first(where: { quefrencyRange[$0] >= (1 / maxPitch) })!
    var cppSearchRangeEndIdx: Int = quefrencyRange.indices.last(where: { quefrencyRange[$0] <= (1 / minPitch) })!
    
    // Trend line quefrency range
    let quefStart = 0.001
    let quefEnd = quefrencyRange.last!
    let quefStartIdx: Int = quefrencyRange.indices.first(where:{ quefrencyRange[$0] >= quefStart })!
    let quefEndIdx: Int = quefrencyRange.indices.last(where: { quefrencyRange[$0] <= quefEnd})!
    var trendLine = Array<Double>()
    
    // Time smoothing
    for idx in 0 ..< nq {
        for time_idx in 0 ..< nx {
            var imin = time_idx - time_win
            var imax = time_idx + time_win
            
            if imin < 0 {
                imin = 0
            }
            if imax > (nx-1) {
                imax = nx-1
            }
            
            for ii in 0 ..< (imax-imin+1) {
                x_Slice[ii] = x[imin+ii][idx]
            }
            
            vDSP_meanvD(x_Slice, 1, &x_Tsmooth[time_idx][idx], vDSP_Length(imax-imin+1))
        }
    }
    
    // Quefrency smoothing
    for idx in 0 ..< nx {
        for quef_idx in 0 ..< nq {
            var imin = quef_idx - quef_win
            var imax = quef_idx + quef_win
            
            if imin < 0 {
                imin = 0
            }
            if imax > (nq-1) {
                imax = nq-1
            }
            
            vDSP_meanvD(Array<Double>(x_Tsmooth[idx][imin...imax]), 1, &x_Qsmooth[idx][quef_idx], vDSP_Length(imax-imin+1))
        }
    }
    
    // Processing for each time frame in the Power Cepstrogram
    for timeIdx in 0 ..< nx {
        // Compute trend line
        DSP_getTrendLine(quefrency: quefrencyRange,
                         cepstrum: x_Qsmooth[timeIdx],
                         from: quefStart,
                         to: quefEnd,
                         trendLine: &trendLine)
        
        // Compute difference between power cepstrogram and trend line (in dB)
        // and make zero any values below zero
        var diff = Array(x_Qsmooth[timeIdx][quefStartIdx ... quefEndIdx].map{ 10.0 * log10($0) })
        diff = zip(diff, trendLine).map{ $0 - $1 }.map{ $0 < 0 ? 0.0 : $0 }
        diff = Array<Double>(repeating: 0.0, count: quefStartIdx)
                + diff
                + Array<Double>(repeating: 0.0, count: quefrencyRange.count - quefEndIdx - 1)
        
        // Initial value and location of maximum peak
        var maximum = diff[cppSearchRangeStartIdx]
        var max_loc = Double(cppSearchRangeStartIdx)
        
        if diff[cppSearchRangeEndIdx] > maximum {
            maximum = diff[cppSearchRangeEndIdx]
            max_loc = Double(cppSearchRangeEndIdx)
        }
        
        if cppSearchRangeStartIdx == 1 {
            cppSearchRangeStartIdx += 1
        }
        if cppSearchRangeEndIdx == (quefrencyRange.count-1) {
            cppSearchRangeEndIdx -= 1
        }
        
        // Find maximum peak
        for qidx in cppSearchRangeStartIdx ... cppSearchRangeEndIdx {
            if (diff[qidx] > diff[qidx-1]) && (diff[qidx] >= diff[qidx+1]) {
                
                let dr = 0.5 * (diff[qidx+1] - diff[qidx-1])
                let d2r = 2 * diff[qidx] - diff[qidx-1] - diff[qidx+1]
                
                // Compute frequency and strength
                let locMax = Double(qidx) + (dr / d2r)
                let strMax = diff[qidx] + 0.5 * dr * dr / d2r
                
                if strMax > maximum {
                    maximum = strMax
                    max_loc = locMax
                }
            }
        }
        
        // Assign outputs values
        cpp[timeIdx] = maximum
        f0[timeIdx] = fs / max_loc
    }
} // End fxn: DSP_getCPPS

// Fxn: helper function to compute trend line
func DSP_getTrendLine(quefrency x: [Double],
                      cepstrum y: [Double],
                      from x1: Double,
                      to x2: Double,
                      trendLine yHat: inout [Double]) {
    
    let startIdx = x.indices.filter{ x[$0] >= x1 }.first!
    let endIdx = x.indices.filter{ x[$0] <= x2}.last!
    
    let xSlice = Array(x[startIdx...endIdx])
    let ySlice = Array(y[startIdx...endIdx]).map{ 10.0 * log10($0)}
    
    let regressionFit = linearRegression(xSlice, ySlice)
    
    yHat = xSlice.map(regressionFit)
    
} // End fxn: DSP_getTrendLine

// Fxn: helper function to compute mean value
func average<T: FloatingPoint>(_ input: [T]) -> T {
    
    return input.reduce(0, +) / T(input.count)
} // End fxn: average

// Fxn: helper function to multiply two vectors
func multiply<T: FloatingPoint>(_ a: [T],
                                _ b: [T]) -> [T] {
    
    return zip(a, b).map( { $0 * $1 } )
} // End fxn: multiply

// Fxn: helper function to compute linear regression
func linearRegression<T: FloatingPoint>(_ xs: [T],
                                        _ ys: [T]) -> (T) -> T {
    
    let m_x = average(xs)
    let m_y = average(ys)
    
    let sum1 = average(multiply(ys, xs)) - m_x * m_y
    let sum2 = average(multiply(xs, xs)) - m_x * m_x
    
    let slope = sum1 / sum2
    let intercept = m_y - slope * m_x
    
    return { x in intercept + slope * x }
} // End fxn: linearRegression

// Fxn: helper function to replicate MATLAB's xcorr
func xcorr(_ x: [Double],
           _ y: [Double],
           normalized norm: Bool) -> [Double] {

    // Initialize variables
    let resultSize = x.count
    var result = Array<Double>(repeating: 0.0, count: resultSize)
    
    // Create and apply zero padding
    let xPadded = x + Array<Double>(repeating: 0.0, count: y.count - 1)
    
    // Compute cross-correlation between xPadded and y
    vDSP_convD(xPadded, 1, y, 1, &result, 1, vDSP_Length(resultSize), vDSP_Length(y.count))
    
    // Normalize correlation (if applicable)
    if norm {
        var maxCorr = result.first ?? 1.0
        vDSP_vsdivD(result, 1, &maxCorr, &result, 1, vDSP_Length(resultSize))
    }
    
    return result
} // End fxn: xcorr

// Fxn: helper function to determine if candidates are voiced
func candidatesAreVoiced(pitchFrames frames: pitchFrame,
                         ceiling maxPitch: Double) -> Bool {

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
func frequencyIsVoiced(frequency freq: Double,
                       ceiling maxPitch: Double) -> Bool {

    return (freq > 0.0 && freq < maxPitch) ? true : false
} // End fxn: frequencyIsVoiced

// Fxn: helper function to calculate the intensity of a segment
func calcSegmentIntensity(_ intensityArray: [Double]) -> Double {
    
    // Parameters
    let hearingThreshold_in_Pa: Double = 20e-6
    
    // Initialize window vector
    var window = Array<Double>(repeating: 0.0, count: intensityArray.count)
    
    // Create Hann window
    DSP_createHann(windowLength: intensityArray.count, window: &window)

    // Apply window and compute sum of squared values of windowed signal
    let sumxw = vDSP.multiply(intensityArray, window).reduce(0, {$0 + ($1 * $1)})
    
    // Compute sum of window
    let sumw = window.reduce(0, +)
    
    // Compute intensity
    let intensity_in_Pa2: Double = sumxw / sumw
    
    // Return the rms intensity converted to dB SPL
    return 10 * log10(intensity_in_Pa2 / pow(hearingThreshold_in_Pa, 2))
} // End fxn: calcSegmentIntensity

// Fxn: helper function to replicate MATLAB's linspace, must cast Array(return StrideThrough)
func linspace<T: BinaryFloatingPoint>(from start: T,
                                      to end: T,
                                      with samples: T) -> StrideThrough<T> where T == T.Stride {
    
    return Swift.stride(from: start, through: end, by:  (end - start) / (samples-1))
} // End fxn: linspace

// Fxn: helper function to determine pitch path from candidates
func pitch_PathFinder(pitchFrame frames: [pitchFrame],
                      minimumPitch minPitch: Double,
                      ceiling maxPitch: Double) -> [Double] {
    
    // Parameters
    let silenceThreshold: Double = 0.03
    let voicingThreshold: Double = 0.45
    let octaveCost: Double = 0.01
    let octaveJumpCost: Double = 0.35
    let voicedUnvoicedCost: Double = 0.14
    
    // Initialize output frequency vector
    var f0_Hz = Array<Double>(repeating: 0.0, count: frames.count)
    
    for frameIdx in 0 ..< frames.count {
        var maximum: Double = 1e-30
        let pFrame: pitchFrame = frames[frameIdx]
        
        // Compute unvoiced strength threshold
        var unvoicedStrength: Double = (silenceThreshold <= 0) ? 0.0 :
            2.0 - (pFrame.Intensity / (silenceThreshold / (1.0 + voicingThreshold)))
        unvoicedStrength = voicingThreshold + max(0.0, unvoicedStrength)
        
        // Initial candidate, freq = 0 Hz
        f0_Hz[frameIdx] = pFrame.candidates[0].frequency
        
        if (frameIdx > 0) && (pFrame.nCandidates > 1) {
            var transitionCost = Array<Double>(repeating: 0.0, count: pFrame.nCandidates)
            
            // Determine if previous and current frame are voiceless or not
            let previousVoiceless: Bool = !frequencyIsVoiced(frequency: f0_Hz[frameIdx-1], ceiling: maxPitch)
            let currentVoiceless: Bool = !candidatesAreVoiced(pitchFrames: pFrame, ceiling: maxPitch)
            
            // Compute transition cost
            if currentVoiceless {
                if previousVoiceless {
                    transitionCost = Array<Double>(repeating: 0.0, count: pFrame.nCandidates)
                } else {
                    transitionCost = Array<Double>(repeating: voicedUnvoicedCost, count: pFrame.nCandidates)
                }
            } else {
                if previousVoiceless {
                    transitionCost = Array<Double>(repeating: voicedUnvoicedCost, count: pFrame.nCandidates)
                } else {
                    for idx in 0 ..< pFrame.nCandidates {
                        transitionCost[idx] = octaveJumpCost * abs(log2(f0_Hz[frameIdx-1] / pFrame.candidates[idx].frequency))
                    }
                }
            }
            
            // Find candidate with maximum strength and add it to frequency output vector
            for candidate in 1 ..< pFrame.nCandidates {
                let localStrength = pFrame.candidates[candidate].strength -
                    transitionCost[candidate] - octaveCost * log2(minPitch / pFrame.candidates[candidate].frequency)
                
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
    public func getCPPS(minimumFrequency minPitch: Double,
                        timeStep dt: Double,
                        preEmphasisFrequency fe: Double,
                        quefrencyAvgWindow quefWin: Double,
                        timeAvgWindow timeWin: Double,
                        maximumFrequency ceiling: Double) -> ([Double], [Double]) {
        
        // Read data from buffer
        let floatData = self.floatChannelData!

        // Read format data
        let samplingRate: Double = floor(Double(self.format.sampleRate) / 2)
        let numFrames: Int = Int( round(Double(self.frameLength) / 2) )
        var numSegments: Int = 0
        
        // Copy buffer data to local variable
        var dataOriginal = Array<Double>(repeating: 0.0, count: Int(self.frameLength))
        var data = Array<Double>(repeating: 0.0, count: numFrames)
        vDSP_vspdp(floatData[0], 1, &dataOriginal, 1, vDSP_Length(self.frameLength))
        
        DSP_preEmphasis(signal: dataOriginal,
                        preEmphasisFrequency: fe,
                        samplingFrequency: Double(self.format.sampleRate),
                        output: &dataOriginal)
        
        DSP_antialiasingFilter(signal: dataOriginal,
                               output: &dataOriginal)
        vDSP_vaddD(dataOriginal, 2, data, 1, &data, 1, vDSP_Length(numFrames))
        
        let powerCepstrogram = DSP_getPowerCepstrogram(signal: data,
                                                       minimumFrequency: minPitch,
                                                       timeStep: dt,
                                                       samplingFrequency: samplingRate,
                                                       numFrames: &numSegments)
        
        // Initialize output vectors based on number of segments
        var cpps =  Array<Double>(repeating: 0.0, count: numSegments)
        var cpp_f0 = Array<Double>(repeating: 0.0, count: numSegments)
        
        DSP_getCPPS(powerCepstrogram: powerCepstrogram,
                    quefrencyAvgWindow: quefWin,
                    timeAvgWindow: timeWin,
                    timeStep: dt,
                    samplingFrequency: samplingRate,
                    minimumFrequency: minPitch,
                    ceiling: ceiling,
                    cpps: &cpps,
                    cpp_f0: &cpp_f0)
        
        return (cpps, cpp_f0)
    }
    
    // CHANGED: new function to calculate the intensity on a signal's buffer
    public func getIntensity(minimumPitch pitchFloor: Double) -> [Double] {

        // Read data from buffer
        let floatData = self.floatChannelData!

        // Read format data
        let channelNumber: Int = 0
        let samplingRate: Double = Double(self.format.sampleRate)
        let numSamples: Int = Int(self.frameLength)
        
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
        //print("Intensity Llico: ", intensityValues)
        return intensityValues
    } // End fxn, getIntensity

    // CHANGED: new function to calculate the pitch on a signal's buffer
    public func getPitch(minimumPitch pitchFloor: Double,
                         maximumPitch ceiling: Double) -> [Double] {
        
        // Read data from buffer
        let floatData = self.floatChannelData! // is dones
        print("FloatData:")
        print(floatData[0])
        // Read format data
        let channelNumber: Int = 0 // is done
        let samplingRate: Double = Double(self.format.sampleRate)
        print("samplingRate:")
        print(samplingRate)
        let numSamples: Int = Int(self.frameLength)
        print("numSamples:")
        print(numSamples)
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
        
        //print("frameValues:")
        //print(frameValues)
         
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
        print("Llico Pitches: ", pitchValues)
        return pitchValues
    } // End fxn, getPitch

    private func getSegmentPitch(from block: [Double],
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
}

