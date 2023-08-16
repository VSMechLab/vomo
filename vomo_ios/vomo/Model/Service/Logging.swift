//
//  Logging.swift
//  VoMo
//
//  Created by Sam Burkhard on 5/13/23.
//

import Foundation
import os

/// Useful info on Logging framework - https://developer.apple.com/videos/play/wwdc2020/10168/
///
/// If data logged is private, explicitely mark as such with .privacy
/// ex. Logging.defaultLog.info("User's age: \(userAge, privacy: .private)")
///

struct Logging {
    
    static private let subsystem = "edu.uc.vomo"
    
    static let defaultLog = Logger(subsystem: subsystem, category: "default")
    
    static let notificationLog = Logger(subsystem: subsystem, category: "notifications")
    static let audioPlayerLog = Logger(subsystem: subsystem, category: "audioplayer")
    static let audioRecorderLog = Logger(subsystem: subsystem, category: "audiorecorder")
    static let signalProcessLog = Logger(subsystem: subsystem, category: "signalprocess")
    
}
