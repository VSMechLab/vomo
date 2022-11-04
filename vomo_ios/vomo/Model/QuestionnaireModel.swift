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
    var star: Bool
    
    init(createdAt: Date, responses: [Int], star: Bool) {
        self.createdAt = createdAt
        self.responses = responses
        self.star = star
    }
    
    /// .0 is vhi, .1 is vocal effort
    var score: (Double, Double) {
        if responses.count == 11 {
            var count = 0
            for index in 0..<10 {
                if responses[index] == -1 {
                    count += 1
                }
            }
            
            if count == 10 {
                if responses[10] == -1 {
                    return (-1, -1)
                } else {
                    var resp = 0.0
                    resp = (Double(responses[10]) / 10) * 50
                    return (-1.0, resp)
                }
            } else {
                var vhi = 0.0
                for index in 0..<10 {
                    if responses[index] != -1 {
                        vhi += Double(responses[index])
                    }
                }
                
                if responses[10] == -1 {
                    return (vhi, -1.0)
                } else {
                    var resp = 0.0
                    resp = (Double(responses[10]) / 10) * 50
                    return (vhi, resp)
                }
            }
        } else {
            return (-1.0, -1.0)
        }
    }
}

