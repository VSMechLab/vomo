//
//  ListItem.swift
//  VoMo
//
//  Created by Neil McGrogan on 10/27/22.
//

import SwiftUI

struct ListItem: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var showMore = false
    let element: Element
    var expand = false
    let svm = SharedViewModel()
    @Binding var reset: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation() {
                    self.showMore.toggle()
                }
            }) {
                HStack(spacing: 0) {
                    Text("\(element.date.dayOfWeek())  ")
                        .font(._bodyCopyBold)
                    Text(element.date.toDay())
                        .font(._bodyCopyMedium)
                    
                    SmallArrow()
                        .rotationEffect(Angle(degrees: showMore ? 90 : 0))
                        .padding(.leading, 5.5)
                    
                    Spacer()
                }
            }
            .padding(.bottom, 4)
            
            if showMore {
                VStack(spacing: 0) {
                    ForEach(0..<element.str.count) { index in
                        Color.BODY_COPY.frame(height: 1).opacity(0.6)
                        DayItem(expand: expand, index: index, element: element, reset: $reset)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .foregroundColor(Color.BODY_COPY)
        .background(showMore ? Color.INPUT_FIELDS : Color.white)
    }
}

/// Stores types of information when you expand upon a day under the progress view
struct DayItem: View {
    var expand: Bool
    let index: Int
    let element: Element
    let svm = SharedViewModel()
    
    @State private var expandEntryItem: Bool = false
    @State private var color: Color = .clear
    
    @Binding var reset: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation() { expandEntryItem.toggle() }
            }) {
                HStack {
                    Text("\(element.str[index]) | \(element.preciseDate[index].toStringHour())")
                        .font(._bodyCopyMedium)
                        .foregroundColor(expandEntryItem ? Color.white : Color.BODY_COPY)
                    SmallerArrow()
                        .rotationEffect(Angle(degrees: expandEntryItem ? 90 : 0))
                        .padding(.leading, 5.5)
                    Spacer()
                }
                .padding(4)
            }
            
            if expandEntryItem {
                if element.str[index] == "Vowel" || element.str[index] == "Duration" || element.str[index] == "Rainbow" {
                    RecordingList(createdAt: element.preciseDate[index], reset: $reset)
                        .onAppear() { color = .MEDIUM_PURPLE }
                } else if element.str[index] == "Survey" {
                    SurveyList(createdAt: element.preciseDate[index], reset: $reset)
                        .onAppear() { color = .TEAL }
                } else if element.str[index] == "Journal" {
                    JournalList(createdAt: element.preciseDate[index], reset: $reset)
                        .onAppear() { color = .BLUE }
                }
            }
        }
        .onChange(of: expandEntryItem) { _ in
            if color == .MEDIUM_PURPLE || color == .TEAL || color == .BLUE {
                color = .clear
            }
        }
        .padding(.vertical, 5)
        .foregroundColor(Color.BODY_COPY)
        .background(color)
    }
}

struct ExpandedListItem: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var showMore = true
    let element: Element
    @State private var expand = true
    let svm = SharedViewModel()
    @Binding var reset: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation() {
                    self.showMore.toggle()
                }
            }) {
                HStack(spacing: 0) {
                    Text("\(element.date.dayOfWeek())  ")
                        .font(._bodyCopyBold)
                    Text(element.date.toDay())
                        .font(._bodyCopyMedium)
                    
                    SmallArrow()
                        .rotationEffect(Angle(degrees: showMore ? 90 : 0))
                        .padding(.leading, 5.5)
                    
                    Spacer()
                }
            }
            .padding(.bottom, 4)
            
            if showMore {
                VStack(spacing: 0) {
                    ForEach(0..<element.str.count) { index in
                        Color.BODY_COPY.frame(height: 1).opacity(0.6)
                        ExpandedDayItem(expand: $expand, index: index, element: element, reset: $reset)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .foregroundColor(Color.BODY_COPY)
        .background(showMore ? Color.INPUT_FIELDS : Color.white)
    }
}

/// Stores types of information when you expand upon a day under the progress view
struct ExpandedDayItem: View {
    @Binding var expand: Bool
    let index: Int
    let element: Element
    let svm = SharedViewModel()
    
    @State private var expandEntryItem: Bool = true
    @State private var color: Color = .clear
    
    @Binding var reset: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation() { expandEntryItem.toggle() }
            }) {
                HStack {
                    Text("\(element.str[index]) | \(element.preciseDate[index].toStringHour())")
                        .font(._bodyCopyMedium)
                        .foregroundColor(expandEntryItem ? Color.white : Color.BODY_COPY)
                    SmallerArrow()
                        .rotationEffect(Angle(degrees: expandEntryItem ? 90 : 0))
                        .padding(.leading, 5.5)
                    Spacer()
                }
                .padding(4)
            }
            
            if expandEntryItem {
                if element.str[index] == "Vowel" || element.str[index] == "Duration" || element.str[index] == "Rainbow" {
                    RecordingList(createdAt: element.preciseDate[index], reset: $reset)
                        .onAppear() { color = .MEDIUM_PURPLE }
                } else if element.str[index] == "Survey" {
                    SurveyList(createdAt: element.preciseDate[index], reset: $reset)
                        .onAppear() { color = .TEAL }
                } else if element.str[index] == "Journal" {
                    JournalList(createdAt: element.preciseDate[index], reset: $reset)
                        .onAppear() { color = .BLUE }
                }
            }
        }
        .onChange(of: expandEntryItem) { _ in
            if color == .MEDIUM_PURPLE || color == .TEAL || color == .BLUE {
                color = .clear
            }
        }
        .padding(.vertical, 5)
        .foregroundColor(Color.BODY_COPY)
        .background(color)
    }
}
