//
//  ReminderPopUp.swift
//  VoMo
//
//  Created by Neil McGrogan on 12/2/22.
//

import SwiftUI

struct ReminderPopUp: View {
    @EnvironmentObject var notifications: Notification
    @EnvironmentObject var settings: Settings
    @Binding var showNotifications: Bool
    @State private var showTime: Bool = false
    @State private var date: Date = .now
    let svm = SharedViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Edit your prefered frequency of notifications")
                    .font(._subHeadline)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            onOffButton
            
            if notifications.notificationsOn {
                timeOfDay
            }
        }
        .frame(width: svm.content_width)
        .onAppear() {
            self.notifications.notificationsOn = self.notifications.getStatus()
            
            /*
             var dateComponents = DateComponents()
             
             
             
             for trig in triggers {
                 print("\(Date.now) and \(trig.date)")
                 
                 if trig.date > .now {
                     dateComponents.year = trig.date.splitYear
                     dateComponents.month = trig.date.splitMonth
                     dateComponents.day = trig.date.splitDay
                     dateComponents.hour = preferedHour
                     dateComponents.minute = preferedMinute
             */
            
            var dateComponents = DateComponents()
            dateComponents.hour = notifications.preferedHour
            dateComponents.minute = notifications.preferedMinute
            
            self.date = Calendar.current.date(from: dateComponents) ?? .now
        }
    }
}

extension ReminderPopUp {
    private var onOffButton: some View {
        Group {
            Text("Would you like to be notified?")
                .font(._subsubHeadline)
                .padding(.top)
            
            HStack(spacing: 0) {
                Button("") {
                    withAnimation() {
                        self.notifications.notificationsOn = true
                    }
                }.buttonStyle(YesButton(selected: notifications.notificationsOn))
                Spacer()
                Button("") {
                    withAnimation() {
                        self.notifications.notificationsOn = false
                    }
                }.buttonStyle(NoButton(selected: notifications.notificationsOn))
            }
        }
    }
    
    private var timeOfDay: some View {
        Group {
            HStack {
                Text("Remind me at a time of the day")
                    .font(._subsubHeadline)
                Spacer()
            }
            
            Button(action: {
                withAnimation() {
                    self.showTime.toggle()
                }
            }) {
                HStack {
                    Image(svm.time_img)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40 * 0.8)
                        .padding(.leading)
                    Text(self.date.toStringHour())
                        .font(._fieldCopyRegular)
                    Spacer()
                }
                .padding(.vertical).frame(height: 40)
                .background(Color.INPUT_FIELDS).cornerRadius(10)
            }
            
            ZStack {
                if showTime {
                    DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(maxWidth: 260, maxHeight: 175)
                        .clipped()
                        .onChange(of: date) { _ in
                            self.notifications.preferedHour = date.splitHour
                            self.notifications.preferedMinute = date.splitMinute
                            
                            print("Set to be notified at: \(notifications.preferedHour):\(notifications.preferedMinute)")
                        }
                }
            }
            .transition(.slide)
            
            Text("Let us automatically select your notification frequency")
                .font(._subsubHeadline)
            
            HStack(spacing: 0) {
                Button("") {
                    withAnimation() {
                        self.notifications.autoSchedule = true
                    }
                }.buttonStyle(YesButton(selected: notifications.autoSchedule))
                Spacer()
                Button("") {
                    withAnimation() {
                        self.notifications.autoSchedule = false
                    }
                }.buttonStyle(NoButton(selected: notifications.autoSchedule))
            }
            
            if !notifications.autoSchedule {
                Text("Select your prefered notification frequency")
                    .font(._subsubHeadline)
                
                listOfFrequencies
            }
        }
    }
    
    private var listOfFrequencies: some View {
        ScrollView(showsIndicators: false) {
            ForEach(1...6, id: \.self) { index in
                Button(action: {
                    self.notifications.frequency = index
                    self.notifications.updateNotifications(triggers: settings.editedTrigger(frequency: index))
                }) {
                    ZStack(alignment: .leading) {
                        ZStack {
                            if notifications.frequency == index {
                                Color.MEDIUM_PURPLE
                                    .frame(width: svm.content_width - 2, height: 60)
                            } else {
                                Color.white
                                    .frame(width: svm.content_width - 2, height: 60)
                            }
                            
                            HStack {
                                Image(notifications.frequency == index ? svm.select : svm.unselect)
                                    .resizable()
                                    .frame(width: 27.5, height: 27.5)
                                    .padding(.leading, 15)
                                Spacer()
                            }
                        }
                        .cornerRadius(10)
                        .shadow(color: Color.gray, radius: 1)
                        .padding(1)
                        
                        VStack(alignment: .leading) {
                            Text("Be notified every \(index) days")
                                .foregroundColor(notifications.frequency == index ? Color.white : Color.gray)
                                .font(._buttonFieldCopyLarger)
                                .multilineTextAlignment(.leading)
                        }.padding(.leading, svm.content_width / 7)
                    }
                }
            }
        }
    }
}

struct ReminderPopUp_Previews: PreviewProvider {
    static var previews: some View {
        ReminderPopUp(showNotifications: .constant(false))
            .environmentObject(Notification())
    }
}

/*
 /// Sent to notification service to schedule notifications calculated in real time based on goal considerations
 func triggers() -> [TriggerModel] {
     var ret: [TriggerModel] = []
     
     let amountDays = recordPerWeek * numWeeks
     
     for i in 0..<amountDays {
         ret.append(TriggerModel(date: Date(timeInterval: Double(i) * 86400, since: startDate.toFullDate() ?? .now), identifier: String(i)))
     }
     
     return ret
 }
 */
