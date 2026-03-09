//
//  ExtendTimeView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/8/26.
//

import SwiftUI

struct ExtendTimeView: View {
    let room: Room
    var roomViewModel: RoomViewModel
    
    @State private var tappedMinutes: Int? = nil
    @State private var isConfirming = false
    
    let options = [5, 10, 15]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("EXTEND TIME")
                .font(.system(.caption, design: .rounded))
                .tracking(3)
                .foregroundStyle(.adaptiveForeground)
            
            HStack(spacing: 16) {
                ForEach(options, id: \.self) { minutes in
                    Button {
                        let newDate = max(room.releaseAt ?? .now, .now).addingTimeInterval(Double(minutes * 60))
                        tappedMinutes = minutes
                        Task {
                            await roomViewModel.extendTime(for: room, newReleaseAt: newDate)
                            withAnimation { isConfirming = true }
                            try? await Task.sleep(for: .seconds(1.2))
                            withAnimation {
                                tappedMinutes = nil
                                isConfirming = false
                            }
                        }
                    } label: {
                        Group {
                            if tappedMinutes == minutes && isConfirming {
                                Image(systemName: "checkmark")
                                    .font(.headline.bold())
                            } else {
                                Text("+\(minutes)m")
                                    .font(.system(.subheadline, design: .rounded).bold())
                            }
                        }
                        .frame(minWidth: 80)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(
                            tappedMinutes == minutes ? Color(.vacantGreen) : .white.opacity(0.15),
                            in: .capsule
                        )
                        .scaleEffect(tappedMinutes == minutes ? 1.05 : 1.0)
                        .accessibilityLabel("Extend time by \(minutes) minutes")
                    }
                    .disabled(tappedMinutes != nil)
                }
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: tappedMinutes)
        .sensoryFeedback(.success, trigger: isConfirming)
    }
}
