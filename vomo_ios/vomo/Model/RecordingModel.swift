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
        taskNum = Int(String(fileURL.lastPathComponent).suffix(5).prefix(1))!
        return taskNum
    }
}
