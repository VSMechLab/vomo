//
//  QuestionnaireModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import Foundation

class QuestionnaireModel: Identifiable, Codable {
    var createdAt: Date
    var q1: Int, q2: Int, q3: Int, q4: Int, q5: Int, q6: Int, q7: Int, q8: Int, q9: Int, q10: Int, q11: Int
    
    init(createdAt: Date, q1: Int, q2: Int, q3: Int, q4: Int, q5: Int, q6: Int, q7: Int, q8: Int, q9: Int, q10: Int, q11: Int) {
        self.createdAt = createdAt
        self.q1 = q1
        self.q2 = q2
        self.q3 = q3
        self.q4 = q4
        self.q5 = q5
        self.q6 = q6
        self.q7 = q7
        self.q8 = q8
        self.q9 = q9
        self.q10 = q10
        self.q11 = q11
    }
}
