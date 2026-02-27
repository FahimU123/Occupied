//
//  OnboardingViewModel.swift
//  Occupied
//
//  Created by Fahim Uddin on 1/7/26.
//

import SwiftUI
import RevenueCat

@Observable
@MainActor
final class OnboardingViewModel {
    var isPremium = false
    
    func checkEntitlement() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            isPremium = customerInfo.entitlements["Room Status Live Pro"]?.isActive == true
        } catch {
            print("Entitlement check failed: \(error)")
        }
    }
    
    func completePurchase() {
        isPremium = true
        UserDefaults.standard.set(true, forKey: "has_completed_onboarding")
    }
    
    func completeAsEmployee() {
        isPremium = false
        UserDefaults.standard.set(true, forKey: "has_completed_onboarding")
    }
}
