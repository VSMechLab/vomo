//
//  GoalModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 7/7/22.
//

import Foundation
import Combine
import SwiftUI
import UserNotifications

class Goal: ObservableObject {
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
    
    init() {
        /// Goal model initialized variables
        self.perWeek = defaults.object(forKey: "per_week") as? Int ?? 0
        self.numWeeks = defaults.object(forKey: "num_weeks") as? Int ?? 0
        self.entered = defaults.object(forKey: "entered") as? Int ?? 0
        self.startDate = defaults.object(forKey: "start_date") as? String ?? ""
    }
}

extension Goal {
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
        
        print(startDate)
        print(startDate.toFullDate())
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
