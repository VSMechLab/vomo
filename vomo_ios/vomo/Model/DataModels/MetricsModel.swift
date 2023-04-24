//
//  MetricsModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 12/2/22.
//

import SwiftUI
import Foundation

class MetricsModel: Identifiable, Codable {
    var createdAt: Date
    /// Value of duration measured in seconds
    var duration: Double
    var intensity: Double
    /// Mean value of pitch measured in decibles
    var pitch_mean: Double
    /// Pitch minimum value
    var pitch_min: Double
    /// Pitch maximum value
    var pitch_max: Double
    /// CPP
    var cppMean: Double
    /// Boolean value of wether or not the entry is started
    /// to remove this delete the line bellow and debug until working again
    var favorite: Bool
    
    init(createdAt: Date, duration: Double, intensity: Double, pitch_mean: Double, pitch_min: Double, pitch_max: Double, cppMean: Double, favorite: Bool) {
        self.createdAt = createdAt
        self.duration = duration
        self.intensity = intensity
        self.pitch_mean = pitch_mean
        self.pitch_min = pitch_min
        self.pitch_max = pitch_max
        self.cppMean = cppMean
        self.favorite = favorite
    }
}
