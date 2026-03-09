//
//  VacantDisplayView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/8/26.
//

import SwiftUI

struct VacantDisplayView: View {
    let room: Room
    var roomViewModel: RoomViewModel
    
    @State private var selectedDuration: RoomDuration = .fifteenMin
    @State private var showConfirmation = false
    @State private var pulse = false
    
    let themeColor = Color(.vacantGreen)
    
    var body: some View {
        VStack(spacing: 48) {
            Spacer()
            
            VStack(spacing: 28) {
                Image(systemName: "door.left.hand.open")
                    .font(.system(size: 64, weight: .light))
                    .foregroundStyle(.adaptiveForeground)
                    .frame(width: 130, height: 130)
                    .background(Color(.adaptiveBackground), in: .circle)
                    .accessibilityHidden(true)
                
                VStack(spacing: 8) {
                    Text(room.name ?? "Room")
                        .font(.system(.title2, design: .rounded))
                        .foregroundStyle(.adaptiveForeground)
                    
                    Text("AVAILABLE")
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
            
            HStack(spacing: 16) {
                ForEach(RoomDuration.allCases) { duration in
                    Button { selectedDuration = duration } label: {
                        Text(duration.label)
                            .font(.system(.subheadline, design: .rounded).bold())
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .foregroundStyle(
                                selectedDuration == duration
                                ? .white
                                : .adaptiveForeground
                            )
                            .background(
                                selectedDuration == duration
                                ? themeColor
                                : Color(.adaptiveBackground),
                                in: .capsule
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .animation(.spring(response: 0.3), value: selectedDuration)
            .sensoryFeedback(.selection, trigger: selectedDuration)
            
            Button {
                showConfirmation = true
            } label: {
                Label("Start Using Room", systemImage: "checkmark.circle.fill")
                    .font(.system(.title3, design: .rounded).bold())
                    .padding(.horizontal, 48)
                    .padding(.vertical, 18)
                    .background(themeColor, in: .rect(cornerRadius: 22))
                    .foregroundStyle(.white)
            }
            .confirmationDialog("Use for \(selectedDuration.label)?", isPresented: $showConfirmation) {
                Button("Confirm") {
                    Task {
                        let releaseAt = Date.now.addingTimeInterval(selectedDuration.timeInterval)
                        await roomViewModel.updateRoomOccupancy(for: room, isOccupied: true, releaseAt: releaseAt)
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: 700)
        .padding()
        .sensoryFeedback(.success, trigger: room.isOccupied)
    }
}
