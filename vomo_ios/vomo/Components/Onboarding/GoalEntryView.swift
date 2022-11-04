//
//  GoalEntryView.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/1/22.
//

import SwiftUI

struct GoalEntryView: View {
    @EnvironmentObject var notification: Notification
    @EnvironmentObject var settings: Settings
    
    @State private var svm = SharedViewModel()
    @State private var recordPerWeek = 0
    @State private var questsPerWeek = 0
    @State private var journalsPerWeek = 0
    @State private var numWeeks = 0
    
    let perWeekOptions = [1, 2, 3, 4, 5, 6, 7]
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            header
            
            if settings.isActive() {
                informSection
            } else {
                settingSection
            }
            
            Spacer()
        }
        .frame(width: svm.content_width)
    }
}

extension GoalEntryView {
    private var header: some View {
        HStack {
            Text("Goals")
                .font(._title)
            
            Spacer()
        }.padding(.vertical)
    }
    
    private var informSection: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if settings.isActive() {
                    Text("Your goal is active as of \(settings.startDate).")
                        .padding(.vertical, 5)
                }
                Text("The goal will last \(settings.numWeeks) weeks and you will complete \(settings.recordPerWeek) recordings, \(settings.journalsPerWeek) journals, and \(settings.surveysPerWeek) questionnaires,  per week.")
                
                VStack {
                    HStack(spacing: 5) {
                        Circle().foregroundColor(.black).frame(width: 8, height: 8)
                        Text("Your have entered \(settings.recordEntered) recordings so far")
                        Spacer()
                    }
                    HStack(spacing: 5) {
                        Circle().foregroundColor(.black).frame(width: 8, height: 8)
                        Text("Your have entered \(settings.journalEntered) journals so far")
                        Spacer()
                    }
                    HStack(spacing: 5) {
                        Circle().foregroundColor(.black).frame(width: 8, height: 8)
                        Text("Your have entered \(settings.surveyEntered) questionnaires so far")
                        Spacer()
                    }
                }
                .padding(.vertical)
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
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text("Number of recordings per week")
                            .font(._fieldLabel)
                        
                        Menu {
                            Picker("", selection: $recordPerWeek) {
                                ForEach(perWeekOptions, id: \.self) { option in
                                    Text("\(option)")
                                        .font(._bodyCopy)
                                }
                            }
                        } label: {
                            ZStack {
                                EntryField()
                                
                                HStack {
                                    Text("\(recordPerWeek == 0 ? 0 : recordPerWeek) per week")
                                        .font(._bodyCopy)
                                    Spacer()
                                    
                                    Arrow()
                                }.padding(.horizontal, 5)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    
                    Group {
                        Text("Number of questionnaires per week")
                            .font(._fieldLabel)
                        
                        Menu {
                            Picker("", selection: $questsPerWeek) {
                                ForEach(perWeekOptions, id: \.self) { option in
                                    Text("\(option)")
                                        .font(._bodyCopy)
                                }
                            }
                        } label: {
                            ZStack {
                                EntryField()
                                
                                HStack {
                                    Text("\(questsPerWeek == 0 ? 0 : questsPerWeek) per week")
                                        .font(._bodyCopy)
                                    Spacer()
                                    
                                    Arrow()
                                }.padding(.horizontal, 5)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    
                    Group {
                        Text("Number of journals per week")
                            .font(._fieldLabel)
                        
                        Menu {
                            Picker("", selection: $journalsPerWeek) {
                                ForEach(perWeekOptions, id: \.self) { option in
                                    Text("\(option)")
                                        .font(._bodyCopy)
                                }
                            }
                        } label: {
                            ZStack {
                                EntryField()
                                
                                HStack {
                                    Text("\(journalsPerWeek == 0 ? 0 : journalsPerWeek) per week")
                                        .font(._bodyCopy)
                                    Spacer()
                                    
                                    Arrow()
                                }.padding(.horizontal, 5)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    
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
                    
                    Text("Ensure notifications are turned on by going to Settings -> Vomo -> Notifications -> Allow Notifications.")
                        .font(._bodyCopy)
                        .foregroundColor(Color.BODY_COPY)
                        .padding(.bottom)
                    
                    HStack {
                        Spacer()
                        
                        Button("SET GOAL") {
                            if numWeeks != 0 {
                                settings.setGoal(nWeeks: numWeeks, records: recordPerWeek, quests: questsPerWeek, journs: journalsPerWeek)
                                
                                notification.updateNotifications(triggers: settings.triggers())
                            }
                        }.buttonStyle(SubmitButton())
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                }
            }
        }
        .foregroundColor(Color.black)
    }
    
    func clearGoal() {
        self.numWeeks = 0
        self.recordPerWeek = 0
        self.journalsPerWeek = 0
        self.questsPerWeek = 0
        self.settings.clearGoal()
    }
}

struct GoalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        GoalEntryView()
            .environmentObject(Notification())
            .environmentObject(Settings())
    }
}
