//
//  CreateARoomView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import FirebaseAuth
import SwiftUI

struct CreateARoomView: View {
    @Environment(\.dismiss) var dismiss
    var roomViewModel: RoomViewModel
    @State private var name: String = ""
    @State private var isOccupied: Bool = false
    @Binding var currentRoom: Room?
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Button("Create Room") {
                    let joinCode = UUID().uuidString.prefix(6)
                    let newRoom = Room(
                        name: name,
                        joinCode: String(joinCode),
                        isOccupied: isOccupied,
                        ownerID: Auth.auth().currentUser?.uid ?? "No user found",
                        members: []
                    )
                    roomViewModel.createARoom(
                        name: newRoom.name ?? "",
                        joinCode: newRoom.joinCode ?? "",
                        isOccupied: newRoom.isOccupied ?? false,
                        ownerID: newRoom.ownerID ?? "",
                        members: ["\(newRoom.ownerID ?? "")"]
                    )
                    
                    currentRoom = newRoom
                    
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

//#Preview {
//    CreateARoomView(
//        roomViewModel: RoomViewModel(rooms: []),
//        currentRoom: .constant(nil)
//    )
//}
