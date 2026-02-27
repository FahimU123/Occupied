//
//  PaywallViewModel.swift
//  Occupied
//
//  Created by Fahim Uddin on 1/7/26.
//

import SwiftUI
import RevenueCat

//FIXME: maybe + instead of settigns icon

@MainActor
@Observable
final class PaywallViewModel {
    var currentOffering: Offering?
    var selectedPackage: Package?
    var isPurchasing = false
    var error: Error?
    
    static func formatTrial(_ period: SubscriptionPeriod) -> String {
        switch period.unit {
        case .day: return "\(period.value) Days"
        case .week: return "\(period.value) Weeks"
        case .month: return "\(period.value) Months"
        case .year: return "\(period.value) Years"
        default: return "Trial"
            
        }
    }
    
    func fetchOfferings() async {
        do {
            let offerings = try await Purchases.shared.offerings()
            if let current = offerings.current {
                currentOffering = current
                selectedPackage = current.annual
            }
        } catch {
            self.error = error
        }
    }
    
    func purchase() async -> Bool {
        guard let package = selectedPackage else { return false }
        
        isPurchasing = true
        
        do {
            let result = try await Purchases.shared.purchase(package: package)
            isPurchasing = false
            return result.customerInfo.entitlements["Room Status Live Pro"]?.isActive == true
            
        } catch {
            self.error = error
            isPurchasing = false
            return false
        }
    }
}
