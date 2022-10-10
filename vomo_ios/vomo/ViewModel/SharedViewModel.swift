//
//  SharedViewModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import SwiftUI
import Foundation

/*
 
 General class that houses one central content_width, userdefaults and common functions
 
 */

struct SharedViewModel {
    /// Maximum width content will occupy on screen
    let content_width = 325.0
    /// Padding for entry fields with text or images overlayed
    let fieldPadding = 7.0
    
    /// Tab bar items
    let home_icon = "VM_home-nav-icon"
    let record_icon = "VM_home-nav-icon"
    let progress_icon = "VM_home-nav-icon"
    
    let button_img = "VM_Gradient-Btn"
    let profile_img = "VM_7-avatar-photo-placeholder-gfx"
    
    /// For Profile
    let genders = ["Other", "Genderqueer", "Non-binary", "Female", "Male"]
    var sexes = ["Other", "Female", "Male"]
    let vocalIssues = ["a custom", "the Spasmodic Dysphonia", "the Recurrent Pappiloma", "the Parkinson's Disease", "the Gender-Affirming Care", "the Vocal Fold/Paresis", "the default"]
    
    /// Items for recording
    @ObservedObject var settings = Settings()
    
    let audio: [String] = ["KR_sustained_Ah_1", "KR_sustained_Ah_1", "KR_rainbow_1"]
    
    let next_img = "VM_next-nav-btn"
    
    let navArrowWidth = CGFloat(20)
    let navArrowHeight = CGFloat(25)
    
    var taskList: [String] {
        var returnable: [String] = []
        if settings.allTasks || settings.focusSelection != 0 {
            return ["vowel", "max_pt", "rainbow_s"]
        } else {
            if settings.vowel {
                returnable.append("vowel")
            }
            if settings.maxPT {
                returnable.append("max_pt")
            }
            if settings.rainbowS {
                returnable.append("rainbow_s")
            }
            return returnable
        }
    }
    
    let vrqol = [
        "VRQOL",
        "1. I have trouble speaking loudly or being heard in noisy situations.",
        "2. I run out of air and need to take frequent breaths when talking.",
        "3. I sometimes do not know what will come out when I begin speaking.",
        "4. I am sometimes anxious or frustrated (because of my voice).",
        "5. I sometimes get depressed (because of my voice).",
        "6. I have trouble using the telephone (because of my voice).",
        "7. I have trouble doing my job or practicing my profession (because of my voice).",
        "8. I avoid going out socially (because of my voice).",
        "9. I have to repeat myself to be understood.",
        "10. I have become less outgoing (because of my voice).",
        "11. The overall quality of my voice during the last two weeks has been:"
    ]
    let vhi = [
        "VHI",
        "1. My voice makes it difficult for people to hear me.",
        "2. I run out of air when I talk.",
        "3. People have difficulty understanding me in a noisy room.",
        "4. The sound of my voice varies throughout the day.",
        "5. My family has difficulty hearing me when I call them througout the house.",
        "6. I use the phone less often than I would like to.",
        "7. I'm tense when talking to others because of my voice.",
        "8. I tend to avoid groups of people because of my voice.",
        "9. People seem irritated with my voice.",
        "10. People ask, \"Whats wrong with your voice?\"",
        "11. The overall quality of my voice during the last two weeks has been:"
    ]
    
    var questions: [String] {
        if settings.questionnaires == 1 {
            return vrqol
        } else if settings.questionnaires == 2 {
            return vhi
        } else {
            return []
        }
    }
    
    let record_img = "VM_record-nav-ds-icon"
    let stop_img = "VM_stop-nav-ds-icon"
    
    /// Complete menu items
    let stop_play_img = "VM_stop_play-btn"
    let approved_img = "VM_appr-btn"
    let play_img = "VM_play-btn"
    let retry_img = "VM_retry-btn"
    
    /// Journal items
    let banner_img = "VoMo-App-Assets_journalEntry-Banner"
    let tag_img = "VM_12-tags-entry-field"
    let field_img = "VM_12-entry-field"
    
    /// Onboarding items
    let logo = "VM_VoMo-Logo-WhBG"
    
    /// Questionnaire Models
    let scale_img = "VM_11-scale-bg-ds"
    let empty_scale_img = "VM_11-empty-scale-bg-ds"
    let select_img = "VM_11-select-btn-ds"
    let scale_height: CGFloat = 140
    
    /// Exit button
    let exit_button = "VoMo-App-Assets_2_popup-close-btn"
}
