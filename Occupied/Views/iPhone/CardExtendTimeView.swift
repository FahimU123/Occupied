//
//  CardExtendTimeView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/4/26.
//

import SwiftUI

struct CardExtendTimeView: View {
    let room: Room
    var roomViewModel: RoomViewModel
    
    @State private var tappedMinutes: Int? = nil
    @State private var isConfirming = false
    
    let options = [5, 10, 15]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(options, id: \.self) { minutes in
                Button {
                    let base = max(room.releaseAt ?? .now, .now)
                    let newDate = base.addingTimeInterval(Double(minutes * 60))
                    tappedMinutes = minutes
                    
                    Task {
                        await roomViewModel.extendTime(for: room, newReleaseAt: newDate)
                        withAnimation { isConfirming = true }
                        try? await Task.sleep(for: .seconds(1))
                        withAnimation {
                            tappedMinutes = nil
                            isConfirming = false
                        }
                    }
                } label: {
                    Group {
                        if tappedMinutes == minutes && isConfirming {
                            Image(systemName: "checkmark")
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Text("+\(minutes)m")
                                .transition(.opacity)
                        }
                    }
                    .font(.system(.caption, design: .rounded).bold())
                    .frame(minWidth: 44)
                    .padding(.vertical, 7)
                    .foregroundStyle(tappedMinutes == minutes ? .adaptiveForeground : .vacantGreen)
                    .background(tappedMinutes == minutes ? Color(.vacantGreen) : Color(.vacantGreen).opacity(0.15), in: .capsule)
                    .scaleEffect(tappedMinutes == minutes ? 1.08 : 1.0)
                    .accessibilityLabel("Extend time by \(minutes) minutes")
                    .accessibilityHint("Adds \(minutes) minutes to the current timer")
                }
                .buttonStyle(.plain)
                .disabled(tappedMinutes != nil)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: tappedMinutes)
        .sensoryFeedback(.success, trigger: isConfirming)
    }
}
