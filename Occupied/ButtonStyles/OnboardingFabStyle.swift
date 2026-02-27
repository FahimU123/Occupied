//
//  OnboardingFabStyle.swift
//  Occupied
//
//  Created by Fahim Uddin on 1/6/26.
//

import SwiftUI

struct OnboardingFabStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .bold()
            .foregroundStyle(.deeperGray)
            .frame(width: 60, height: 60)
            .background(.gold)
            .clipShape(.circle)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
