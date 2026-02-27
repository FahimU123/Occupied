//
//  SolutionView.swift
//  Occupied
//
//  Created by Fahim Uddin on 12/28/25.
//

import SwiftUI

struct SolutionView: View {
    @Bindable var onboarding: OnboardingViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.deeperGray
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                DoorAnimationView()
                    .frame(height: 220)
                
                VStack(spacing: 16) {
                    Text("Check From Your Desk")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.silverMist)
                    
                    Text("Open the app. See what's vacant instantly.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }
                
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            OnboardingProgress(currentStep: 2)
            
            NavigationLink(value: OnboardingDestination.scale) {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(OnboardingFabStyle())
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
