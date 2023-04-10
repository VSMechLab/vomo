//
//  ViewModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .home
    
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

enum Page {
    case onboard, home, settings, record, questionnaire, journal, treatment, progress
}
