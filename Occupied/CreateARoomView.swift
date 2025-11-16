//
//  CreateARoomView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import FirebaseAuth
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
                        isOccupied: isOccupied, ownerID: Auth.auth().currentUser?.uid ?? "No user found"
                    )
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
            .navigationTitle("Create a Room")
            .onDisappear {
                roomViewModel.fetchRooms()
            }
        }
    }
}

#Preview {
    CreateARoomView(roomViewModel: RoomViewModel(rooms: []))
}
