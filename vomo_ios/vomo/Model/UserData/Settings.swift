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
    @Published var surveyEntered: Int {
        didSet { defaults.set(surveyEntered, forKey: "survey_entered") }
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
    @Published var mpt: Bool {
        didSet {
            UserDefaults.standard.set(mpt, forKey: "mpt")
        }
    }
    @Published var rainbow: Bool {
        didSet {
            UserDefaults.standard.set(rainbow, forKey: "rainbow")
        }
    }
    /// thresholds stores an array of fixed size
    /// [a, b, c] where
    /// a = threshold setting
    ///     a=0 no setting
    ///     a=1 min setting
    ///     a=2 = mid setting
    ///     a=3 = max setting
    ///  b = less than amount
    ///  c = more than amount
    ///
    /// it is initialized on startup
    /// if array.count !=
    @Published var pitchThreshold: [Int] {
        didSet {
            UserDefaults.standard.set(pitchThreshold, forKey: "pitch_threshold")
        }
    }
    @Published var durationThreshold: [Int] {
        didSet {
            UserDefaults.standard.set(durationThreshold, forKey: "duration_threshold")
        }
    }
    @Published var qualityThreshold: [Int] {
        didSet {
            UserDefaults.standard.set(qualityThreshold, forKey: "quality_threshold")
        }
    }
    
    /// Functions/Variables for Record Page. Need the following
    /// var of type array that stores the name of all the tasks
    /// var of type integer that stores the end index
    var taskList: [TaskModel] {
        var list: [TaskModel] = []
        if availableRecordings.contains("vowel") {
            list += [TaskModel(prompt: "'ahh'", taskNum: 1)]
        }
        if availableRecordings.contains("mpt") {
            list += [TaskModel(prompt: "'ahhh'", taskNum: 2)]
        }
        if availableRecordings.contains("rainbow") {
            list += [TaskModel(prompt: "'The rainbow is a division of white light into many beautiful colors. These take the shape of a long round arch, with its path high above, and its two ends apparently beyond the horizon'", taskNum: 3)]
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
        self.mpt = UserDefaults.standard.object(forKey: "mpt") as? Bool ?? false
        self.rainbow = UserDefaults.standard.object(forKey: "rainbow") as? Bool ?? false
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
        self.surveyEntered = defaults.object(forKey: "survey_entered") as? Int ?? 0
        
        self.startDate = defaults.object(forKey: "start_date") as? String ?? ""
        
        /// Recording page popup
        self.hidePopUp = defaults.object(forKey: "hide_popup") as? Bool ?? false
        
        /// thresholds
        self.pitchThreshold = defaults.object(forKey: "pitch_threshold") as? [Int] ?? []
        self.durationThreshold = defaults.object(forKey: "duration_threshold") as? [Int] ?? []
        self.qualityThreshold = defaults.object(forKey: "quality_threshold") as? [Int] ?? []
    }
    
    var availableRecordings: [String] {
        var ret: [String] = []
        switch focusSelection {
        case 0:
            if self.vowel {
                ret += ["vowel"]
            }
            if self.mpt {
                ret += ["mpt"]
            }
            if self.rainbow {
                ret += ["rainbow"]
            }
        case 1:
            ret += ["vowel", "mpt", "rainbow"]
        case 2:
            ret += ["vowel", "mpt", "rainbow"]
        case 3:
            ret += ["mpt", "rainbow"]
        case 4:
            ret += ["vowel", "rainbow"]
        case 5:
            ret += ["vowel", "mpt", "rainbow"]
        case 6:
            ret += ["vowel", "mpt", "rainbow"]
        default:
            if self.vowel {
                ret += ["vowel"]
            }
            if self.mpt {
                ret += ["mpt"]
            }
            if self.rainbow {
                ret += ["rainbow"]
            }
        }
        return ret
    }
    
    var availableSurveys: [String] {
        var ret: [String] = []
        switch focusSelection {
        case 0:
            if self.vhi {
                ret += ["vhi"]
            }
            if self.vocalEffort {
                ret += ["vocal_effort"]
            }
        case 1:
            ret += ["vhi", "ve"]
        case 2:
            ret += ["vhi", "ve"]
        case 3:
            ret += ["ve"]
        case 4:
            ret += ["ve"]
        case 5:
            ret += ["vhi", "ve"]
        case 6:
            ret += ["vhi", "ve"]
        default:
            ret += ["vhi", "vocal_effort"]
        }
        return ret
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
        
        self.surveyEntered = 0
        self.journalEntered = 0
        self.recordEntered = 0
    }

    /// Total amount of recordings required to complete the goal
    var recordGoal: Double {
        return ( Double(recordPerWeek) * Double(numWeeks) + 0.000001)
    }
    /// Percentage of completed record goal
    var recordProgress: Double {
        let ret = 100.0 * Double(recordEntered) / ( recordGoal + 0.000001)
        if ret > 100 {
            return 100
        } else {
            return ret
        }
    }
    /// Total amount of journals required to complete the goal
    var journalGoal: Double {
        return ( Double(surveysPerWeek) * Double(numWeeks) + 0.000001)
    }
    /// Percentage of completed journals goal
    var journalProgress: Double {
        let ret = 100 * Double(journalEntered) / ( journalGoal + 0.000001)
        if ret > 100 {
            return 100
        } else {
            return ret
        }
    }
    
    /// Total amount of surveys required to complete the goal
    var surveyGoal: Double {
        return ( Double(surveysPerWeek) * Double(numWeeks) + 0.000001)
    }
    
    /// Percentage of completed surveys goal
    var surveyProgress: Double {
        let ret = 100.0 * Double(surveyEntered) / ( surveyGoal + 0.000001)
        if ret > 100 {
            return 100
        } else {
            return ret
        }
    }
    
    ///  Need the following
    ///  function that returns the beginning of the next full week
    ///  function that returns the end of then next full week
    ///  function that returns an array of a custom data type that contains the start and end date of each consecutive start and end dates contained after a given start date
    ///
    ///  for example
    ///  if the start date were to equal 10/19/2022
    ///  the next given start of the week would be the following monday, say, 10/20/2022
    ///  such that the first element of this custom data type would be DataType(start: 10/20/2022, end: 10/26/2022)
    ///  if this goal runs for a total of 6 weeks this function would return the following...
    ///
    ///  [DataType(start: 10/20/2022, end: 10/26/2022),
    ///   DataType(start: 10/27/2022, end: 10/26/2022), ......]
    var startWeek: (Date, Date) {
        let start: Date = Date(timeInterval: 0, since: startDate.toDate() ?? .now)
        return (start.startOfWeek, start.endOfWeek) as! (Date, Date)
    }
    
    var timelines: [Weeks] {
        var ret: [Weeks] = []
        for index in 0..<numWeeks {
            ret += [Weeks(
                start: Date(timeInterval: Double(604800 * index), since: startWeek.0),
                end: Date(timeInterval: Double(604800 * index), since: startWeek.1)
            )]
        }
        return ret
    }
}

struct Weeks {
    let start: Date
    let end: Date
}

struct TaskModel {
    let prompt: String
    let taskNum: Int
}
