//
//  Date.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI


extension Date {
    /// start of day
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    /// end of day
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
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
    
    static func / (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
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
    
    /// "dd/MM/yyyy HH:mm:ss"
    func toStringDay() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    /// "h:m:s"
    func toDebug() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    /// "M/d/yyyy"
    func toDOB() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        return dateFormatter.string(from: self)
    }
    
    /// "hh:mm a"
    func toStringHour() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
    
    /// "MMM"
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
    
    /// "dd/MM/yy"
    func toFullDate() -> String
    {
        let dateFormatter = DateFormatter()
        // May need to be changed back. This was changed to prevent leadig zeros on dates
        //dateFormatter.dateFormat = "MM/dd/yy"
        dateFormatter.dateFormat = "M/d/yy"
        return dateFormatter.string(from: self)
    }
    
    /// "dd/MM/yy"
    func toDay() -> String
    {
        let dateFormatter = DateFormatter()
        // May need to be changed back. This was changed to prevent leadig zeros on dates
        //dateFormatter.dateFormat = "MM/dd/yy"
        dateFormatter.dateFormat = "M/d/yy"
        return dateFormatter.string(from: self)
    }
    /// "DDD"
    func dayOfWeek() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).uppercased()
    }
    
    func weekAndDay() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "(EEE M/d/yy)"
        return dateFormatter.string(from: self).uppercased()
    }
    
    /// For baseline title
    /// "EEE"
    func baselineLabelTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).uppercased()
    }
    /// For baseline body
    /// "M/d/yy"
    func baselineLabelBody() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        return dateFormatter.string(from: self).uppercased()
    }
    
    /// For node
    /// "EEE"
    func nodeTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).uppercased()
    }
    
    /// For node
    /// "M/d"
    func nodeHeader() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: self).uppercased()
    }
    
    /// "M/d"
    func shortDay() -> String
    {
        let dateFormatter = DateFormatter()
        // May need to be changed back. This was changed to prevent leadig zeros on dates
        //dateFormatter.dateFormat = "MM/dd/yy"
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: self)
    }
}
