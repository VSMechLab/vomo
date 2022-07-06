//
//  UserSettings.swift
//  VoMo
//
//  Created by Neil McGrogan on 7/5/22.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
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
    
    @Published var pitch: Bool {
        didSet {
            UserDefaults.standard.set(allTasks, forKey: "pitch")
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
    @Published var HNR: Bool {
        didSet {
            UserDefaults.standard.set(HNR, forKey: "hnr")
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
    /*
    @State private var voice_onset = UserDefaults.standard.bool(forKey: "voiceOnset")
    @State private var current_smoker = UserDefaults.standard.bool(forKey: "currentSmoker")
    @State private var have_reflux = UserDefaults.standard.bool(forKey: "haveReflux")
    @State private var have_asthma = UserDefaults.standard.bool(forKey: "haveAsthma")
    */
    @Published var voice_onset: Bool {
        didSet {
            UserDefaults.standard.set(voice_onset, forKey: "voiceOnset")
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
        self.HNR = UserDefaults.standard.object(forKey: "hnr") as? Bool ?? false
        self.minPitch = UserDefaults.standard.object(forKey: "min_pitch") as? Bool ?? false
        self.maxPitch = UserDefaults.standard.object(forKey: "max_pitch") as? Bool ?? false
        
        self.accousticParameters = UserDefaults.standard.object(forKey: "accoustic_parameters") as? Bool ?? false
        self.questionnaires = UserDefaults.standard.object(forKey: "questionnaires") as? Int ?? 0
        
        /// Profile Questions
        self.voice_onset = UserDefaults.standard.object(forKey: "voiceOnset") as? Bool ?? false
        self.current_smoker = UserDefaults.standard.object(forKey: "currentSmoker") as? Bool ?? false
        self.have_reflux = UserDefaults.standard.object(forKey: "haveReflux") as? Bool ?? false
        self.have_asthma = UserDefaults.standard.object(forKey: "haveAsthma") as? Bool ?? false
    }
}
