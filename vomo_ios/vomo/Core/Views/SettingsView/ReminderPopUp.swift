//
//  ReminderPopUp.swift
//  VoMo
//
//  Created by Neil McGrogan on 12/2/22.
//

import SwiftUI

struct ReminderPopUp: View {
    @Environment(\.openURL) var openURL
    
    @EnvironmentObject var notifications: Notification
    @EnvironmentObject var settings: Settings
    @Binding var showNotifications: Bool
    @State private var showTime: Bool = false
    @State private var date: Date = .now
    let svm = SharedViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Notification Settings")
                    .font(._title1)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            notificationsToggle
                        
            if notifications.notificationsOn {
                notificationTimeSelection
                notificationFrequencySelection
            }
        }
        .padding()
        .padding(.vertical)
        .frame(width: svm.content_width)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 5)
    }
}

extension ReminderPopUp {
    
    private var notificationsToggle: some View {
        
        VStack(alignment: .leading) {
            
            Toggle(isOn: $notifications.notificationsOn) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Receive Notifications")
                        .font(._BTNCopy)
                    if (!notifications.getStatus()) {
                        HStack(spacing: 5) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(.red)
                            Text("Please enable in iOS settings")
                                .font(._fieldCopyRegular)
                        }
                    }
                }
            }
            .tint(Color.MEDIUM_PURPLE)
            
            if (!notifications.getStatus()) {
                Button {
                    if #available(iOS 16, *) {
                        openURL(URL(string: UIApplication.openNotificationSettingsURLString)!)
                    } else {
                        openURL(URL(string: UIApplication.openSettingsURLString)!)
                    }
                } label: {
                    Text("Open Settings")
                        .font(._buttonFieldCopy)
                        .foregroundColor(Color.DARK_PURPLE)
                }
            }
        }
    }
    
    private var notificationTimeSelection: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Text("Remind Me:")
                    .font(._BTNCopy)

                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.graphical)
                    .onChange(of: date) { _ in
                        self.notifications.preferedHour = date.splitHour
                        self.notifications.preferedMinute = date.splitMinute
                        
                        Logging.defaultLog.notice("Set to be notified at: \(notifications.preferedHour):\(notifications.preferedMinute)")
                    }
                    .onAppear() {
                        var dateComponents = DateComponents()
                        dateComponents.hour = notifications.preferedHour
                        dateComponents.minute = notifications.preferedMinute
                        
                        self.date = Calendar.current.date(from: dateComponents) ?? .now
                    }
                    .tint(.MEDIUM_PURPLE)
                    .offset(x: 10.0, y: 0)
            }
        }
    }
    
    private var notificationFrequencySelection: some View {
        
        VStack(alignment: .center) {
            
            
            
        }
    }
    
    private var timeOfDay: some View {
        Group {
            HStack {
                Text("Remind me at:")
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
                            
                            Logging.defaultLog.notice("Set to be notified at: \(notifications.preferedHour):\(notifications.preferedMinute)")
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
    
    static let previewNotificationService = Notification()
    
    static var previews: some View {
        ReminderPopUp(showNotifications: .constant(false))
            .environmentObject(previewNotificationService)
            .onAppear() {
                previewNotificationService.notificationsOn = true
            }
    }
}
