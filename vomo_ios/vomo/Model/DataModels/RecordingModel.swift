//
//  RecordingModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 12/2/22.
//

import SwiftUI
import Foundation

struct Recording {
    let fileURL: URL
    let createdAt: Date
    
    var taskNum: Int {
        var taskNum = 0
        let taskString = String(fileURL.lastPathComponent).suffix(5).prefix(1)
        
        switch taskString {
        case "l":
            taskNum = 1
        case "T":
            taskNum = 2
        case "w":
            taskNum = 3
        default:
            taskNum = 0
        }
        
        return taskNum
    }
}
