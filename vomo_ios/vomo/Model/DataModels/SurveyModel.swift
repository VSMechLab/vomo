//
//  SurveyModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import Foundation

class SurveyModel: Identifiable, Codable {
    /// Stores when it is created at
    /// Stores an empty array of 11 when initialized
    /// 1-10 is VHI, 11 is Vocal effort rating
    /// vhi is from 0-4 and vocal effort rating is 0-100
    var createdAt: Date
    var responses: [Double]
    var favorite: Bool
    
    init(createdAt: Date, responses: [Double], favorite: Bool) {
        self.createdAt = createdAt
        self.responses = responses
        self.favorite = favorite
    }
    
    /// This is the score for all of the following items
    /// .0 is vhi,
    /// .1 is vocal effort - Physical Effort X%
    /// .2 is vocal effort - Mental Effort X%
    /// .3 is current percent of vocal function
    var score: (Double, Double, Double, Double) {
        var ret: (Double, Double, Double, Double) = (-1, -1, -1, -1)
        
        
        if responses.count == 13 {
            // Check if 1-11, 1-10, or 11
            var count = 0
            for index in 0...9 {
                if responses[index] == -1 {
                    count += 1
                }
            }
            
            var count1 = 0
            for index in 10...11 {
                if responses[index] == -1 {
                    count1 += 1
                }
            }
            
            var count2 = 0
            for index in 12...12 {
                if responses[index] == -1 {
                    count2 += 1
                }
            }
            
            // if first consecutive 10 are unanswered. else if last is unanswered. Else if some combination of answers on both
            if count != 10 {
                var resp = 0
                for index in 0...9 {
                    if responses[index] != -1 {
                        resp += Int(Double(responses[index]))
                    }
                }
                ret.0 = Double(resp)
            }
            if count1 != 2 {
                var resp: (Double, Double) = (0.0, 0.0)
                if responses[10] != -1 {
                    resp.0 = Double(responses[10]) * 10.0
                }
                if responses[11] != -1 {
                    resp.1 = Double(responses[11]) * 10.0
                }
                
                ret.1 = resp.0
                ret.2 = resp.1
            }
            if count2 != 1 {
                var resp = 0.0
                if responses[12] != -1 {
                    resp += Double(responses[12]) * 10.0
                }
                ret.3 = resp
            }
            
            return ret
        } else {
            return (-1.0, -1.0, -1.0, -1.0)
        }
    }
}

