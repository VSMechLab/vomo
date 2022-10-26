//
//  QuestionnaireModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import Foundation

class QuestionnaireModel: Identifiable, Codable {
    /// Stores when it is created at
    /// Stores an empty array of 11 when initialized
    /// 1-10 is VHI, 11 is Vocal effort rating
    /// vhi is from 0-4 and vocal effort rating is 0-100
    var createdAt: Date
    var responses: [Int]
    
    init(createdAt: Date, responses: [Int]) {
        self.createdAt = createdAt
        self.responses = responses
    }
}
