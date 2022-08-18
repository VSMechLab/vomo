//
//  GoalsNotifications.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/18/22.
//

import UserNotifications
import SwiftUI

struct GoalsNotifications: View {
    @EnvironmentObject var goal: Goal
    
    @State private var svm = SharedViewModel()
    
    let arrow_img = "VM_Dropdown-Btn"
    let perWeekOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let button_img = "VM_Gradient-Btn"
    
    var body: some View {
        VStack(alignment: .leading) {
            /*
            HStack {
                Text("Trg entries per week: \(goal.perWeek)\nTrg amount of weeks: \(goal.numWeeks)\nStart date: \(goal.startDate)\nEntered so far: \(goal.entered)")
                Text("Notif on: \(goal.notificationToggle ? "true" : "false")\nSmart Notif: \(goal.smartNotificationToggle ? "true" : "false")\nNotif Freq: \(goal.notificationFrequency)\n")
            }
            */
            header
            
            if self.goal.isActive() {
                Button(action: {
                    goal.clearGoal()
                }) {
                    HStack {
                        Spacer()
                        ZStack {
                            Image(button_img)
                                .resizable()
                                .frame(width: 225, height: 40)
                            
                            Text("RESET GOAL")
                                .font(._BTNCopy)
                                .foregroundColor(Color.white)
                        }
                        .padding(.top, 10)
                        Spacer()
                    }
                }
            } else {
                perWeek
                
                numWeeks
                
                notificationToggle
                
                VStack {
                    if self.goal.notificationToggle {
                        smartNotificationToggle
                        
                        if !self.goal.smartNotificationToggle {
                            notificationFrequency
                        }
                    }
                }
                .transition(.slide)
                
                HStack {
                    Spacer()
                    Button(action: {
                        let newDate: Date = .now
                        goal.startDate = newDate.toStringDay()
                        
                        if goal.notificationToggle {
                            self.goal.scheduleNotifications()
                        }
                        
                        self.goal.goalSet = true
                    }) {
                        SubmissionButton(label: "SET GOAL")
                            .font(._BTNCopy)
                            .foregroundColor(Color.white)
                    }
                    .padding(.top, 10)
                    Spacer()
                }
            }
        }
        .padding(.bottom, 100)
        .frame(width: svm.content_width)
        
    }
}

extension GoalsNotifications {
    private var header: some View {
        VStack(alignment: .leading) {
            Text("Goals")
                .font(._headline)
            
            if goal.isActive() {
                VStack(alignment: .leading) {
                    if goal.isActive() {
                        Text("Your goal is active as of \(goal.startDate.toDate()?.toViewableDate() ?? "") at \(goal.startDate.toDate()?.toViewableTime() ?? "")")
                    }
                    Text("The goal will last \(goal.numWeeks) and you will complete \(goal.perWeek) enteries per week")
                    Text("Your have entered \(goal.entered) so far")
                }
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
            } else {
                Text("Define your goals here.")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                    .padding(.bottom)
            }
        }
    }
    
    private var notificationToggle: some View {
        VStack(alignment: .leading) {
            Text("Would you like notifications to be on?")
                .font(._fieldCopyRegular)
            
            HStack(spacing: 0) {
                Button("") {
                    withAnimation() {
                        self.goal.notificationToggle = true
                    }
                }.buttonStyle(YesButton(selected: goal.notificationToggle))
                Spacer()
                Button("") {
                    withAnimation() {
                        self.goal.notificationToggle = false
                        self.goal.clearNotifications()
                    }
                }.buttonStyle(NoButton(selected: goal.notificationToggle))
            }
        }
    }
    
    private var smartNotificationToggle: some View {
        VStack(alignment: .leading) {
            Text("Would you like smart notifications to be on?")
                .font(._fieldCopyRegular)
            
            Text("Smart notifcations only notify you when making another recording is necessary to stay on track with your goal. We'll never send you more than one notification per day.")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
            
            HStack(spacing: 0) {
                Button("") {
                    withAnimation() {
                        self.goal.smartNotificationToggle = true
                    }
                }.buttonStyle(YesButton(selected: goal.smartNotificationToggle))
                Spacer()
                Button("") {
                    withAnimation() {
                        self.goal.smartNotificationToggle = false
                    }
                }.buttonStyle(NoButton(selected: goal.smartNotificationToggle))
            }
        }
    }
    
    private var notificationFrequency: some View {
        VStack(alignment: .leading) {
            Text("How often would you like to recieve notifications?")
                .font(._fieldCopyRegular)
            
            HStack(spacing: 0) {
                Button("") {
                    withAnimation() {
                        self.goal.notificationFrequency = "Daily"
                    }
                }.buttonStyle(DailyButton(selected: goal.notificationFrequency))
                Spacer()
                Button("") {
                    withAnimation() {
                        self.goal.notificationFrequency = "Weekly"
                    }
                }.buttonStyle(WeeklyButton(selected: goal.notificationFrequency))
            }
        }
    }
    
    private var perWeek: some View {
        VStack(alignment: .leading) {
            Text("Goal 1: Number of entries per week")
                .font(._fieldCopyRegular)
            
            Menu {
                Picker("2x week", selection: $goal.perWeek) {
                    ForEach(perWeekOptions, id: \.self) { option in
                        Text("\(option)")
                            .font(._bodyCopy)
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
            } label: {
                ZStack {
                    EntryField()
                    
                    HStack {
                        Text("\(goal.perWeek == 0 ? 0 : goal.perWeek)x per week")
                            .font(._bodyCopy)
                        Spacer()
                        Image(arrow_img)
                            .resizable()
                            .frame(width: 20, height: 10)
                            //.rotationEffect(Angle(degrees:   ? 180 : 0))
                    }.padding(.horizontal, 5)
                }
                
            }
            .frame(maxHeight: 400)
        }
    }
    
    private var numWeeks: some View {
        VStack(alignment: .leading) {
            Text("Goal 2: Number of weeks to achieve goal")
                .font(._fieldCopyRegular)
            
            Menu {
                Picker("2x week", selection: $goal.numWeeks) {
                    ForEach(perWeekOptions, id: \.self) { option in
                        HStack {
                            Text("\(option)")
                                .font(._bodyCopy)
                        }
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
            } label: {
                ZStack {
                    EntryField()
                    
                    HStack {
                        Text(goal.numWeeks == 1 ? "\(goal.numWeeks == 0 ? 0 : goal.numWeeks) week" : "\(goal.numWeeks == 0 ? 0 : goal.numWeeks) weeks")
                            .font(._bodyCopy)
                        Spacer()
                        Image(arrow_img)
                            .resizable()
                            .frame(width: 20, height: 10)
                    }.padding(.horizontal, 5)
                }
            }
            .frame(maxHeight: 400)
        }
    }
}

struct DailyButton: ButtonStyle {
    let selected: String
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    
    @State private var svm = SharedViewModel()
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Image(selected == "Daily" ? select_img : unselect_img)
                .resizable()
                .scaledToFit()
            
            HStack {
                Text("Daily")
                    .font(._buttonFieldCopy)
                    .foregroundColor(selected == "Daily" ? Color.white : Color.BODY_COPY)
                    .padding(.leading, 26)
                
                Spacer()
            }
        }
    }
}

struct WeeklyButton: ButtonStyle {
    let selected: String
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Image(selected == "Daily" ? unselect_img : select_img)
                .resizable()
                .frame(height:  35)
            
            HStack {
                Text("Weekly")
                    .font(._buttonFieldCopy)
                    .foregroundColor(selected == "Daily" ? Color.BODY_COPY : Color.white)
                    .padding(.leading, 26)
                
                Spacer()
            }
        }
    }
}
