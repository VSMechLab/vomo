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
    
    var customFrequency: Int = 1
    
    /// Always access using Calendar.current.dateComponents([.hour, .minute], from: notifTime)
    var time: Date = Calendar.current.date(bySetting: .hour, value: 7, of: Date())!
    
    var notificationsOn: Bool = true
}

/// Notifications - queues notifications
class Notification: ObservableObject {
    
    @EnvironmentObject var settings: Settings
    
    static let shared = Notification()
    
    let defaults = UserDefaults.standard
    
    var frequencyValue: Int {
        switch notificationSettings.frequency {
            case .daily:
                return 1
            case .everyOtherDay:
                return 2
            case .weekly:
                return 7
            case .monthly:
                return 30
            case .custom:
                return notificationSettings.customFrequency
        }
    }
    
    enum NotificationType: String {
        case recordingReminder = "RecordingReminder"
    }
  
    enum Frequency: String, CaseIterable, Codable {
        case daily = "Daily", everyOtherDay = "Every other day", weekly = "Weekly", monthly = "Monthly", custom = "Custom"
    }

    @Published var notificationSettings: NotificationSettings {
        didSet {
            Notification.write(notificationSettings)
            if (notificationSettings.notificationsOn) {
                self.scheduleNotifications(startDate: Date())
            } else {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                Logging.notificationLog.notice("Cleared all pending notifications")
            }
        }
    }
    
    @Published var autoSchedule: Bool {
        didSet {
            UserDefaults.standard.set(autoSchedule, forKey: "auto_schedule")
        }
    }
    
    init() {
        self.autoSchedule = UserDefaults.standard.object(forKey: "auto_schedule") as? Bool ?? true
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
    
    func scheduleNotifications(startDate: Date) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Vomo"
        notificationContent.body = "Let's record an entry! 🎙️"
        notificationContent.categoryIdentifier = NotificationType.recordingReminder.rawValue
        notificationContent.sound = .default
        
        let calendar = Calendar.current
        let frequency = self.frequencyValue
        
        for i in 0...(30 / frequency) {
            
            var dateComponents = calendar.dateComponents([.hour, .minute], from: self.notificationSettings.time)
            
            let triggerDate = calendar.date(byAdding: .day, value: i * frequency, to: startDate)
            dateComponents.day = calendar.component(.day, from: triggerDate ?? startDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    static func printScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            if requests.count != 0 {
                Logging.notificationLog.notice("\(requests.count) notifications scheduled for delivery")
                requests.forEach { request in
                    Logging.notificationLog.notice("\(request.content.categoryIdentifier) | Scheduled for \(request.trigger?.description ?? "Failed to unwrap")")
                }
            } else {
                Logging.notificationLog.notice("No notifications scheduled for delivery")
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
                Logging.notificationLog.notice("Notification Authorization Granted")
            } else if let error = error {
                Logging.notificationLog.notice("\(error.localizedDescription)")
            }
        }
    }
}
