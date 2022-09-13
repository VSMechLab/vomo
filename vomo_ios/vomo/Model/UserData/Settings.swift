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

    /// Stores the goal amount of enteries to be logged per week
    @Published var perWeek: Int {
        didSet { defaults.set(perWeek, forKey: "per_week") }
    }
    /// Stores the number of weeks the goal is set for
    @Published var numWeeks: Int {
        didSet { defaults.set(numWeeks, forKey: "num_weeks") }
    }
    /// Stores the number of entries entered so far
    @Published var entered: Int {
        didSet { defaults.set(entered, forKey: "entered") }
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
            list = [TaskModel(prompt: "Say 'ahh' for\n5 seconds", taskNum: 1), TaskModel(prompt: "Say 'ahhh' for\nas long as you can", taskNum: 2), TaskModel(prompt: "Say 'The rainbow is a division of white light into many beautiful colors. These take the shape of a long round arch, with its path high above, and its two ends apparently beyond the horizon'", taskNum: 3)]
        } else {
            if vowel {
                list.append(TaskModel(prompt: "Say 'ahhh' for\nas long as you can", taskNum: 2))
            }
            if maxPT {
                list.append(TaskModel(prompt: "Say 'ahh' for\n5 seconds", taskNum: 1))
            }
            if rainbowS {
                list.append(TaskModel(prompt: "Say 'The rainbow is a division of white light into many beautiful colors. These take the shape of a long round arch, with its path high above, and its two ends apparently beyond the horizon'", taskNum: 3))
            }
        }
        return list
    }
    
    var endIndex: Int {
        return taskList.count
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
    @Published var questionnaires: Int {
        didSet {
            UserDefaults.standard.set(questionnaires, forKey: "questionnaires")
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
        self.questionnaires = UserDefaults.standard.object(forKey: "questionnaires") as? Int ?? 0
        
        /// Profile Questions
        self.voice_onset = UserDefaults.standard.object(forKey: "voiceOnset") as? Bool ?? false
        /*
         Add sex (at birth), gender, Date Onset
         */
        self.sexAtBirth = UserDefaults.standard.object(forKey: "sex_at_birth") as? String ?? ""
        self.gender = UserDefaults.standard.object(forKey: "gender") as? String ?? ""
        self.dateOnset = UserDefaults.standard.object(forKey: "date_onset") as? String ?? ""
        
        self.current_smoker = UserDefaults.standard.object(forKey: "currentSmoker") as? Bool ?? false
        self.have_reflux = UserDefaults.standard.object(forKey: "haveReflux") as? Bool ?? false
        self.have_asthma = UserDefaults.standard.object(forKey: "haveAsthma") as? Bool ?? false
        
        /// Goal model initialized variables
        self.perWeek = defaults.object(forKey: "per_week") as? Int ?? 0
        self.numWeeks = defaults.object(forKey: "num_weeks") as? Int ?? 0
        self.entered = defaults.object(forKey: "entered") as? Int ?? 0
        self.startDate = defaults.object(forKey: "start_date") as? String ?? ""
    }
    
    
    
    
    
}

extension Settings {
    /// Sent to notification service to schedule notifications calculated in real time based on goal considerations
    func triggers() -> [TriggerModel] {
        var ret: [TriggerModel] = []
        
        let amountDays = perWeek * numWeeks
        
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

    func setGoal(nWeeks: Int, nPerWeek: Int) {
        let newDate: Date = .now
        startDate = newDate.toStringDay()
        numWeeks = nWeeks
        perWeek = nPerWeek
    }

    func clearGoal() {
        let newDate: Date = .now
        startDate = newDate.toStringDay()
        numWeeks = 0
        perWeek = 0
    }

    func progress() -> Double {
        /*
         Add goal completion calculations, based on days/wk * # wks set under goals section
         */
        var result: Double = 0
        
        if perWeek > 0 || numWeeks > 0 {
            result = Double(Double(entered) / ( Double(perWeek) * Double(numWeeks) + 0.000001))
        }
        
        return result
    }
}

struct TaskModel {
    let prompt: String
    let taskNum: Int
}
