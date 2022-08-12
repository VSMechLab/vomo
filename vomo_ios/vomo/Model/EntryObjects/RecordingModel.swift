//
//  RecordingModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/18/22.
//

import Foundation

class RecordingModel: Identifiable, Codable {
    var createdAt: Date
    var duration: Float
    var intensity: Float
    
    init(createdAt: Date, duration: Float, intensity: Float) {
        self.createdAt = createdAt
        self.duration = duration
        self.intensity = intensity
    }
    
    // CHANGED: new metrics variables and bool of whether recording is processed
    //var fileURL: URL!
    
    //var duration = Float(0) // Seconds
    //var intensity = Float(0) // Decibels
    //var pitch_mean = Float(0) // Hertz
    //var pitch_min = Float(0) // Hertz
    //var pitch_max = Float(0) // Hertz
    
    //var processed = false
    /*
    // CHANGED: added another initializer
    init(createdAt: Date, taskNum: Int, dur: Float, inten: Float, meanP: Float, minP: Float, maxP: Float, proc: Bool) {
        self.createdAt = createdAt
        
        self.duration = dur
        self.intensity = inten
        //self.pitch_mean = meanP
        //self.pitch_min = minP
        //self.pitch_max = maxP
        
        //self.processed = proc
    }*/
}
