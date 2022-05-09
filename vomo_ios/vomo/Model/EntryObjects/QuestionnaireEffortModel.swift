//
//  QuestionnaireEffortModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/2/22.
//

import Foundation

class QuestionnaireEffortModel: Identifiable, Codable {
    var createdAt: Date
    var q1: Int, q2: Int
    
    init(createdAt: Date, q1: Int, q2: Int) {
        self.createdAt = createdAt
        self.q1 = q1
        self.q2 = q2
    }
}
