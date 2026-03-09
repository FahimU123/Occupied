//
//  RoomCodeShareSheet.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/4/26.
//

import SwiftUI

struct RoomCodeShareSheet: View {
    let room: Room
    @State private var copied = false
    @State private var copyTrigger = false
    var code: String { room.joinCode ?? "N/A" }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("Invite to \(room.name ?? "Room")")
                    .font(.system(.title3, design: .rounded).bold())
                Text("Share this code so others can join.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                Text(code)
                    .font(.system(.largeTitle, design: .monospaced).bold())
                    .tracking(6)
                
                Button(copied ? "Copied" : "Copy", systemImage: copied ? "checkmark" : "doc.on.doc") {
                    UIPasteboard.general.string = code
                    copyTrigger.toggle()
                    withAnimation { copied = true }
                    Task {
                        try? await Task.sleep(for: .seconds(2))
                        withAnimation { copied = false }
                    }
                }
                .labelStyle(.iconOnly)
                .font(.title3)
                .foregroundStyle(copied ? Color(.vacantGreen) : .secondary)
                .symbolEffect(.bounce, value: copied)
                .accessibilityLabel(copied ? "Code copied" : "Copy code")
                .accessibilityHint("Copies the join code to the clipboard")
            }
            .padding()
            .background(.secondary, in: .rect(cornerRadius: 16))
            
            ShareLink(item: "Join \"\(room.name ?? "my room")\" on Occupied — code: \(code)") {
                Label("Share Code", systemImage: "square.and.arrow.up")
                    .font(.system(.body, design: .rounded).bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.warmBrown), in: .rect(cornerRadius: 14))
                    .foregroundStyle(.adaptiveForeground)
            }
        }
        .padding(24)
        .sensoryFeedback(.success, trigger: copyTrigger)
        .presentationDetents([.height(260)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(24)
    }
}

