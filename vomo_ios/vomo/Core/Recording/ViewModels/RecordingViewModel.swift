//
//  RecordingViewModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/19/22.
//

import SwiftUI
import Foundation

struct RecordingViewModel {
    let prompt: [String] = ["Say 'ahh' for\n5 seconds", "say 'ahhh' for\nas long as you can", "Say 'A raindbow is a\ndivision of white light\ninto many beautiful colors'"]
    let audio: [String] = ["KR_sustained_Ah_1", "KR_sustained_Ah_1", "KR_rainbow_1"]
    
    let next_img = "VM_next-nav-btn"
    
    let navArrowWidth = CGFloat(20)
    let navArrowHeight = CGFloat(25)
    
    let content_width: CGFloat = 317.5
    
    var focusSelection = UserDefaults.standard.integer(forKey: "focus_selection")
    
    var taskList: [String] {
        var returnable: [String] = []
        if UserDefaults.standard.bool(forKey: "all_tasks") || focusSelection != 0 {
            return ["vowel", "max_pt", "rainbow_s"]
        } else {
            if UserDefaults.standard.bool(forKey: "vowel") {
                returnable.append("vowel")
            }
            if UserDefaults.standard.bool(forKey: "max_pt") {
                returnable.append("max_pt")
            }
            if UserDefaults.standard.bool(forKey: "rainbow_s") {
                returnable.append("rainbow_s")
            }
            return returnable
        }
    }
    
    var questionniare: String {
        /*
            VRQOL = 1
            VHI = 2
         */
        if UserDefaults.standard.integer(forKey: "questionnaires") == 1 {
            return "VRQOL"
        } else if UserDefaults.standard.integer(forKey: "questionnaires") == 2 {
            return "VHI"
        } else { return "VRQOL" }
    }
    
    let vrqol = [
        "1. I have trouble speaking loudly or being heard in noisy situations.",
        "2. I run out of air and need to take frequent breaths when talking.",
        "3. I sometimes do not know what will come out when I begin speaking.",
        "4. I am sometimes anxious or frustrated (because of my voice).",
        "5. I sometimes get depressed (because of my voice).",
        "6. I have trouble using the telephone (because of my voice).",
        "7. I have trouble doing my job or practicing my profession (because of my voice).",
        "8. I avoid going out socially (because of my voice).",
        "9. I have to repeat myself to be understood",
        "10. I have become less outgoing (because of my voice).",
        "The overall quality of my voice during the last two weeks has been:"
    ]
    let vhi = [
        "1. My voice makes it difficult for people to hear me.",
        "2. I run out of air when I talk",
        "3. People have difficulty understanding me in a noisy room.",
        "4. The sound of my voice varies throughout the day.",
        "5. My family has difficulty hearing me when I call them througout the house.",
        "6. I use the phone less often than I would like to.",
        "7. I'm tense when talking to others because of my voice",
        "8. I tend to avoid groups of people because of my voice",
        "9. People seem iritated with my voice",
        "10. People ask, \"Whats wrong with your voice?\"",
        "The overall quality of my voice during the last two weeks has been:"
    ]
}
