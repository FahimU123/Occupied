//
//  OnboardingFlowView.swift
//  Occupied
//
//  Created by Fahim Uddin on 12/27/25.
//

import SwiftUI

struct OnboardingFlowView: View {
    @State private var path: [OnboardingDestination] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottomTrailing) {
                Color.deeperGray
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    Image(systemName: "figure.walk")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.gold)
                        .padding(50)
                        .background(.deeperGray)
                    
                    VStack(spacing: 16) {
                        Text("Stop Walking to Check")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.silverMist)
                        
                        Text("Manually checking if a room is empty kills your workflow.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                OnboardingProgress(currentStep: 1)
                
                Button {
                    path.append(.solution)
                } label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(OnboardingFabStyle())
                .padding()
            }
            .navigationDestination(for: OnboardingDestination.self) { destination in
                switch destination {
                case .solution:
                    SolutionView()
                case .scale:
                    ScaleView()
                }
            }
        }
    }
}
