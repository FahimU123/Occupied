//
//  CreateARoomView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI

struct CreateARoomView: View {
    @State var room: Room
    let roomViewModel: RoomViewModel
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $room.name)
                    .submitLabel(.done)
            }
            .onSubmit {
                roomViewModel.createARoom(name: room.name, joinCode: room.joinCode, isOccupied: false)
            }
        }
        .onAppear {
            roomViewModel.generateRoomCode()
        }
    }
}

#Preview {
    // CreateARoomView()
}
