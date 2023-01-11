//
//  Notification.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import Foundation
import Combine
import SwiftUI
import UserNotifications

/// Todo, find  a way to deal with notifications scheduled over 64 times (OS Maximum)
/// For now limit to 63 max (7 entries per week over 9 weeks)

struct TriggerModel {
    var date: Date
    var identifier: String
}

enum Frequencies {
    case daily, weekly
}

class Notification: ObservableObject {
    @EnvironmentObject var settings: Settings
    /*
    var setFrequency: String {
        return Frequencies.daily
    }*/
    
    let defaults = UserDefaults.standard
    
    @Published var notificationsOn: Bool {
        didSet {
            UserDefaults.standard.set(notificationsOn, forKey: "notifications_on")
            if !notificationsOn {
                clearAll()
                print("Cleared notifications")
            }
        }
    }
    
    @Published var notificationFrequency: String {
        didSet {
            UserDefaults.standard.set(notificationFrequency, forKey: "notification_frequency")
        }
    }
    
    /// Prefered time of day  as an hour
    @Published var preferedHour: Int {
        didSet {
            UserDefaults.standard.set(preferedHour, forKey: "prefered_hour")
        }
    }
    /// Prefered time of day  as a minute
    @Published var preferedMinute: Int {
        didSet {
            UserDefaults.standard.set(preferedMinute, forKey: "prefered_minute")
        }
    }
    @Published var autoSchedule: Bool {
        didSet {
            UserDefaults.standard.set(autoSchedule, forKey: "auto_schedule")
        }
    }
    @Published var frequency: Int {
        didSet {
            UserDefaults.standard.set(frequency, forKey: "frequency")
        }
    }
    
    init() {
        self.notificationsOn = UserDefaults.standard.object(forKey: "notifications_on") as? Bool ?? true
        self.notificationFrequency = UserDefaults.standard.object(forKey: "notification_frequency") as? String ?? ""
        self.preferedHour = UserDefaults.standard.object(forKey: "prefered_hour") as? Int ?? 5
        self.preferedMinute = UserDefaults.standard.object(forKey: "prefered_minute") as? Int ?? 0
        self.autoSchedule = UserDefaults.standard.object(forKey: "auto_schedule") as? Bool ?? true
        self.frequency = UserDefaults.standard.object(forKey: "frequency") as? Int ?? 1
    }
}

extension Notification {
    func updateNotifications(triggers: [TriggerModel]) {
        clearAll()
        scheduleNotification(triggers: triggers)
        getPending()
    }
    
    func scheduleNotification(triggers: [TriggerModel]) {
        let content = UNMutableNotificationContent()
        content.title = "It's time for some voice therapy"
        content.subtitle = "Record an entry today"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        
        
        
        for trig in triggers {
            print("\(Date.now) and \(trig.date)")
            
            if trig.date > .now {
                dateComponents.year = trig.date.splitYear
                dateComponents.month = trig.date.splitMonth
                dateComponents.day = trig.date.splitDay
                dateComponents.hour = preferedHour
                dateComponents.minute = preferedMinute
                
                // show this notification five seconds from now
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                content.subtitle = "For testing purposes, id: " + trig.identifier
                
                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    /// Gets status to ask you to turn on notifications again
    func getStatus() -> Bool {
        guard let settings = UIApplication.shared.currentUserNotificationSettings else {
            return false
        }
        return settings.types.intersection([.alert, .badge, .sound]).isEmpty != true
    }
    
    /// Requests permission
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                //print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func clearAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func getPending() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request.trigger.unsafelyUnwrapped)
            }
        })
    }
    
    func clearDelivered() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
