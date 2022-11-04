//
//  ViewController.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI
import UIKit

struct ViewController: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var notification: Notification
    @EnvironmentObject var settings: Settings
    @State private var variablePadding: CGFloat = 0
    let svm = SharedViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            currentPage
            
            Spacer()
            
            if !settings.keyboardShown && viewRouter.currentPage != .onboard && viewRouter.currentPage != .home {
                tabBar
                    .padding(.bottom, self.variablePadding)
            }
        }
        .onAppear() {
            var keyWindow: UIWindow? {
                return UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .first(where: { $0 is UIWindowScene })
                    .flatMap({ $0 as? UIWindowScene })?.windows
                    .first(where: \.isKeyWindow)
            }
            if keyWindow!.safeAreaInsets.bottom > 0 {
                self.variablePadding = 0
            } else {
                self.variablePadding = 17.5
            }
            notification.requestPermission()
            notification.updateNotifications(triggers: settings.triggers())
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
            case .questionnaire:
                QuestionnaireView()
            case .journal:
                JournalView()
            case .intervention:
                InterventionView()
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
            .environmentObject(ViewRouter())
            .environmentObject(Notification())
            .environmentObject(Settings())
    }
}
