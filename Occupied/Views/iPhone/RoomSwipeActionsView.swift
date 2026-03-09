//
//  RoomSwipeActionsView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/4/26.
//

import SwiftUI
import FirebaseAuth

struct RoomSwipeActionsView: View {
    let room: Room
    var roomViewModel: RoomViewModel
    
    var isOwner: Bool { Auth.auth().currentUser?.uid == room.ownerID }
    
    var body: some View {
        Button(role: .destructive) {
            Task {
                isOwner ? await roomViewModel.deleteARoom(room: room) : await roomViewModel.leaveRoom(room: room)
            }
        } label: {
            Label(isOwner ? "Delete" : "Leave",
                  systemImage: isOwner ? "trash" : "rectangle.portrait.and.arrow.right")
        }
    }
}
