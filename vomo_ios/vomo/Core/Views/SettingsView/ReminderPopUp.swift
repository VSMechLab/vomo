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
//    @State private var date: Date = .now
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
                
                DatePicker("", selection: $notifications.notificationSettings.time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.graphical)
                    .tint(.MEDIUM_PURPLE)
                    .offset(x: 10.0, y: 0)
            }
            
            Toggle(isOn: $notifications.autoSchedule) {
                Text("Auto Schedule")
                    .font(._BTNCopy)
            }
            .tint(Color.MEDIUM_PURPLE)
            
            if (!notifications.autoSchedule) {
                NavigationLink {
                    NotificationFrequencySelection()
                } label: {
                    HStack {
                        Text("Frequency")
                            .font(._BTNCopy)
                        Spacer()
                        HStack {
                            Text("\(notifications.notificationSettings.frequency.rawValue)")
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
            VStack(spacing: 15) {
                Divider()
                ForEach(Notification.Frequency.allCases, id: \.self) { frequency in
                    HStack {
                        Button {
                            notifications.notificationSettings.frequency = frequency
                        } label: {
                            HStack(spacing: 10) {
                                
                                Image(systemName: (frequency == notifications.notificationSettings.frequency) ? "circle.inset.filled" : "circle")
                                    .font(.system(size: 20))
                                
                                Text(frequency.rawValue)
                                    .font(._BTNCopy)
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                        .buttonStyle(.plain)
                        .tint(.black)
                        
                        if (frequency == notifications.notificationSettings.frequency && frequency == .custom) {
                            Stepper("^[\(notifications.notificationSettings.customFrequency) day](inflect: true)", value: $notifications.notificationSettings.customFrequency, in: 1...30)
                        }
                        
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
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
