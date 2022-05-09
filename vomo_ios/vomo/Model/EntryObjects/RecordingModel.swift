//
//  RecordingModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/18/22.
//

import Foundation

class RecordingModel: Identifiable, Codable {
    var createdAt: Date
    var taskNum: Int
    
    init(createdAt: Date, taskNum: Int) {
        self.createdAt = createdAt
        self.taskNum = taskNum
    }
}
