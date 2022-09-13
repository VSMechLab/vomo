//
//  GoalEntryView.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/18/22.
//

import UserNotifications
import SwiftUI


struct GoalEntryView: View {
    @EnvironmentObject var notification: Notification
    @EnvironmentObject var settings: Settings
    
    @State private var svm = SharedViewModel()
    @State private var perWeek = 0
    @State private var numWeeks = 0
    
    let perWeekOptions = [1, 2, 3, 4, 5, 6, 7]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            ///
            /// check a function that determines if goal is active, funciton consideres:
            ///     not expired
            ///     set true by boolean
            ///
            /// based on this function we will enter one of two different modes,
            ///     filling out new goal
            ///     informing on current goal
            ///
            /// if newEntry -> settingSection
            ///     ask how many times a week
            ///     ask if want notifiations(On by default ignore smart notification functionality)
            ///     set button sets start time and hides the rest of the page
            ///
            /// else -> informSection
            ///     inform on current attributes of the goal
            ///
            
            header
            
            if settings.isActive() {
                informSection
            } else {
                settingSection
            }
            
            Spacer()
                .padding(.bottom, 50)
        }
        .frame(width: svm.content_width)
    }
}

extension GoalEntryView {
    private var header: some View {
        HStack {
            Text("Goals")
                .font(._headline)
            
            Spacer()
        }
    }
    
    private var informSection: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if settings.isActive() {
                    Text("Your goal is active as of \(settings.startDate)")
                }
                Text("The goal will last \(settings.numWeeks) and you will complete \(settings.perWeek) enteries per week")
                Text("Your have entered \(settings.entered) so far")
            }
            .font(._bodyCopy)
            .foregroundColor(Color.BODY_COPY)
            
            Button(action: {
                self.clearGoal()
            }) {
                HStack {
                    Spacer()
                    ZStack {
                        Image(svm.button_img)
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
        }
    }

    private var settingSection: some View {
        VStack(alignment: .leading) {
            Text("Define your goals here.")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .padding(.bottom)
            
            Text("Number of entries per week")
                .font(._fieldLabel)
            
            Menu {
                Picker("", selection: $perWeek) {
                    ForEach(perWeekOptions, id: \.self) { option in
                        Text("\(option)")
                            .font(._bodyCopy)
                    }
                }
            } label: {
                ZStack {
                    EntryField()
                    
                    HStack {
                        Text("\(perWeek == 0 ? 0 : perWeek) per week")
                            .font(._bodyCopy)
                        Spacer()
                        
                        Arrow()
                    }.padding(.horizontal, 5)
                }
            }
            .padding(.bottom, 10)
            
            Text("Number of weeks to achieve goal")
                .font(._fieldLabel)
            
            Menu {
                Picker("", selection: $numWeeks) {
                    ForEach(perWeekOptions, id: \.self) { option in
                        HStack {
                            Text("\(option)")
                                .font(._bodyCopy)
                        }
                    }
                }
            } label: {
                ZStack {
                    EntryField()
                    
                    HStack {
                        Text(numWeeks == 1 ? "\(numWeeks == 0 ? 0 : numWeeks) week" : "\(numWeeks == 0 ? 0 : numWeeks) weeks")
                            .font(._bodyCopy)
                        Spacer()
                        
                        Arrow()
                    }.padding(.horizontal, 5)
                }
            }
            .padding(.bottom, 10)
            
            Text("Ensure notifications are turned on by going to Settings -> Vomo -> Notifications -> Allow Notifications")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
            Text("If this does not work, delete notifications, redownload the app and allow notifications when the alert appears.")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
            Text("Notifications will be delivered at 7pm every day, as long as the goal is running and set, until more complexity is added into the system")
                .font(._bodyCopy)
                .foregroundColor(Color.BODY_COPY)
                .padding(.bottom)
            
            HStack {
                Spacer()
                
                if numWeeks != 0 && perWeek != 0 {
                    Button(action: {
                        settings.setGoal(nWeeks: numWeeks, nPerWeek: perWeek)
                        
                        notification.updateNotifications(triggers: settings.triggers())
                    }) {
                        SubmissionButton(label: "SET GOAL")
                    }
                    .padding(.top, 10)
                } else {
                    SubmissionButton(label: "SET GOAL")
                    .padding(.top, 10)
                }
                
                Spacer()
            }
        }
        .foregroundColor(Color.black)
    }
    
    func clearGoal() {
        self.numWeeks = 0
        self.perWeek = 0
        self.settings.clearGoal()
    }
}

struct GoalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        GoalEntryView()
            .environmentObject(Notification())
    }
}
