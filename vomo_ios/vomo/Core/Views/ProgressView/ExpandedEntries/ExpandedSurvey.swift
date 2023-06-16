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
                    Text("**VHI-10:** \(score.0, specifier: "%.0f")")
                        .font(._bodyCopyMedium)
                    Spacer()
                    StarButton(type: "survey", date: createdAt)
                        .padding(7.5)
                    DeleteButton(deletionTarget: $deletionTarget, type: "Survey response", date: createdAt)
                        .padding(7.5)
                }
            }
            if available.contains("ve") {
                HStack(spacing: 0) {
                    Text("Effort: **Physical:** \(score.1, specifier: "%.0f")% / **Mental:** \(score.2, specifier: "%.0f")%")
                    Spacer()
                    StarButton(type: "survey", date: createdAt)
                        .padding(7.5)
                    DeleteButton(deletionTarget: $deletionTarget, type: "Survey response", date: createdAt)
                        .padding(7.5)
                }
            }
            if available.contains("bi") {
                HStack(spacing: 0) {
                    Text("Percent of **Vocal Function**: \(score.3, specifier: "%.0f")%")
                        .font(._bodyCopyMedium)
                    Spacer()
                    StarButton(type: "survey", date: createdAt)
                        .padding(7.5)
                    DeleteButton(deletionTarget: $deletionTarget, type: "Survey response", date: createdAt)
                        .padding(7.5)
                }
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
                for index in 0...9 {
                    if survey.responses[index] == -1 {
                        count += 1
                    }
                }
                var count1 = 0
                for index in 10...11 {
                    if survey.responses[index] == -1 {
                        count1 += 1
                    }
                }
                var count2 = 0
                for index in 12...12 {
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
                if count2 != 1 {
                    // Iterate through 11 different questions
                    ret += ["bi"]
                }
            }
        }
        
        return ret
    }
    
    var score: (Double, Double, Double, Double) {
        var ret: (Double, Double, Double, Double) = (-1.0, -1.0, -1.0, -1.0)
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
