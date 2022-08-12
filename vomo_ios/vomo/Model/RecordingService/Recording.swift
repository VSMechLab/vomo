//
//  Recording.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/28/22.
//

import Foundation

struct Recording {
    let fileURL: URL
    let createdAt: Date
    
    // CHANGED: new metrics variables and bool of whether recording is processed
    /*
    var duration = Float(0) // Seconds
    var intensity = Float(0) // Decibels
    var pitch_mean = Float(0) // Hertz
    var pitch_min = Float(0) // Hertz
    var pitch_max = Float(0) // Hertz
     */
    
    var processed = false
}


/*
 
 
 
 
 
 */
