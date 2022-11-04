//
//  VoMoApp.swift
//  VoMo
//
//  Created by Neil McGrogan on 1/19/22.
//

import SwiftUI
import UIKit

@main
struct VoMoApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .dynamicTypeSize(.medium)
        }
    }
}

struct SplashScreen: View {
    @State var animate = false
    @State var endSplash = false
    @State var hideAnimation = false
    
    let bg = "LaunchBackground"
    let lg = "LaunchLogo"
    
    var body: some View {
        if !hideAnimation {
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
            ViewController()
                .environmentObject(ViewRouter())
                .environmentObject(AudioRecorder())
                .environmentObject(Entries())
                .environmentObject(Settings())
                .environmentObject(Notification())
                .foregroundColor(Color.black)
                .background(Color.white)
                .preferredColorScheme(.light)
        }
    }
    
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

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
