//
//  ViewModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 1/20/22.
//

import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .homeView
    
    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = .onboardView
        } else {
            currentPage = .homeView
        }
    }
}

enum Page {
    case onboardView, personalQuestionView, voiceQuestionView, homeView, recordView, journalView, profileView, targetView, customTargetView, entryView, activityView, playground
}
