//
//  ProcessedData.swift
//  VoMo
//
//  Created by Neil McGrogan on 12/2/22.
//

import SwiftUI
import Foundation

class ProcessedData: Identifiable, Codable {
    var createdAt: Date
    /// Value of duration measured in seconds
    var duration: Float
    var intensity: Float
    /// Mean value of pitch measured in decibles
    var pitch_mean: Float
    /// Pitch minimum value
    var pitch_min: Float
    /// Pitch maximum value
    var pitch_max: Float
    /// Boolean value of wether or not the entry is started
    /// to remove this delete the line bellow and debug until working again
    var favorite: Bool
    
    init(createdAt: Date, duration: Float, intensity: Float, pitch_mean: Float, pitch_min: Float, pitch_max: Float, favorite: Bool) {
        self.createdAt = createdAt
        self.duration = duration
        self.intensity = intensity
        self.pitch_mean = pitch_mean
        self.pitch_min = pitch_min
        self.pitch_max = pitch_max
        self.favorite = favorite
    }
}
