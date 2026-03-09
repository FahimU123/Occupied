//
//  EmptyRoomStateView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/4/26.
//

import SwiftUI

struct EmptyRoomStateView: View {
    let onCreateRoom: () -> Void
    let themeColor = Color(.warmBrown)
    
    var body: some View {
        VStack(spacing: 28) {
            Image(systemName: "door.left.hand.open")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(themeColor)
                .frame(width: 110, height: 110)
                .background(themeColor.opacity(0.3), in: .circle)
            
            VStack(spacing: 8) {
                Text("No Rooms Yet")
                    .font(.system(.title2, design: .rounded).bold())
                
                Text("Create a room to start tracking\nwho's inside.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            
            Button(action: onCreateRoom) {
                Label("Create First Room", systemImage: "plus")
                    .font(.system(.body, design: .rounded).bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(themeColor, in: .rect(cornerRadius: 16))
                    .foregroundStyle(.adaptiveBackground)
            }
        }
        .padding(40)
    }
}
