//
//  DoorAnimationView.swift
//  Occupied
//
//  Created by Fahim Uddin on 12/27/25.
//

import SwiftUI

struct DoorAnimationView: View {
    @State private var isOpen = false
    
    var body: some View {
        Image(.doorClosed)
            .resizable()
            .scaledToFit()
            .frame(width: 140)
            .rotation3DEffect(
                .degrees(isOpen ? 30 : 0),
                axis: (x: 0, y: 1, z: 0),
                anchor: .leading,
                perspective: 0.5
            )
            .task {
                while !Task.isCancelled {
                    do {
                        try await Task.sleep(for: .seconds(1))
                    } catch {
                        break
                    }
                    withAnimation(.easeInOut(duration: 1)) {
                        isOpen.toggle()
                    }
                }
            }
    }
}

#Preview {
    DoorAnimationView()
}


enum OnboardingDestination: Hashable {
    case solution
    case scale
}
