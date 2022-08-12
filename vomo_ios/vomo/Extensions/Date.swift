//
//  Date.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
    }
    
    public var filterToMonthYear : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else {
        return nil
       }
       return date
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        let strippedLhs = lhs.removeTimeStamp!
        let strippedRhs = rhs.removeTimeStamp!
        return (strippedLhs.timeIntervalSinceReferenceDate - strippedRhs.timeIntervalSinceReferenceDate) / (24 * 60 * 60)
    }
    
    static func + (lhs: Date, rhs: Date) -> TimeInterval {
        let strippedLhs = lhs.removeTimeStamp!
        let strippedRhs = rhs.removeTimeStamp!
        return (strippedLhs.timeIntervalSinceReferenceDate + strippedRhs.timeIntervalSinceReferenceDate) / (24 * 60 * 60)
    }
    
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toStringDay() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toDOB() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toStringHour() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func toFullDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy, hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func toMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    func toYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        return dateFormatter.string(from: self)
    }
    
    public var splitYear: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    public var splitMonth: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    public var splitDay: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    public var splitHour: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    public var splitMinute: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    public var splitSecond: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    public var isPM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        return dateFormatter.string(from: self)
    }
}
