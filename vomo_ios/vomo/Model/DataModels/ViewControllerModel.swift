//
//  ViewModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import SwiftUI

/// ViewRouter - sets the current page being served
class ViewRouter: ObservableObject {
    
    /// Future deprecation
    @Published var currentPage: Page = .home
    
    @Published var currentTab: Tab = .home
    
    enum Tab: Int {
        case home, recording, progress, settings
    }
    
    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = .onboard
        } else {
            // Prod mode
            //currentPage = .home
            
            // Test mode
            currentPage = .home
        }
    }
}

/// All available pages that can be served
enum Page {
    case onboard, home, settings, record, questionnaire, journal, treatment, progress
}
