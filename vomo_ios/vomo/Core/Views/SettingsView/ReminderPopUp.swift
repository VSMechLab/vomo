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
        
        NavigationView {
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
                        .transition(.slideUp)
                }
                
                Spacer()
            }
            
            .animation(.spring(), value: notifications.notificationsOn)
            .padding()
            .padding(.vertical)
        }
        
        .frame(width: svm.content_width, height: 350)
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
                    HStack(spacing: 4) {
                        Text("Please enable in settings")
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                        .font(._buttonFieldCopy)
                        .foregroundColor(Color.DARK_PURPLE)
                }
            }
        }
    }
    
    private var notificationTimeSelection: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            Divider()
            
            HStack {
                Text("Remind Me")
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
            
            Toggle(isOn: $notifications.autoSchedule) {
                Text("Auto Schedule")
                    .font(._BTNCopy)
            }
            .tint(Color.MEDIUM_PURPLE)
            
            HStack {
                Text("Frequency")
                    .font(._BTNCopy)
                Spacer()
                Picker("Frequency", selection: .constant(Notification.Frequency.daily)) {
                    ForEach(Notification.Frequency.allCases, id: \.self) { frequency in
                        Text(frequency.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .tint(.black)
            }
            
            if (!notifications.autoSchedule) {
                NavigationLink {
                    NotificationFrequencySelection()
                } label: {
                    HStack {
                        Text("Frequency")
                            .font(._BTNCopy)
                        Spacer()
                        HStack {
                            Text("Daily")
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                        }

                    }
                }
                .transition(.slideUp)
                .buttonStyle(.borderless)
                .tint(.black)
                .padding(.top, 10)
            }
        }
        .animation(.spring(), value: notifications.autoSchedule)
    }
    
    // fileprivate struct so that it can be showed in previews
    fileprivate struct NotificationFrequencySelection: View {
        
        @Environment(\.dismiss) var dismiss
        @EnvironmentObject var notifications: Notification
        
        var body: some View {
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(1..<7) { num in
                        HStack {
                            Button {
                                // select
                            } label: {
                                HStack {
                                    Text("^[\(num) day](inflect: true)")
                                        .font(._BTNCopyUnbold)
                                    Spacer()
                                    
                                    Image(systemName: notifications.frequency == num ? "circle.inset.filled" : "circle")
                                        .foregroundColor(notifications.frequency == num ? Color.MEDIUM_PURPLE : .black)
                                        .font(.system(size: 20))
                                }
                                .padding(.vertical, 5)
                            }
                            .buttonStyle(.borderless)
                            .tint(.black)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 15)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Notify Me Every")
                        .font(._BTNCopy)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 12))
                            Text("Back")
                                .font(._lastUsed)
                        }
                    }
                    .buttonStyle(.plain)
                }
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
            .previewDisplayName("Pop Up")
        
        NavigationView {
            ReminderPopUp.NotificationFrequencySelection()
                .environmentObject(previewNotificationService)
        }
        .frame(width: 340, height: 350)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 5)
        .previewDisplayName("Frequency Selection")
    }
}
