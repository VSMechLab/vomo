//
//  GoalModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 7/7/22.
//

import Foundation
import Combine
import SwiftUI

class GoalModel: ObservableObject {
    /// Goal model recursively updating variables
    @Published var perWeek: Int {
        didSet {
            UserDefaults.standard.set(perWeek, forKey: "per_week")
            startDate = Date.now.toStringDay()
            print(startDate)
        }
    }
    @Published var numWeeks: Int {
        didSet {
            UserDefaults.standard.set(numWeeks, forKey: "num_weeks")
            startDate = Date.now.toStringDay()
            print(startDate)
        }
    }
    @Published var entered: Int {
        didSet {
            UserDefaults.standard.set(entered, forKey: "entered")
        }
    }
    @Published var startDate: String {
        didSet {
            UserDefaults.standard.set(startDate, forKey: "start_date")
        }
    }
    
    init() {
        /// Goal model initialized variables
        self.perWeek = UserDefaults.standard.object(forKey: "per_week") as? Int ?? 0
        self.numWeeks = UserDefaults.standard.object(forKey: "num_weeks") as? Int ?? 0
        self.entered = UserDefaults.standard.object(forKey: "entered") as? Int ?? 0
        self.startDate = UserDefaults.standard.object(forKey: "start_date") as? String ?? ""
    }
}

extension GoalModel {
    /// Goal model functions
    func endDate() -> Date {
        /// TODO
        return .now
    }
    
    func convertDate() -> Date {
        return startDate.toDate() ?? .now
    }
    
    /// Goal model functions
    func timeLeft() -> Date {
        /// TODO
        return .now
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
    
    func active() -> Bool {
        if startDate == "" || convertDate().timeIntervalSinceNow > endDate().timeIntervalSinceNow {
            print("start: \(convertDate().timeIntervalSinceNow)")
            print("end: \(endDate().timeIntervalSinceNow)")
            return false
        } else {
            print("start: \(convertDate().timeIntervalSinceNow)")
            print("end: \(endDate().timeIntervalSinceNow)")
            return true
        }
    }
}
