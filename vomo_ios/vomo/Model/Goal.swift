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
    /// Stores the goal amount of enteries to be logged per week
    @Published var perWeek: Int {
        didSet {
            UserDefaults.standard.set(perWeek, forKey: "per_week")
            startDate = Date.now.toStringDay()
        }
    }
    /// Stores the number of weeks the goal is set for
    @Published var numWeeks: Int {
        didSet {
            UserDefaults.standard.set(numWeeks, forKey: "num_weeks")
            startDate = Date.now.toStringDay()
        }
    }
    /// Stores the number of entries entered so far
    @Published var entered: Int {
        didSet {
            UserDefaults.standard.set(entered, forKey: "entered")
        }
    }
    /// Stores the start date for the goal
    @Published var startDate: String {
        didSet {
            UserDefaults.standard.set(startDate, forKey: "start_date")
        }
    }
    
    @Published var goalSet: Bool {
        didSet {
            UserDefaults.standard.set(goalSet, forKey: "goal_set")
        }
    }
    
    /// Notifications toggle - On by default but can be switched on
    /// Access - can be accessed from Goal and from ProfileView
    @Published var notificationToggle: Bool {
        didSet {
            UserDefaults.standard.set(notificationToggle, forKey: "notification_toggle")
        }
    }
    /// Smart Notifications toggle - On by default but can be switched to controlled, smart notifcations only notify you when you should do another recording to keep on track with your goal
    /// EX. 3 x a week goal, 3 x a week notification, updates the frequency of the notifications on the basis of wether or not you are keeping on track with your goal, will still only notify you when necessary
    @Published var smartNotificationToggle: Bool {
        didSet {
            UserDefaults.standard.set(smartNotificationToggle, forKey: "smart_notification_toggle")
        }
    }
    /// Notifications frequency - daily, weekly
    @Published var notificationFrequency: String {
        didSet {
            UserDefaults.standard.set(notificationFrequency, forKey: "notification_frequency")
        }
    }
    
    init() {
        /// Goal model initialized variables
        self.perWeek = UserDefaults.standard.object(forKey: "per_week") as? Int ?? 1
        self.numWeeks = UserDefaults.standard.object(forKey: "num_weeks") as? Int ?? 1
        self.entered = UserDefaults.standard.object(forKey: "entered") as? Int ?? 0
        self.startDate = UserDefaults.standard.object(forKey: "start_date") as? String ?? ""
        self.notificationToggle = UserDefaults.standard.object(forKey: "notification_toggle") as? Bool ?? true
        self.smartNotificationToggle = UserDefaults.standard.object(forKey: "smart_notification_toggle") as? Bool ?? true
        self.notificationFrequency = UserDefaults.standard.object(forKey: "notification_frequency") as? String ?? "daily"
        self.goalSet = UserDefaults.standard.object(forKey: "goal_set") as? Bool ?? false
    }
}

extension Goal {
    func clearGoal() {
        self.perWeek = 1
        self.numWeeks = 1
        self.entered = 0
        self.goalSet = false
    }
    
    func isActive() -> Bool {
        let weeksElapsed = (-1 * Double(startDate.toDate()?.timeIntervalSinceNow ?? 0.0) / 604800.0)
        if (weeksElapsed <= Double(numWeeks) || numWeeks == 0) && goalSet  {
            return true
        } else {
            return false
        }
    }
    
    func clearNotifications() {
        print("Clearing notif")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // For removing all pending notifications which are not delivered yet but scheduled.
    }
    
    func scheduleNotifications() {
        print("Scheduling notif")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // For removing all pending notifications which are not delivered yet but scheduled.
        if smartNotificationToggle {
            notificationSchedule()
        } else {
            var ret: [Date] = []
            
            /*
             determine if daily or weekly schedule notifications accordingly
             */
            let numDays = perWeek * numWeeks
            
            if notificationFrequency == "Daily" {
                for day in 1...numDays {
                    ret.append(Date(timeInterval: TimeInterval(86400 * day), since: startDate.toDate() ?? .now))
                }
            } else if notificationFrequency == "Weekly" {
                for week in 1...numWeeks {
                    ret.append(Date(timeInterval: TimeInterval(86400 * week + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                }
                
            }
            
            for i in ret {
                scheduleNotification(date: i)
            }
        }
        
        func requestPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    /// Ran every time the app is opened
    /// Called after an entry is recorded
    /// Will clear notifications that have already been delivered
    /// Will clear notifications if the user is on track ex. (entered / numWeeks) > (numWeeks / perWeek)
    func updateNotificationSuite() {
        print("Notificaton suite updating...")
        
        /*
         Determine if on track
         On track if avg enteries per week, so far > perWeek
         avg entries per week is calculated by finding the week # currently in (time interval since start / 604800(second count per week))
         Entered / weeks elapsed >= perWeek
         */
        /*
        let weeksElapsed = (-1 * Double(startDate.toDate()?.timeIntervalSinceNow ?? 0.0) / 604800.0)
        if (Double(entered) / weeksElapsed) >= Double(perWeek) {
            print("On track. Weeks elapsed: \(weeksElapsed)")
            /*
             if ahead by 1 entery, cancel the very next notification, otherwise do nothing
             */
            if ((Double(entered) / weeksElapsed) - Double(perWeek)) >= 1 {
                print("cancel next notification")
            }
        } else {
            print("Off track")
        }
        */
        UNUserNotificationCenter.current().removeAllDeliveredNotifications() // For removing all delivered notification
    }
    
    func notificationSchedule() {
        var ret: [Date] = []
        
        // When notifications are first set up it starts on day 0, the next day is day one, so on and so furth
        /*
         If perWeek > 7 max out at 7 notifications per week until the goal is over.
         */
        
        /*
         Loop over the array of dates and perform scheduleNotification for each one to properly schedule notifications
         */
        
        if perWeek > 7 {
            // Amount of entries required per week is large enough to max out at 1 notification per day
            let numDays = perWeek * numWeeks
            for day in 1...numDays {
                ret.append(Date(timeInterval: TimeInterval(86400 * day), since: startDate.toDate() ?? .now))
            }
        } else {
            // Amount of entries required per week is small enough to space notifications out over a week
            for week in 1...numWeeks {
                if perWeek == 1 {
                    // Schedules notification starting tomorrow for once a week until the goal is over
                    ret.append(Date(timeInterval: TimeInterval(86400 + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                } else if perWeek == 2 {
                    // Schedules notification starting tomorrow for once a week until the goal is over
                    ret.append(Date(timeInterval: TimeInterval(86400 + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    // Schedules notification starting in 3 days for once a week until the goal is over
                    ret.append(Date(timeInterval: TimeInterval(86400 * 3 + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                } else if perWeek == 3 {
                    ret.append(Date(timeInterval: TimeInterval(86400 + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 3) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 5) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                } else if perWeek == 4 {
                    ret.append(Date(timeInterval: TimeInterval(86400 + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 3) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 5) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 6) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                } else if perWeek == 5 {
                    ret.append(Date(timeInterval: TimeInterval(86400 + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 2) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 4) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 5) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 6) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                } else if perWeek == 6 {
                    ret.append(Date(timeInterval: TimeInterval(86400 + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 2) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 3) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 4) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 5) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                    ret.append(Date(timeInterval: TimeInterval((86400 * 6) + ((week - 1) * 604800)), since: startDate.toDate() ?? .now))
                }
            }
        }
        
        for i in ret {
            scheduleNotification(date: i)
        }
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification(date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "It's time for some voice therapy "
        content.subtitle = "Record an entry today"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.year = date.splitYear
        dateComponents.month = date.splitMonth
        dateComponents.day = date.splitDay
        dateComponents.hour = 12
        dateComponents.minute = 0
        // show this notification five seconds from now
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        //UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        print("Notification scheduled for: \(dateComponents)")
    }
    
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
            return false
        } else {
            return true
        }
    }
}
