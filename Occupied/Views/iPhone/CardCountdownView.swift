//
//  CardCountdownView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/4/26.
//

import SwiftUI

struct CardCountdownView: View {
    
    let releaseAt: Date
    let room: Room
    var roomViewModel: RoomViewModel
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let remaining = max(0, releaseAt.timeIntervalSince(context.date))
            Text(
                Duration.seconds(remaining),
                format: .units(
                    allowed: [.hours, .minutes, .seconds],
                    width: .abbreviated,
                    maximumUnitCount: 2
                )
            )
            .font(.system(.caption, design: .rounded).bold())
            .monospacedDigit()
            .fixedSize()
            .foregroundStyle(.occupiedRed)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.regularMaterial, in: .capsule)
            .overlay(Capsule().fill(Color(.occupiedRed).opacity(0.12)))
            .accessibilityLabel("Time remaining")
            .accessibilityValue(Duration.seconds(remaining).formatted(.units(allowed: [.hours, .minutes, .seconds], width: .wide)))
        }
    }
    
}
