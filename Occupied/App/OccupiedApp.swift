//
//  OccupiedApp.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI
import FirebaseCore
import RevenueCat

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YourApp: App {
    @State private var authViewModel = AuthViewModel()
    @State private var onboardingViewModel = OnboardingViewModel()
    @AppStorage("has_completed_onboarding") private var hasCompletedOnboarding = false
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        Purchases.configure(withAPIKey: "test_lXjwATCWjovpBfzqgUqCivXBqBZ")
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isLoading {
                    ProgressView()
                } else if authViewModel.isAuthenticated {
                    if hasCompletedOnboarding {
                        ContentView(onboardingViewModel: onboardingViewModel)
                            .environment(authViewModel)
                    } else {
                        OnboardingFlowView(onboarding: onboardingViewModel)
                    }
                } else {
                    ContentUnavailableView(
                        "Connection Error",
                        systemImage: "wifi.exclamationmark",
                        description: Text("Cannot connect to server, try again later")
                    )
                }
            }
            .task {
                await authViewModel.checkAuthentication()
                await onboardingViewModel.checkEntitlement()
            }
        }
    }
}
