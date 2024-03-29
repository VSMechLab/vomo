//
//  String.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/21/22.
//

import SwiftUI
import Foundation

extension String {
    func toFullDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) // replace Date String
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) // replace Date String
    }
    
    func toDateFromDOB() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) // replace Date String
    }
}
