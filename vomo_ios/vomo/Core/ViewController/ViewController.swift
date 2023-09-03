//
//  ViewController.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI
import Foundation
import UIKit

/*
 
 Container view storing the tab view and which views get served
 
 */

struct ViewController: View {
    
    @Environment(\.scenePhase) var scene
    
    @ObservedObject var audioRecorder = AudioRecorder.shared
    @ObservedObject var notification: NotificationService = .shared

    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settings: Settings
    @State private var variablePadding: CGFloat = 0
    let svm = SharedViewModel()
    
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer().frame(height: 1)
            
            currentPage
            
            Spacer()
            
            if !settings.keyboardShown && viewRouter.currentPage != .onboard && !focused {
                tabBar
                    .padding(.bottom, variablePadding)
            }
        }
        .foregroundColor(Color.black)
        .background(Color.white)
        .preferredColorScheme(.light)
        .onAppear() {
            
            var keyWindow: UIWindow? {
                return UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .first(where: { $0 is UIWindowScene })
                    .flatMap({ $0 as? UIWindowScene })?.windows
                    .first(where: \.isKeyWindow)
            }

            if keyWindow?.safeAreaInsets.bottom ?? 0 > 0 {
                self.variablePadding = 0
            } else {
                self.variablePadding = 17.5
            }
            
            // TODO: Move requesting permissions to a different spot (e.g. in onboarding flow)
            notification.requestPermission()
            
//            let group = DispatchGroup()
//            let labelGroup = String("test")
//            group.enter()
//
//            let dispatchQueue = DispatchQueue(label: labelGroup, qos: .background)
//            dispatchQueue.async(group: group, execute: {
//                audioRecorder.syncEntries(gender: settings.gender)
//            })
            
//            group.leave()
//            group.notify(queue: DispatchQueue.main, execute: {
//                Logging.defaultLog.notice("Synced all recordings!")
//            })
        }
        
        .onChange(of: scene) { newScenePhase in
            switch newScenePhase {
                case .background:
                    notification.scheduleNotifications()
                    break
                case .inactive:
                    break
                case .active:
                    break
                @unknown default:
                    Logging.defaultLog.warning("Unknown scene phase encountered")
            }
        }
        
        .onChange(of: audioRecorder.recording) { _ in
            Logging.defaultLog.debug("Recording status: \(audioRecorder.recording)")
        }
    }
}

extension ViewController {
    private var currentPage: some View {
        Group {
            switch viewRouter.currentPage {
            case .onboard:
                OnboardView()
            case .home:
                HomeView()
            case .settings:
                SettingsView()
            case .record:
                RecordView()
//                FeedbackRecordView()
//                ExerciseSelectionView()
            case .questionnaire:
                SurveyView()
            case .journal:
                JournalView()
            case .treatment:
                TreatmentView()
            case .progress:
                ProgressView()
            }
        }
    }
    /*
    let home_icon = "VM_home-nav-icon"
    let record_icon = "VoMo-App-Outline_8_RECORD_BTN_PRPL"
    let selected_record_icon = "VoMo-App-Outline_8_RECORD_BTN_GREY"
    let  = "VoMo-App-Outline_8_PROGRESS_BTN_GREY"
    let selected_progress_icon = "VoMo-App-Outline_8_PROGRESS_BTN_PRPL"
    */
    private var tabBar: some View {
        HStack {
            if audioRecorder.recording {
                VStack(spacing: 5) {
                    Image(svm.home_icon)
                        .tabImage()
                    
                    Text("HOME")
                        .font(Font._tabTitle)
                        .foregroundColor(Color.gray)
                }.frame(width: UIScreen.main.bounds.width / 3)
                
                VStack(spacing: 5) {
                    Image(viewRouter.currentPage == .record ? svm.record_icon : svm.selected_record_icon)
                        .resizable()
                        .frame(width: 20.0, height: 27.5)
                    
                    Text("RECORDING")
                        .font(Font._tabTitle)
                        .foregroundColor(viewRouter.currentPage == .record ? Color.DARK_PURPLE : Color.gray)
                }.frame(width: UIScreen.main.bounds.width / 3)
                
                VStack(spacing: 5) {
                    Image(viewRouter.currentPage == .progress ? svm.selected_progress_icon : svm.progress_icon)
                        .resizable()
                        .frame(width: 35, height: 27.5)
                    
                    Text("PROGRESS")
                        .font(Font._tabTitle)
                        .foregroundColor(viewRouter.currentPage == .progress ? Color.DARK_PURPLE : Color.gray)
                }.frame(width: UIScreen.main.bounds.width / 3)
            } else {
                Button(action: {
                    viewRouter.currentPage = .home
                }) {
                    VStack(spacing: 5) {
                        Image(svm.home_icon)
                            .tabImage()
                        
                        Text("HOME")
                            .font(Font._tabTitle)
                            .foregroundColor(Color.gray)
                    }.frame(width: UIScreen.main.bounds.width / 3)
                }
                
                Button(action: {
                    viewRouter.currentPage = .record
                }) {
                    VStack(spacing: 5) {
                        Image(viewRouter.currentPage == .record ? svm.record_icon : svm.selected_record_icon)
                            .resizable()
                            .frame(width: 20.0, height: 27.5)
                        
                        Text("RECORDING")
                            .font(Font._tabTitle)
                            .foregroundColor(viewRouter.currentPage == .record ? Color.DARK_PURPLE : Color.gray)
                    }.frame(width: UIScreen.main.bounds.width / 3)
                }
                Button(action: {
                    viewRouter.currentPage = .progress
                }) {
                    VStack(spacing: 5) {
                        Image(viewRouter.currentPage == .progress ? svm.selected_progress_icon : svm.progress_icon)
                            .resizable()
                            .frame(width: 35, height: 27.5)
                        
                        Text("PROGRESS")
                            .font(Font._tabTitle)
                            .foregroundColor(viewRouter.currentPage == .progress ? Color.DARK_PURPLE : Color.gray)
                    }.frame(width: UIScreen.main.bounds.width / 3)
                }
            }
            
        }
        .font(._tabBarFont)
        .frame(width: UIScreen.main.bounds.width)
        .padding(.bottom, -5)
        .padding(.top, 7.5)
        .background(Color.white)
        .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 0)
    }
}

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewController()
            .environmentObject(ViewRouter.shared)
            .environmentObject(Settings())
            .environmentObject(AudioRecorder())
    }
}
