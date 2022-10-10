//
//  QuestionnaireModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import Foundation

class QuestionnaireModel: Identifiable, Codable {
    var createdAt: Date
    var responses: [Int]
    
    init(createdAt: Date, responses: [Int]) {
        self.createdAt = createdAt
        self.responses = responses
    }
}
