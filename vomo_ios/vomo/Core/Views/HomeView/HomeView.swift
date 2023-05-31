//
//  HomeView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

/// To do list...
/// Do a final check of the onboarding page, ensure that you can enter onboarding from first launch and from settings without issue.
/// Should goal reset automatically?
/// Fix goal section spacing

struct HomeView: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    @State private var totalProgress = true
    
    let svm = SharedViewModel()
    var body: some View {
        NavigationView {
            quickLinks
                .padding(.vertical)
        }
    }
}

extension HomeView {
    private var quickLinks: some View {
        VStack {
//            settingsSection
            
            greetingSection
            
            Spacer()
            
            progressTitleSection
            
            recordSection
            
            questJournalSection
            
            wavesSection
            
            progressSection
            
            interventionSection
        }
    }
}

extension HomeView {
//    private var settingsSection: some View {
//        HStack {
//            Spacer()
//
//            NavigationLink {
//                SettingsView()
//            } label: {
//                Image(svm.home_settings_img)
//                    .resizable()
//                    .frame(width: 35, height: 35)
//            }
//
////            Button(action: {
////                viewRouter.currentPage = .settings
////            }) {
////                Image(svm.home_settings_img)
////                    .resizable()
////                    .frame(width: 35, height: 35)
////            }
//        }
//        .frame(width: svm.content_width)
//    }
//
    private var greetingSection: some View {
        HStack(spacing: 0) {
            Text("Hi, ")
                .font(._title)
            Text(settings.firstName)
                .foregroundColor(Color.DARK_PURPLE)
                .font(._title)
            Spacer()
        }
        .frame(width: svm.content_width)
    }
    
    private var progressTitleSection: some View {
        HStack(spacing: 0) {
            Spacer()
            Text("Progress ")
            Button(totalProgress ? "towards goal" : "for this week") {
                self.totalProgress.toggle()
            }
            .foregroundColor(Color.DARK_PURPLE)
            Text(".")
                .foregroundColor(Color.TEAL)
            Spacer()
        }
        .font(._title1)
        .frame(width: svm.content_width)
    }
    
    private var recordSection: some View {
        Button(action: {
            viewRouter.currentPage = .record
        }) {
            ZStack {
                ProgressBar(level: settings.recordProgress, color: Color.DARK_PURPLE)
                
                if totalProgress {
                    Image(svm.home_record_img)
                        .resizable()
                        .frame(width: 90, height: 90, alignment: .center)
                } else {
                    Text("\(audioRecorder.recordingsThisWeek())/\(settings.recordPerWeek)\nentered")
                        .font(._subHeadline)
                        .frame(width: 90, height: 90, alignment: .center)
                }
            }
        }
        .frame(width: svm.content_width)
    }
    
    private var questJournalSection: some View {
        HStack {
            Spacer()
            Button(action: {
                viewRouter.currentPage = .questionnaire
            }) {
                ZStack {
                    ProgressBar(level: settings.surveyProgress, color: Color.BLUE)
                    
                    if totalProgress {
                        Image(svm.home_question_img)
                            .resizable()
                            .frame(width: 90, height: 90, alignment: .center)
                    } else {
                        Text("\(entries.surveysThisWeek)/\(settings.surveysPerWeek)\nentered")
                            .font(._subHeadline)
                            .frame(width: 90, height: 90, alignment: .center)
                    }
                }
            }
            Spacer()
            Button(action: {
                viewRouter.currentPage = .journal
            }) {
                ZStack {
                    ProgressBar(level: settings.journalProgress, color: Color.TEAL)
                    
                    if totalProgress {
                        Image(svm.home_journal_img)
                            .resizable()
                            .frame(width: 90, height: 90, alignment: .center)
                    } else {
                        Text("\(entries.journalsThisWeek)/\(settings.journalsPerWeek)\nentered")
                            .font(._subHeadline)
                            .frame(width: 90, height: 90, alignment: .center)
                    }
                }
            }
            Spacer()
        }
        .frame(width: svm.content_width)
    }
    
    private var wavesSection: some View {
        Image(svm.home_wave_img)
            .resizable()
            .frame(width: UIScreen.main.bounds.width, height: 50)
            .padding(.vertical)
    }
    
    private var progressSection: some View {
        Button(action: {
            viewRouter.currentPage = .progress
        }) {
            Image(svm.home_progress_img)
                .resizable()
                .frame(width: svm.content_width, height: 90)
        }
        .padding(.bottom, -10)
        .frame(width: svm.content_width)
    }
    
    private var interventionSection: some View {
        Button(action: {
            viewRouter.currentPage = .treatment
        }) {
            Image(svm.home_intervention_img)
                .resizable()
                .frame(width: svm.content_width, height: 95)
        }
        .frame(width: svm.content_width)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AudioRecorder())
            .environmentObject(Entries())
            .environmentObject(Settings())
    }
}
