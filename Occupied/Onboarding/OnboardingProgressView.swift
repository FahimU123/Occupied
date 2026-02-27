//
//  OnboardingProgressView.swift
//  Occupied
//
//  Created by Fahim Uddin on 12/28/25.
//

import SwiftUI

struct OnboardingProgress: View {
    let currentStep: Int
    let totalSteps = 3
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? .gold : .gray)
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 60)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
