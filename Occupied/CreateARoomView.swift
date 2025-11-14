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
    @State var test: String
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Name", text: $test)
                        .submitLabel(.done)
                    Toggle("Status", isOn: $room.isOccupied)
                }
                .onSubmit {
                    roomViewModel.createARoom(name: room.name, joinCode: room.joinCode, isOccupied: false)
                }
            }
            .navigationTitle("Create a Room")
        }
        
//        .onAppear {
//            roomViewModel.generateRoomCode()
//        }
    }
}

#Preview {
    // CreateARoomView()
}
