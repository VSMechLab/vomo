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

class Notification: ObservableObject {
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
            if trig.date > .now {
                dateComponents.year = trig.date.splitYear
                dateComponents.month = trig.date.splitMonth
                dateComponents.day = trig.date.splitDay
                dateComponents.hour = trig.date.splitHour + 19
                dateComponents.minute = trig.date.splitMinute + 0
                
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
