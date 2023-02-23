//
//  ExpandedSurvey.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/*
 Figure out a way to have independence in each questionnaire
 */
struct ExpandedSurvey: View {
    @EnvironmentObject var entries: Entries
    let svm = SharedViewModel()
    let createdAt: Date
    @Binding var deletionTarget: (Date, String)
    var body: some View {
        VStack(alignment: .leading) {
            if available.contains("vhi") {
                HStack(spacing: 0) {
                    Text("VHI-10: ")
                        .font(._bodyCopyMedium)
                    Text("\(score.0, specifier: "%.0f")")
                        .font(._bodyCopyBold)
                    Spacer()
                    StarButton(type: "survey", date: createdAt)
                        .padding(.horizontal, 7.5)
                    DeleteButton(deletionTarget: $deletionTarget, type: "Survey response", date: createdAt)
                }
                Color.white.frame(height: 1)
            }
            if available.contains("ve") {
                HStack(spacing: 0) {
                    Text("Vocal Effort: ")
                        .font(._bodyCopyMedium)
                    Text("\(score.1, specifier: "%.0f")")
                        .font(._bodyCopyBold)
                    Spacer()
                    StarButton(type: "survey", date: createdAt)
                        .padding(.trailing)
                    DeleteButton(deletionTarget: $deletionTarget, type: "Survey response", date: createdAt)
                }
                Color.white.frame(height: 1)
            }
            if available.contains("bi") {
                HStack(spacing: 0) {
                    Text("Botulinum Injection: ")
                        .font(._bodyCopyMedium)
                    Text("\(score.2, specifier: "%.0f")")
                        .font(._bodyCopyBold)
                    Spacer()
                    StarButton(type: "survey", date: createdAt)
                        .padding(.trailing)
                    DeleteButton(deletionTarget: $deletionTarget, type: "Survey response", date: createdAt)
                }
                Color.white.frame(height: 1)
            }
        }
        .foregroundColor(Color.white)
        .padding(4)
    }
    
    var available: [String] {
        var ret: [String] = []
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
                var count1 = 0
                for index in 11...12 {
                    if survey.responses[index] == -1 {
                        count1 += 1
                    }
                }
                var count2 = 0
                for index in 13..<16 {
                    if survey.responses[index] == -1 {
                        count2 += 1
                    }
                }
                
                // if first consecutive 10 are unanswered. else if last is unanswered. Else if some combination of answers on both
                if count != 10 {
                    ret += ["vhi"]
                }
                if count1 != 2 {
                    // Iterate through 11 different questions
                    ret += ["ve"]
                }
                if count2 != 4 {
                    // Iterate through 11 different questions
                    ret += ["bi"]
                }
            }
        }
        
        return ret
    }
    
    var score: (Double, Double, Double) {
        var ret: (Double, Double, Double) = (-1.0, -1.0, -1.0)
        for survey in entries.questionnaires {
            // Check if survey time matches target time
            if survey.createdAt == createdAt {
                ret = survey.score
            }
        }
        
        return ret
    }
}

struct ExpandedSurvey_Previews: PreviewProvider {
    static var previews: some View {
        ExpandedSurvey(createdAt: .now, deletionTarget: .constant((.now, "vowel")))
    }
}
