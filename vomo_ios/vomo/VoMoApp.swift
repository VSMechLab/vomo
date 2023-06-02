//
//  VoMoApp.swift
//  VoMo
//
//  Created by Neil McGrogan on 1/19/22.
//

import SwiftUI
import UIKit

/// Main thread in which the app is called
@main
struct VoMoApp: App {
    
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .dynamicTypeSize(.medium)
        }
    }
}

/// Shows app opening annimation, then shows the view controller which serves different views
struct LaunchScreen: View {
    @State var animate = false
    @State var endSplash = false
    @State var hideAnimation = false
    
    let bg = "LaunchBackground"
    let lg = "LaunchLogo"
    
    var body: some View {
        if !hideAnimation {
            /*
             
             Upon launch of the app, logo is shown then animates out after a fraction of a second
             After this time, hideAnimation is set to false, switching the view over to showing ViewController
             
            */
            ZStack(alignment: .center) {
                Color.BLUE
                    .edgesIgnoringSafeArea(.all)
                
                Image(lg)
                    .resizable()
                    .renderingMode(.original)
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: animate ? .fill : .fit)
                    .frame(width: animate ? nil : 1, height: animate ? nil : 1)
                    .scaleEffect(animate ? 3 : 1)
                    .frame(width: UIScreen.main.bounds.width)
            }
            .ignoresSafeArea(.all, edges: .all)
            .onAppear(perform: animateSplash)
            .opacity(endSplash ? 0 : 1)
        } else {
            /*
             
             ViewController is shown, environment variables are called here
             These environment variables are models that contain useful information about the app
             
             ViewRouter - sets the current page being served
             AudioRecorder - stores audio files, saved processings of files and functions for the files
             Entries - stores journals, surveys and treatments
             Settings - stores the users information like date of birth, sex, gender etc
             Notifications - queues notifications
             
            */
            ViewController()
                .environmentObject(ViewRouter.shared)
                .environmentObject(AudioRecorder())
                .environmentObject(Entries())
                .environmentObject(Settings())
                .environmentObject(Notification.shared)
        }
    }
    
    /// Animates the logo on the screen when the app is launched
    func animateSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(Animation.easeOut(duration: 0.45)) {
                animate.toggle()
            }
            withAnimation(Animation.linear(duration: 0.35)) {
                endSplash.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.hideAnimation.toggle()
            }
        }
    }
}
