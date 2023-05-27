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

struct NotificationSettings: Codable {
    var frequency: Notification.Frequency = .daily
    
    /// Always access using Calendar.current.dateComponents([.hour, .minute], from: notifTime)
    var time: Date = Calendar.current.date(bySetting: .hour, value: 7, of: Date())!
}

/// Notifications - queues notifications
class Notification: ObservableObject {
    @EnvironmentObject var settings: Settings
    
    let defaults = UserDefaults.standard
    
    enum Frequency: String, CaseIterable, Codable {
        case daily = "Daily", everyOtherDay = "Every other day", weekly = "Weekly", monthly = "Monthly", custom = "Custom"
        
        var value: Int {
            switch self {
                case .daily:
                    return 1
                case .everyOtherDay:
                    return 2
                case .weekly:
                    return 7
                case .monthly:
                    return 30
                case .custom:
                    return 1 // for now
            }
        }
    }
    
    @Published var notificationsOn: Bool {
        didSet {
            UserDefaults.standard.set(notificationsOn, forKey: "notifications_on")
            if !notificationsOn {
                clearAll()
                Logging.notificationLog.debug("Cleared notifications")
            }
        }
    }
    
    @Published var notificationSettings: NotificationSettings {
        didSet {
            Notification.write(notificationSettings)
            self.scheduleNotifications()
        }
    }
    
    @Published var autoSchedule: Bool {
        didSet {
            UserDefaults.standard.set(autoSchedule, forKey: "auto_schedule")
        }
    }
    
    init() {
        self.notificationsOn = UserDefaults.standard.object(forKey: "notifications_on") as? Bool ?? true
//        self.notificationFrequency = UserDefaults.standard.object(forKey: "notification_frequency") as? String ?? ""
//        self.preferedHour = UserDefaults.standard.object(forKey: "prefered_hour") as? Int ?? 5
//        self.preferedMinute = UserDefaults.standard.object(forKey: "prefered_minute") as? Int ?? 0
        self.autoSchedule = UserDefaults.standard.object(forKey: "auto_schedule") as? Bool ?? true
//        self.frequency = UserDefaults.standard.object(forKey: "frequency") as? Int ?? 1
        self.notificationSettings = Notification.load(NotificationSettings.self) ?? .init()
    }
    
    // MARK: Move all of this to persistance service eventually
    private static let userDefaults = UserDefaults.standard
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    private static func load<T: Codable>(_ type: T.Type) -> T? {
        if let loaded = userDefaults.object(forKey: "notification_settings") as? Data {
            if let model = try? decoder.decode(type.self, from: loaded) {
                return model
            }
        }
        return nil
    }
    
    private static func write<T: Codable>(_ model: T) {
        if let encoded = try? encoder.encode(model) {
            userDefaults.set(encoded, forKey: "notification_settings")
        }
    }
}

extension Notification {
    
    func scheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Vomo"
        notificationContent.body = "Let's record an entry! 🎙️"
        notificationContent.sound = .default
        
        let calendar = Calendar.current
//        let frequency = self.notificationFrequency.value
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: self.notificationSettings.time)
        
        Logging.notificationLog.notice("Scheduling notification for: \(dateComponents.debugDescription)")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
//        for i in 1...(30 / frequency) {
//
//            let hour = calendar.component(.hour, from: self.notificationTime)
//            let minute = calendar.component(.minute, from: self.notificationTime)
            
//            let triggerDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: calendar.date(byAdding: .day, value: i * frequency, to: Date()))
//            let trigger = UNCalendarNotificationTrigger(dateMatching: <#T##DateComponents#>, repeats: false)
            
//            let request = UNNotificationRequest(identifier: <#T##String#>, content: <#T##UNNotificationContent#>, trigger: <#T##UNNotificationTrigger?#>)
//            Logging.notificationLog.notice("Schedled for time: \(calendar.dateComponents([.hour, .minute], from: self.notificationTime))")
//            Logging.notificationLog.notice("Scheduled Message for \(String(describing: date))")
//        }
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
                Logging.notificationLog.notice("Notification Authorization Granted")
            } else if let error = error {
                Logging.notificationLog.notice("\(error.localizedDescription)")
            }
        }
    }
    
    func clearAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
//    func getPending() {
//        let center = UNUserNotificationCenter.current()
//        center.getPendingNotificationRequests(completionHandler: { requests in
//            for request in requests {
//                Logging.notificationLog.notice("\(request.trigger?.description ?? "Failed to unwrap")")
//            }
//        })
//    }
    
    func clearDelivered() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
