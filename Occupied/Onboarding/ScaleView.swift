//
//  ScaleView.swift
//  Occupied
//
//  Created by Fahim Uddin on 12/28/25.
//

import SwiftUI

struct ScaleView: View {
    @AppStorage("has_completed_onboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.deeperGray
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                Image(systemName: "square.stack.3d.up.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.gold)
                    .padding(50)
                    .background(.deeperGray)
                
                VStack(spacing: 16) {
                    Text("Limitless Workspace")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.silverMist)
                    
                    Text("Create one room or one hundred.\nInvite your entire team.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            OnboardingProgress(currentStep: 3)
            
            Button {
                hasCompletedOnboarding = true
            } label: {
                Image(systemName: "checkmark")
            }
            .accessibilityLabel("Continue")
            .buttonStyle(OnboardingFabStyle())
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

