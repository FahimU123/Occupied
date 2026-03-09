//
//  OccupiedDisplayView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/8/26.
//

import SwiftUI

struct OccupiedDisplayView: View {
    let room: Room
    var roomViewModel: RoomViewModel
    
    @State private var showReleaseConfirmation = false
    @State private var pulse = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 28) {
                Image(systemName: "door.left.hand.closed")
                    .font(.system(size: 64, weight: .light))
                    .foregroundStyle(.adaptiveForeground)
                    .frame(width: 130, height: 130)
                    .background(Color(.adaptiveBackground), in: .circle)
                    .accessibilityHidden(true)
                
                VStack(spacing: 8) {
                    Text(room.name ?? "Room")
                        .font(.system(.title2, design: .rounded))
                        .foregroundStyle(.adaptiveForeground)
                    
                    Text("IN USE")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                        .tracking(5)
                        .foregroundStyle(.adaptiveForeground)
                        .scaleEffect(pulse ? 1.03 : 1.0)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) { pulse = true }
            }
            
            if let releaseAt = room.releaseAt {
                VStack(spacing: 20) {
                    CountdownView(releaseAt: releaseAt)
                    ExtendTimeView(room: room, roomViewModel: roomViewModel)
                }
            }
            
            Button {
                showReleaseConfirmation = true
            } label: {
                Label("Release Room", systemImage: "xmark.circle.fill")
                    .font(.system(.title3, design: .rounded).bold())
                    .padding(.horizontal, 48)
                    .padding(.vertical, 18)
                    .foregroundStyle(.adaptiveForeground)
                    .background(Color(.adaptiveBackground), in: .rect(cornerRadius: 22))
            }
            .confirmationDialog("Mark as available?", isPresented: $showReleaseConfirmation) {
                Button("Release", role: .destructive) {
                    Task {
                        await roomViewModel.updateRoomOccupancy(for: room, isOccupied: false)
                    }
                }
            }
            
            Spacer()
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: 700)
        .padding()
        .sensoryFeedback(.warning, trigger: room.isOccupied)
    }
}
