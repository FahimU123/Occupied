//
//  CreateARoomView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI

struct CreateARoomView: View {
    var roomViewModel: RoomViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var isOccupied: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Toggle("Status", isOn: $isOccupied)
                Button("Create Room") {
                    let joinCode = UUID().uuidString.prefix(6)
                    roomViewModel.createARoom(
                        name: name,
                        joinCode: String(joinCode),
                        isOccupied: isOccupied
                    )
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
            .navigationTitle("Create a Room")
        }
    }
}

#Preview {
    CreateARoomView(roomViewModel: RoomViewModel(rooms: []))
}
