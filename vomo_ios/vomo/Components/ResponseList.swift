//
//  ResponseList.swift
//  VoMo
//
//  Created by Neil McGrogan on 10/27/22.
//

import SwiftUI

/*
 Figure out a way to have independence in each questionnaire
 */
struct SurveyList: View {
    @EnvironmentObject var entries: Entries
    let svm = SharedViewModel()
    let createdAt: Date
    @Binding var reset: Bool
    var body: some View {
        VStack(alignment: .leading) {
            if available == "vhi" {
                HStack(spacing: 0) {
                    Text("VHI-10: ")
                        .font(._bodyCopyMedium)
                    Text("\(score.0, specifier: "%.0f")")
                        .font(._bodyCopyBold)
                    Spacer()
                    StarButton(type: "survey", date: createdAt)
                        .padding(.trailing)
                    DeleteEntry(date: createdAt, reset: $reset)
                }
            } else if available == "ve" {
                HStack(spacing: 0) {
                    Text("Vocal Effort: ")
                        .font(._bodyCopyMedium)
                    Text("\(score.1, specifier: "%.0f")")
                        .font(._bodyCopyBold)
                    Spacer()
                    StarButton(type: "survey", date: createdAt)
                        .padding(.trailing)
                    DeleteEntry(date: createdAt, reset: $reset)
                }
            } else if available == "both" {
                HStack(spacing: 0) {
                    Text("VHI-10: ")
                        .font(._bodyCopyMedium)
                    Text("\(score.0, specifier: "%.0f")")
                        .font(._bodyCopyBold)
                    Spacer()
                    StarButton(type: "survey", date: createdAt)
                        .padding(.trailing)
                    DeleteEntry(date: createdAt, reset: $reset)
                }
                Color.white.frame(height: 1)
                HStack(spacing: 0) {
                    Text("Vocal Effort: ")
                        .font(._bodyCopyMedium)
                    Text("\(score.1, specifier: "%.0f")")
                        .font(._bodyCopyBold)
                    Spacer()
                    StarButton(type: "survey", date: createdAt)
                        .padding(.trailing)
                    DeleteEntry(date: createdAt, reset: $reset)
                }
            }
        }
        .foregroundColor(Color.white)
        .padding(4)
    }
    
    var available: String {
        var ret = ""
        for survey in entries.questionnaires {
            // Check if survey time matches target time
            if survey.createdAt == createdAt && survey.responses.count != 0 {
                // Check if 1-11, 1-10, or 11
                var count = 0
                for index in 0..<10 {
                    if survey.responses[index] == -1 {
                        count += 1
                    }
                }
                
                // if first consecutive 10 are unanswered. else if last is unanswered. Else if some combination of answers on both
                if count == 10 {
                    ret = "ve"
                } else if survey.responses.last == -1 {
                    // Iterate through 11 different questions
                    ret = "vhi"
                } else {
                    // Iterate through 11 different questions
                    ret = "both"
                }
            }
        }
        
        return ret
    }
    
    var score: (Double, Double) {
        var ret: (Double, Double) = (-1.0, -1.0)
        for survey in entries.questionnaires {
            // Check if survey time matches target time
            if survey.createdAt == createdAt {
                ret = survey.score
            }
        }
        
        return ret
    }
}

/*
func findResponse(createdAt: Date) -> (Int, Int) {
    var ret: [Responses] = []
    
    for survey in entries.questionnaires {
        // Check if survey time matches target time
        if survey.createdAt == createdAt && survey.responses.count != 0 {
            // Check if 1-11, 1-10, or 11
            var count = 0
            for index in 0..<10 {
                if survey.responses[index] == -1 {
                    count += 1
                }
            }
            
            // if first consecutive 10 are unanswered. else if last is unanswered. Else if some combination of answers on both
            if count == 10 {
                ret.append(Responses(question: svm.allQuestions[10], response: 10 * survey.responses[10] ))
            } else if survey.responses.last == -1 {
                // Iterate through 10 different questions
                for int in 0..<10 {
                    if survey.responses[int] != -1 {
                        ret.append(Responses(question: svm.allQuestions[int], response: survey.responses[int] ))
                    }
                }
            } else {
                // Iterate through 11 different questions
                for int in 0..<10 {
                    if survey.responses[int] != -1 {
                        ret.append(Responses(question: svm.allQuestions[int], response: survey.responses[int] ))
                    }
                }
                ret.append(Responses(question: svm.allQuestions[10], response: 10 * survey.responses[10] ))
            }
        }
    }
    
    return ret
}*/
