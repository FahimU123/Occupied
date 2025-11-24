//
//  OccupiedApp.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YourApp: App {
    var authViewModel = AuthViewModel()
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authViewModel.isLoading {
                    ProgressView()
                } else if authViewModel.isAuthenticated {
                    ContentView()
                        .environment(authViewModel)
                } else {
                    // FIXME: get another image
                    ContentUnavailableView("Cannot connet to server, try again later", image: "loading")
                }
            }
            .onAppear {
                authViewModel.checkAuthentication()
            }
        }
        
    }
}

// EDGE CASES:
// What if someone forgets to check out
// What do we show if no room joined at all
// cannot delet ubsless you are owner
