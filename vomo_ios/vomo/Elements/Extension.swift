//
//  Extension.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/8/22.
//

import SwiftUI

extension Color {
    static var BRIGHT_PURPLE = Color(red: 165/255, green: 155/255, blue: 255/255)
    static let TEAL = Color(red: 110/255, green: 255/255, blue: 230/255)
    static let BLUE = Color(red: 40/255, green: 95/255, blue: 200/255)
    static var DARK_BLUE = Color(red: 50/255, green: 40/255, blue: 140/255)
    static var HEADLINE_COPY = Color(red: 35/255, green: 35/255, blue: 35/255)
    static var BODY_COPY = Color(red: 125/255, green: 125/255, blue: 125/255)
    static var INPUT_FIELDS = Color(red: 235/255, green: 235/255, blue: 235/255)
    static var DARK_PURPLE = Color(red: 135/255, green: 130/255, blue: 225/255)
}

extension Font {
    static var vomoTitle: Font {
        Font.custom("Roboto-Bold", size: 34)
    }
    static var vomoHeader: Font {
        Font.custom("Roboto-Bold", size: 22)
    }
    static var vomoActivityRowTitle: Font {
        Font.custom("Roboto-Regular", size: 12)
    }
    static var vomoActivityRowSubtitle: Font {
        Font.custom("Roboto-Regular", size: 8)
    }
    static var vomoRecordingDay: Font {
        Font.custom("Roboto-Regular", size: 12)
    }
    static var vomoRecordingDayNum: Font {
        Font.custom("Roboto-Regular", size: 36)
    }
    static var vomoRecordingDaysAgo: Font {
        Font.custom("Roboto-Regular", size: 8)
    }
    static var vomoLightBodyText: Font {
        Font.custom("Roboto-Light", size: 15)
    }
    static var vomoSectionHeader: Font {
        Font.custom("Roboto-Medium", size: 13.5)
    }
    static var vomoSectionHeaderUnbold: Font {
        Font.custom("Roboto-Light", size: 13.5)
    }
    static var vomoSectionBody: Font {
        Font.custom("Roboto-Regular", size: 11.5)
    }
    static var vomoItalicButtons: Font {
        Font.custom("Roboto-LightItalic", size: 10)
    }
    static var vomoButtons: Font {
        Font.custom("Roboto-Light", size: 10)
    }
    static var vomoCardnHeader: Font {
        Font.custom("Roboto-Medium", size: 14)
    }
    static var vomoJournalTextTitle: Font {
        Font.custom("Roboto-Medium", size: 12.5)
    }
    static var vomoJournalText: Font {
        Font.custom("Roboto-light", size: 12.5)
    }
}

struct ColorView: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Group {
                    Text("Hi, Victoria")
                        .font(Font.vomoTitle)
                    
                    Text("Total Goals")
                        .font(Font.vomoHeader)
                    
                    Text("XX DAYS")
                        .font(Font.vomoActivityRowTitle)
                        .foregroundColor(Color.BODY_COPY)
                    
                    Text("SINCE LAST VISIT")
                        .font(Font.vomoActivityRowSubtitle)
                        .foregroundColor(Color.BODY_COPY)
                    
                    Text("MON")
                        .font(Font.vomoRecordingDay)
                        .foregroundColor(Color.BODY_COPY)
                    
                    Text("08")
                        .font(Font.vomoRecordingDayNum)
                        .foregroundColor(Color.BODY_COPY)
                    
                    Text("2 days ago")
                        .font(Font.vomoRecordingDaysAgo)
                        .foregroundColor(Color.BODY_COPY)
                }
                
                Text("Please enter the address assosciated with\nyour account")
                    .font(Font.vomoLightBodyText)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.center)
                Text("Voice Onset")
                    .font(Font.vomoSectionHeader)
                HStack {
                    Text("Choose")
                        .font(Font.vomoItalicButtons)
                    
                    Text("Yes")
                        .font(Font.vomoButtons)
                }
                /*
                HStack {
                    Text("Month")
                    Text("Month")
                 }.font(Font.vomoCardHeader)
                 */
            }.padding()
            
            Spacer()
            
            VStack(spacing: 1) {
                Color.BRIGHT_PURPLE
                Color.TEAL
                Color.BLUE
                Color.DARK_BLUE
                Color.HEADLINE_COPY
                Color.BODY_COPY
                Color.gray
                Color.INPUT_FIELDS
                Color.DARK_PURPLE
            }.frame(height: 250)
        }
    }
}

extension Date {
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
    
    func toStringHour() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm z"
        return dateFormatter.string(from: self)
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView()
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        let strippedLhs = lhs.removeTimeStamp!
        let strippedRhs = rhs.removeTimeStamp!
        return (strippedLhs.timeIntervalSinceReferenceDate - strippedRhs.timeIntervalSinceReferenceDate) / (24 * 60 * 60)
    }
}
