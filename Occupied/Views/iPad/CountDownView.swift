//
//  CountdownView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/8/26.
//

import SwiftUI

struct CountdownView: View {
    let releaseAt: Date
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let remaining = max(0, releaseAt.timeIntervalSince(context.date))
            VStack(spacing: 8) {
                Text("RELEASES IN")
                    .font(.system(.caption, design: .rounded))
                    .tracking(3)
                    .foregroundStyle(.adaptiveForeground)
                
                Text(
                    Duration.seconds(remaining),
                    format: .units(allowed: [.hours, .minutes, .seconds], width: .wide)
                )
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .monospacedDigit()
                .foregroundStyle(.adaptiveForeground)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
            .background(Color(.adaptiveBackground), in: .rect(cornerRadius: 20))
        }
    }
}
