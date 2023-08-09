//
//  AppDelegate.swift
//  VoMo
//
//  Created by Sam Burkhard on 5/29/23.
//

import Foundation
import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject, UNUserNotificationCenterDelegate {
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let notificationType = NotificationService.NotificationType(rawValue: response.notification.request.content.categoryIdentifier) {
            switch notificationType {
                case .recordingReminder:
//                    Logging.notificationLog.notice("Opened recording reminder!")
                    ViewRouter.shared.currentPage = .record
            }
        } else {
            Logging.notificationLog.notice("Coult not find notification category")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        // TODO: Implement show notification settings screen
    }
}
