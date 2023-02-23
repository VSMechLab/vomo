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
    var favorite: Bool
    
    init(createdAt: Date, responses: [Int], favorite: Bool) {
        self.createdAt = createdAt
        self.responses = responses
        self.favorite = favorite
    }
    
    /// .0 is vhi, .1 is vocal effort
    var score: (Double, Double, Double) {
        var ret: (Double, Double, Double) = (-1, -1, -1)
        
        if responses.count == 16 {
            
            // Check if 1-11, 1-10, or 11
            var count = 0
            for index in 0..<10 {
                if responses[index] == -1 {
                    count += 1
                }
            }
            
            var count1 = 0
            for index in 11...12 {
                if responses[index] == -1 {
                    count1 += 1
                }
            }
            
            var count2 = 0
            for index in 13..<16 {
                if responses[index] == -1 {
                    count2 += 1
                }
            }
            
            // if first consecutive 10 are unanswered. else if last is unanswered. Else if some combination of answers on both
            if count != 10 {
                var resp = 0
                for index in 0..<10 {
                    if responses[index] != -1 {
                        resp += Int(Double(responses[index]))
                    }
                }
                ret.0 = Double(resp)
            }
            if count1 != 2 {
                var resp = 0.0
                if responses[10] != -1 {
                    resp += (Double(responses[10]) / 10) * 25
                }
                if responses[11] != -1 {
                    resp += (Double(responses[11]) / 10) * 25
                }
                ret.1 = resp
            }
            if count2 != 4 {
                var resp = 0.0
                if responses[12] != -1 {
                    resp += (Double(responses[10]) / 10) * 25
                }
                if responses[13] != -1 {
                    resp += (Double(responses[11]) / 10) * 25
                }
                if responses[14] != -1 {
                    resp += (Double(responses[10]) / 10) * 25
                }
                if responses[15] != -1 {
                    resp += (Double(responses[11]) / 10) * 25
                }
                ret.2 = resp
            }
            
            
            /*var count = 0
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
                    if responses[10] != -1 {
                        resp += (Double(responses[10]) / 10) * 25
                    }
                    if responses[11] != -1 {
                        resp += (Double(responses[11]) / 10) * 25
                    }
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
                    if responses[10] != -1 {
                        resp += (Double(responses[10]) / 10) * 25
                    }
                    if responses[11] != -1 {
                        resp += (Double(responses[11]) / 10) * 25
                    }
                    return (vhi, resp)
                }
            }*/
            
            
            
            
            return ret
        } else {
            return (-1.0, -1.0, -1.0)
        }
    }
}

