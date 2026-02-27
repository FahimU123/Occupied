//
//  PackageButton.swift
//  Occupied
//
//  Created by Fahim Uddin on 12/28/25.
//

import SwiftUI
import RevenueCat

struct PackageButton: View {
    let package: Package
    @Binding var selectedPackage: Package?
    
    var isSelected: Bool {
        selectedPackage == package
    }
    var isYearly: Bool {
        package.packageType == .annual
    }
    
    var body: some View {
        Button {
            selectedPackage = package
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(isYearly ? "Yearly" : "Monthly")
                            .font(.headline)
                            .foregroundStyle(.white)
                        
                        if isYearly {
                            Text("Save 37%")
                                .font(.caption)
                                .bold()
                                .foregroundStyle(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.gold, in: .capsule)
                        }
                    }
                    
                    if let intro = package.storeProduct.introductoryDiscount {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("First \(PaywallViewModel.formatTrial(intro.subscriptionPeriod)) Free")
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(.gold)
                            
                            //FIXME: this work?
                            Text(", then \(package.localizedPriceString)/\(isYearly ? "yr" : "mo")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("Standard Rate")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(package.localizedPriceString)
                        .font(.headline)
                        .foregroundStyle(.gold)
                    
                    if isYearly, let pricePerMonth = package.storeProduct.pricePerMonth {
                        Text("\(pricePerMonth.decimalValue.formatted(.currency(code: package.storeProduct.currencyCode ?? "USD")))/mo")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background {
                if isSelected {
                    Color.gold.opacity(0.1)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .gold : .white.opacity(0.1), lineWidth: 2)
            }
            .clipShape(.rect(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
