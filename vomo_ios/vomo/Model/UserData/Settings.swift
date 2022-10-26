//
//  Settings.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import Foundation
import Combine
import SwiftUI
import UserNotifications

class Settings: ObservableObject {
    let defaults = UserDefaults.standard

    /// Showing and hiding on the basis of wether the keyboard is shown or not
    @Published var keyboardShown = false
    
    /// Stores the goal amount of recordings to be logged per week
    @Published var recordPerWeek: Int {
        didSet { defaults.set(recordPerWeek, forKey: "record_per_week") }
    }
    /// Stores the goal amount of quest to be logged per week
    @Published var surveysPerWeek: Int {
        didSet { defaults.set(surveysPerWeek, forKey: "surveys_per_week") }
    }
    /// Stores the goal amount of enteries to be logged per week
    @Published var journalsPerWeek: Int {
        didSet { defaults.set(journalsPerWeek, forKey: "journals_per_week") }
    }
    
    /// Stores the number of weeks the goal is set for
    @Published var numWeeks: Int {
        didSet { defaults.set(numWeeks, forKey: "num_weeks") }
    }
    /// Stores the number of entries entered so far
    @Published var recordEntered: Int {
        didSet { defaults.set(recordEntered, forKey: "record_entered") }
    }
    /// Stores the number of entries entered so far
    @Published var journalEntered: Int {
        didSet { defaults.set(journalEntered, forKey: "journal_entered") }
    }
    /// Stores the number of entries entered so far
    @Published var questionnaireEntered: Int {
        didSet { defaults.set(questionnaireEntered, forKey: "questionnaire_entered") }
    }
    /// Stores the start date for the goal
    @Published var startDate: String {
        didSet { defaults.set(startDate, forKey: "start_date") }
    }
    
    /// Sign Up Questions
    @Published var acceptedTerms: Bool {
        didSet {
            UserDefaults.standard.set(acceptedTerms, forKey: "accepts_terms")
        }
    }
    @Published var firstName: String {
        didSet {
            UserDefaults.standard.set(firstName, forKey: "first_name")
        }
    }
    @Published var lastName: String {
        didSet {
            UserDefaults.standard.set(lastName, forKey: "last_name")
        }
    }
    @Published var dob: String {
        didSet {
            UserDefaults.standard.set(dob, forKey: "dob")
        }
    }
    
    /// Voice Plan/Edited before
    @Published var voice_plan: Int {
        didSet {
            UserDefaults.standard.set(voice_plan, forKey: "voice_plan")
        }
    }
    @Published var edited_before: Bool {
        didSet {
            UserDefaults.standard.set(edited_before, forKey: "edited_before")
        }
    }
    
    /// Focus treatment plan
    @Published var focusSelection: Int {
        didSet {
            UserDefaults.standard.set(focusSelection, forKey: "focus_selection")
        }
    }
    
    /// Custom Track
    @Published var vowel: Bool {
        didSet {
            UserDefaults.standard.set(vowel, forKey: "vowel")
        }
    }
    @Published var maxPT: Bool {
        didSet {
            UserDefaults.standard.set(maxPT, forKey: "max_pt")
        }
    }
    @Published var rainbowS: Bool {
        didSet {
            UserDefaults.standard.set(rainbowS, forKey: "rainbow_s")
        }
    }
    @Published var allTasks: Bool {
        didSet {
            UserDefaults.standard.set(allTasks, forKey: "all_tasks")
        }
    }
    /// Functions/Variables for Record Page. Need the following
    /// var of type array that stores the name of all the tasks
    /// var of type integer that stores the end index
    var taskList: [TaskModel] {
        var list: [TaskModel] = []
        if allTasks || (vowel && maxPT && rainbowS) {
            list = [TaskModel(prompt: "'ahh'", taskNum: 1), TaskModel(prompt: "'ahhh'", taskNum: 2), TaskModel(prompt: "'The rainbow is a division of white light into many beautiful colors. These take the shape of a long round arch, with its path high above, and its two ends apparently beyond the horizon' \n\n 'The rainbow is a division of white light into many beautiful colors. These take the shape of a long round arch, with its path high above, and its two ends apparently beyond the horizon' \n\n 'The rainbow is a division of white light into many beautiful colors. These take the shape of a long round arch, with its path high above, and its two ends apparently beyond the horizon'", taskNum: 3)]
        } else {
            if vowel {
                list.append(TaskModel(prompt: "'ahhh'", taskNum: 2))
            }
            if maxPT {
                list.append(TaskModel(prompt: "'ahh'", taskNum: 1))
            }
            if rainbowS {
                list.append(TaskModel(prompt: "'The rainbow is a division of white light into many beautiful colors. These take the shape of a long round arch, with its path high above, and its two ends apparently beyond the horizon' \n\n 'The rainbow is a division of white light into many beautiful colors. These take the shape of a long round arch, with its path high above, and its two ends apparently beyond the horizon' \n\n 'The rainbow is a division of white light into many beautiful colors. These take the shape of a long round arch, with its path high above, and its two ends apparently beyond the horizon'", taskNum: 3))
            }
        }
        return list
    }
    
    var endIndex: Int {
        return taskList.count - 1
    }
    
    @Published var pitch: Bool {
        didSet {
            UserDefaults.standard.set(pitch, forKey: "pitch")
        }
    }
    @Published var CPP: Bool {
        didSet {
            UserDefaults.standard.set(CPP, forKey: "cpp")
        }
    }
    @Published var intensity: Bool {
        didSet {
            UserDefaults.standard.set(intensity, forKey: "intensity")
        }
    }
    @Published var duration: Bool {
        didSet {
            UserDefaults.standard.set(duration, forKey: "duration")
        }
    }
    @Published var minPitch: Bool {
        didSet {
            UserDefaults.standard.set(minPitch, forKey: "min_pitch")
        }
    }
    @Published var maxPitch: Bool {
        didSet {
            UserDefaults.standard.set(maxPitch, forKey: "max_pitch")
        }
    }
    
    @Published var accousticParameters: Bool {
        didSet {
            UserDefaults.standard.set(accousticParameters, forKey: "accoustic_parameters")
        }
    }
    
    /// vhi
    @Published var vhi: Bool {
        didSet {
            UserDefaults.standard.set(vhi, forKey: "vhi")
        }
    }
    /// vocal effort
    @Published var vocalEffort: Bool {
        didSet {
            UserDefaults.standard.set(vocalEffort, forKey: "vocal_effort")
        }
    }
    
    /// Profile Questions
    @Published var voice_onset: Bool {
        didSet {
            UserDefaults.standard.set(voice_onset, forKey: "voiceOnset")
        }
    }
    @Published var sexAtBirth: String {
        didSet {
            UserDefaults.standard.set(sexAtBirth, forKey: "sex_at_birth")
        }
    }
    @Published var gender: String {
        didSet {
            UserDefaults.standard.set(gender, forKey: "gender")
        }
    }
    @Published var dateOnset: String {
        didSet {
            UserDefaults.standard.set(dateOnset, forKey: "date_onset")
        }
    }
    
    @Published var current_smoker: Bool {
        didSet {
            UserDefaults.standard.set(current_smoker, forKey: "currentSmoker")
        }
    }
    @Published var have_reflux: Bool {
        didSet {
            UserDefaults.standard.set(have_reflux, forKey: "haveReflux")
        }
    }
    @Published var have_asthma: Bool {
        didSet {
            UserDefaults.standard.set(have_asthma, forKey: "haveAsthma")
        }
    }
    
    @Published var hidePopUp: Bool {
        didSet {
            UserDefaults.standard.set(hidePopUp, forKey: "hide_popup")
        }
    }
    
    init() {
        /// Sign Up Questions
        self.acceptedTerms = UserDefaults.standard.object(forKey: "accepts_terms") as? Bool ?? false
        self.firstName = UserDefaults.standard.object(forKey: "first_name") as? String ?? ""
        self.lastName = UserDefaults.standard.object(forKey: "last_name") as? String ?? ""
        self.dob = UserDefaults.standard.object(forKey: "dob") as? String ?? ""
        
        /// Voice Plan/Edited before
        self.voice_plan = UserDefaults.standard.object(forKey: "voice_plan") as? Int ?? 0
        self.edited_before = UserDefaults.standard.object(forKey: "edited_before") as? Bool ?? false
        
        /// Focus treatment plan
        self.focusSelection = UserDefaults.standard.object(forKey: "focus_selection") as? Int ?? 0
        
        /// Custom Track
        self.vowel = UserDefaults.standard.object(forKey: "vowel") as? Bool ?? false
        self.maxPT = UserDefaults.standard.object(forKey: "max_pt") as? Bool ?? false
        self.rainbowS = UserDefaults.standard.object(forKey: "rainbow_s") as? Bool ?? false
        self.allTasks = UserDefaults.standard.object(forKey: "all_tasks") as? Bool ?? false
        self.pitch = UserDefaults.standard.object(forKey: "pitch") as? Bool ?? false
        self.CPP = UserDefaults.standard.object(forKey: "cpp") as? Bool ?? false
        self.intensity = UserDefaults.standard.object(forKey: "intensity") as? Bool ?? false
        self.duration = UserDefaults.standard.object(forKey: "duration") as? Bool ?? false
        self.minPitch = UserDefaults.standard.object(forKey: "min_pitch") as? Bool ?? false
        self.maxPitch = UserDefaults.standard.object(forKey: "max_pitch") as? Bool ?? false
        self.accousticParameters = UserDefaults.standard.object(forKey: "accoustic_parameters") as? Bool ?? false
        
        self.vhi = UserDefaults.standard.object(forKey: "vhi") as? Bool ?? false
        self.vocalEffort = UserDefaults.standard.object(forKey: "vocal_effort") as? Bool ?? false
        
        /// Settings View Questions
        self.voice_onset = UserDefaults.standard.object(forKey: "voiceOnset") as? Bool ?? false
        self.sexAtBirth = UserDefaults.standard.object(forKey: "sex_at_birth") as? String ?? ""
        self.gender = UserDefaults.standard.object(forKey: "gender") as? String ?? ""
        self.dateOnset = UserDefaults.standard.object(forKey: "date_onset") as? String ?? ""
        
        self.current_smoker = UserDefaults.standard.object(forKey: "currentSmoker") as? Bool ?? false
        self.have_reflux = UserDefaults.standard.object(forKey: "haveReflux") as? Bool ?? false
        self.have_asthma = UserDefaults.standard.object(forKey: "haveAsthma") as? Bool ?? false
        
        /// Goal model initialized variables
        self.recordPerWeek = defaults.object(forKey: "record_per_week") as? Int ?? 0
        self.surveysPerWeek = defaults.object(forKey: "surveys_per_week") as? Int ?? 0
        self.journalsPerWeek = defaults.object(forKey: "journals_per_week") as? Int ?? 0
        self.numWeeks = defaults.object(forKey: "num_weeks") as? Int ?? 0
        self.recordEntered = defaults.object(forKey: "record_entered") as? Int ?? 0
        self.journalEntered = defaults.object(forKey: "journal_entered") as? Int ?? 0
        self.questionnaireEntered = defaults.object(forKey: "questionnaire_entered") as? Int ?? 0
        
        self.startDate = defaults.object(forKey: "start_date") as? String ?? ""
        
        /// Recording page popup
        self.hidePopUp = defaults.object(forKey: "hide_popup") as? Bool ?? false
    }
}

extension Settings {
    /// Sent to notification service to schedule notifications calculated in real time based on goal considerations
    func triggers() -> [TriggerModel] {
        var ret: [TriggerModel] = []
        
        let amountDays = recordPerWeek * numWeeks
        
        for i in 0..<amountDays {
            ret.append(TriggerModel(date: Date(timeInterval: Double(i) * 86400, since: startDate.toFullDate() ?? .now), identifier: String(i)))
        }
        
        return ret
    }

    /// Checks if goal is active on the basis of the start date + nWeeks > .now
    func isActive() -> Bool {
        let weeksElapsed = (-1 * Double(startDate.toDate()?.timeIntervalSinceNow ?? 0.0) / 604800.0)
        if ((weeksElapsed <= Double(numWeeks)) && numWeeks != 0) {
            return true
        } else {
            return false
        }
    }

    func setGoal(nWeeks: Int, records: Int, quests: Int, journs: Int) {
        let newDate: Date = .now
        startDate = newDate.toStringDay()
        numWeeks = nWeeks
        recordPerWeek = records
        surveysPerWeek = quests
        journalsPerWeek = journs
    }

    func clearGoal() {
        let newDate: Date = .now
        startDate = newDate.toStringDay()
        numWeeks = 0
        recordPerWeek = 0
        self.recordPerWeek = 0
        self.surveysPerWeek = 0
        self.journalsPerWeek = 0
    }

    func recordProgress() -> Double {
        /*
         Add goal completion calculations, based on days/wk * # wks set under goals section
         */
        var result: Double = 0
        
        if recordPerWeek > 0 || numWeeks > 0 {
            result = Double(Double(recordEntered) / ( Double(recordPerWeek) * Double(numWeeks) + 0.000001))
        }
        
        return result
    }
    func questProgress() -> Double {
        /*
         Add goal completion calculations, based on days/wk * # wks set under goals section
         */
        var result: Double = 0
        
        if surveysPerWeek > 0 || numWeeks > 0 {
            result = Double(Double(questionnaireEntered) / ( Double(surveysPerWeek) * Double(numWeeks) + 0.000001))
        }
        
        return result
    }
    func journalProgress() -> Double {
        /*
         Add goal completion calculations, based on days/wk * # wks set under goals section
         */
        var result: Double = 0
        
        
        if journalsPerWeek > 0 || numWeeks > 0 {
            result = Double(Double(journalEntered) / ( Double(journalsPerWeek) * Double(numWeeks) + 0.000001))
        }
        
        return result
    }
}

struct TaskModel {
    let prompt: String
    let taskNum: Int
}
