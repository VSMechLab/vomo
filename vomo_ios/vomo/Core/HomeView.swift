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
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        ZStack {
            HomeBackground()
            quickLinks
        }
    }
}

extension HomeView {
    private var quickLinks: some View {
        VStack(spacing: 20) {
            Text("Home")
                .font(._title)
            
            // Nothing left to do as of yet
            Button("Settings") {
                viewRouter.currentPage = .settings
            }.foregroundColor(Color.green)
            
            // Selecting certain options will mess with what task is saved
            // Fix that issue
            Button("Record") {
                viewRouter.currentPage = .record
            }.foregroundColor(Color.yellow)
            
            // Good for now
            Button("Questionnaire") {
                viewRouter.currentPage = .questionnaire
            }.foregroundColor(Color.green)
            
            // Done button sometimes does not show up
            Button("Journal") {
                viewRouter.currentPage = .journal
            }.foregroundColor(Color.yellow)
            
            // Nothing left to do as of yet
            Button("My Progress") {
                viewRouter.currentPage = .progress
            }.foregroundColor(Color.green)
            
            // Add/Complete this view
            Button("Intervention Log") {
                viewRouter.currentPage = .intervention
            }.foregroundColor(Color.red)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AudioRecorder())
            .environmentObject(Entries())
    }
}
