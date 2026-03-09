//
//  OccupyDurationSheet.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/4/26.
//

import SwiftUI

struct OccupyDurationSheet: View {
    let room: Room
    var roomViewModel: RoomViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDuration: RoomDuration = .fifteenMin
    @State private var claimTrigger = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 6) {
                Text(room.name ?? "Room")
                    .font(.system(.title2, design: .rounded).bold())
                
                Text("How long do you need it?")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 24)
            .padding(.bottom, 4)
            
            Picker("Duration", selection: $selectedDuration) {
                ForEach(RoomDuration.allCases) { duration in
                    Text(duration.label).tag(duration)
                }
            }
            .pickerStyle(.wheel)
            .sensoryFeedback(.selection, trigger: selectedDuration)
            
            Button {
                Task {
                    let releaseAt = Date.now.addingTimeInterval(selectedDuration.timeInterval)
                    claimTrigger.toggle()
                    await roomViewModel.updateRoomOccupancy(for: room, isOccupied: true, releaseAt: releaseAt)
                    dismiss()
                }
            } label: {
                Text("Claim Room")
                    .font(.system(.body, design: .rounded).bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.warmBrown), in: .rect(cornerRadius: 14))
                    .foregroundStyle(.adaptiveBackground)
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .sensoryFeedback(.success, trigger: claimTrigger)
        .presentationDetents([.height(340)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(24)
    }
}
