//
//  CustomPaywallView.swift
//  Occupied
//
//  Created by Fahim Uddin on 12/27/25.
//

import SwiftUI
import RevenueCat

struct CustomPaywallView: View {
    @Binding var isPresented: Bool
    @Bindable var onboarding: OnboardingViewModel
    @State private var paywall = PaywallViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    var purchaseButtonTitle: String {
        guard let pkg = paywall.selectedPackage else { return "Select a Plan" }
        if let intro = pkg.storeProduct.introductoryDiscount {
            return "Start \(PaywallViewModel.formatTrial(intro.subscriptionPeriod)) Free Trial"
        }
        return "Subscribe for \(pkg.localizedPriceString)"
    }
    
    var body: some View {
        ZStack {
            Color.deeperGray
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(.doorOpen)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                
                Text("Never Walk to a Busy Room Again")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(text: "Unlimited Rooms & Workspace")
                    FeatureRow(text: "Instant Live Vacancy Status")
                    FeatureRow(text: "Invite Your Entire Team")
                    FeatureRow(text: "Stop the Constant Door Checks")
                }
                .padding(.vertical)
                
                if let offering = paywall.currentOffering {
                    VStack(spacing: 12) {
                        ForEach(offering.availablePackages) { package in
                            PackageButton(package: package, selectedPackage: $paywall.selectedPackage)
                        }
                    }
                } else {
                    ProgressView()
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button {
                        handlePurchase()
                    } label: {
                        Group {
                            if paywall.isPurchasing {
                                ProgressView()
                            } else {
                                Text(purchaseButtonTitle)
                                    .bold()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.gold)
                        .foregroundStyle(.black)
                        .clipShape(.rect(cornerRadius: 12))
                    }
                    .disabled(paywall.isPurchasing || paywall.selectedPackage == nil)
                    
                    Button {
                        onboarding.completeAsEmployee()
                    } label: {
                        HStack {
                            Text("Join Now").bold()
                            Text("(Free)").font(.caption)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding(.vertical, 8)
                    }
                }
                .padding(.bottom, 20)
                
                HStack(spacing: 20) {
                    Button("Restore Purchases") { }
                    Button("Terms") { }
                    Button("Privacy") { }
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            .padding(24)
        }
        .task {
            await paywall.fetchOfferings()
        }
    }
    
    func handlePurchase() {
        Task {
            if await paywall.purchase() {
                dismiss()
                onboarding.completePurchase()
            }
        }
    }
}
