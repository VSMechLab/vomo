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
    let content_width = 340.0
    /// Padding for entry fields with text or images overlayed
    let fieldPadding = 7.0
    
    /// Onboard/selection buttons
    let select = "VM_Select-Btn"
    let unselect = "VM_Unselect-Btn"
    
    /// Tab bar items
    let home_icon = "VM_home-nav-icon"
    let record_icon = "VoMo-App-Outline_8_RECORD_BTN_PRPL"
    let selected_record_icon = "VoMo-App-Outline_8_RECORD_BTN_GREY"
    let progress_icon = "VoMo-App-Outline_8_PROGRESS_BTN_GREY"
    let selected_progress_icon = "VoMo-App-Outline_8_PROGRESS_BTN_PRPL"
    
    let button_img = "VM_Gradient-Btn"
    let profile_img = "VM_7-avatar-photo-placeholder-gfx"
    
    /// For Profile
    let genders = ["Male", "Female", "Non-binary", "Genderqueer", "Other"]
    var sexes = ["Male", "Female", "Other"]
    let vocalIssues = ["a custom", "the Spasmodic Dysphonia", "the Recurrent Pappiloma", "the Parkinson's Disease", "the Gender-Affirming Care", "the Vocal Fold/Paresis", "the default"]
    
    /// Items for recording
    let selected_do_not_show_img = "VM_Prpl-Check-Square-Btn"
    let unselected_do_not_show_img = "VM_Prpl-Square-Btn copy"
    let background_img = "VoMo-App-Outline_8_RECORD_POPUP_IMG"
    @ObservedObject var settings = Settings()
    
    let audio: [String] = ["KR_sustained_Ah_1", "KR_sustained_Ah_1", "KR_rainbow_1"]
    
    let next_img = "VM_next-nav-btn"
    
    let navArrowWidth = CGFloat(20)
    let navArrowHeight = CGFloat(25)
    
    let vhi: [String] = [
        "1. My voice makes it difficult for people to hear me.",
        "2. People have difficulty understanding me in a noisy room.",
        "3. My voice difficulties restrict personal and social life.",
        "4. I feel left out of conversations because of my voice.",
        "5. My voice problem causes me to lose income.",
        "6. I feel as though I have to strain to produce voice.",
        "7. The clarity of my voice is unpredictable.",
        "8. My voice problem upsets me.",
        "9. My voice makes me feel handicapped.",
        "10. People ask, \"Whats wrong with your voice?\"",
    ]
    
    let vocal_effort: [String] = [
        "How much physical effort did it take to make a voice?",
        "How much mental effort did it take to make a voice?"
    ]
    
    var questions: [String] {
        settings.setSurveys()
        var ret: [String] = []
        if settings.vhi {
            ret += vhi
        }
        if settings.vocalEffort {
            ret += vocal_effort
        }
        return ret
    }
    
    var allQuestions: [String] {
        return vhi + vocal_effort
    }
    
    let record_img = "VM_record-nav-ds-icon"
    let stop_img = "VM_stop-nav-ds-icon"
    
    /// Complete menu items
    let stop_play_img = "VM_stop_play-btn"
    let approved_img = "VM_appr-btn"
    let start_playback_img = "VoMo-App-Outline_8_PLAY_BTN_PRPL"
    let stop_playback_img = "VoMo-App-Outline_8_STOP_BTN_PRL"
    let forward_img = "VoMo-App-Outline_9_ff_btn"
    let backward_img = "VoMo-App-Outline_9_rewind_btn"
    let retry_img = "VM_retry-btn"
    
    /// Journal items
    let banner_img = "VoMo-App-Assets_journalEntry-Banner"
    let tag_img = "VM_12-tags-entry-field"
    let field_img = "VM_12-entry-field"
    
    /// Onboarding items
    let logo = "VM_VoMo-Logo-WhBG"
    
    /// Questionnaire Models
    let start_scale_img = "VoMo-App-Outline_8_RATING_KEY_GFX"
    let scale_img = "VoMo-App-Outline_8_RATING_SCALE_GFX_PRPL"
    let empty_scale_img = "VoMo-App-Outline_8_RATING_SCALE2_GFX_PRPL"
    let select_img = "VM_11-select-btn-ds"
    let scale_height: CGFloat = 140
    
    /// Exit button
    let exit_button = "VoMo-App-Assets_2_popup-close-btn"
    
    /// Home View
    let home_question_img = "VoMo-App-Outline_8_QUESTIONS_GFX"
    let home_record_img = "VoMo-App-Outline_8_RECORD_GFX"
    let home_journal_img = "VoMo-App-Outline_8_JOURNAL_GFX"
    let home_progress_img = "VoMo-App-Outline_8_PROGRESS_BTN"
    let home_intervention_img = "VoMo-App-Outline_8_INTERVENTION_BTN"
    let home_settings_img = "VoMo-App-Outline_8_SETTINGS_BTN"
    let home_wave_img = "VM_Waves-Gfx"
    
    /// Progress View
    let filled_img = "VM_Gradient-Btn"
    let empty_img = "VoMo-App-Outline_8_CLEAR_BTN"
    let trash_can = "VoMo-App-Outline_9_delete_btn"
    let share_button = "VoMo-App-Outline_9_share_btn"
    let heart_img = "VoMo-App-Outline_9_heart_prpl_btn"
    let heart_gray_img = "VoMo-App-Outline_9_heart_white_btn"
    
    /// Intervention items
    let upcoming = "Upcoming"
    let past = "Past"
    let time_img = "_time-icon"
    let date_img = "_date-icon"
    let type_img = "_visit-type-icon"
    let arrow_img = "VM_Dropdown-Btn"
    
    /// Threshold popup
    let min_img = "VoMo-App-Assets_2_8.4_less-than-btn"
    let gray_min_img = "VoMo-App-Assets_2_8.4_less-than-gry-btn"
    let mid_img = "VoMo-App-Assets_2_8.4_between-btn"
    let gray_mid_img = "VoMo-App-Assets_2_8.4_between-gry-btn"
    let max_img = "VoMo-App-Assets_2_8.4_more-than-btn"
    let gray_max_img = "VoMo-App-Assets_2_8.4_more-than-gry-btn"
}

