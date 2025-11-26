//
//  SettingsView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/24/25.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Binding var currentRoom: Room?
    var roomViewModel: RoomViewModel
    @State private var showDeleteDialog = false
    @State private var showJoinARoomPopOver = false
    @State private var showCreateARoomPopover = false
    @State private var showLeaveDialog = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section("General") {
                        Button {
                            showJoinARoomPopOver = true
                        } label: {
                            Text("Join Room")
                        }
                        
                        Button {
                            showCreateARoomPopover = true
                        } label: {
                            Text("Create a Room")
                        }
                    }
                    
                    Section("Current Room: \(currentRoom?.name ?? "Unavailable") ") {
                        Text("Room Code: \(currentRoom?.joinCode ?? "N/A")")
                        
                        Button {
                            showLeaveDialog = true
                        } label: {
                            Text("Leave Room")
                        }
                        .disabled(currentRoom == nil || Auth.auth().currentUser?.uid == currentRoom?.ownerID)
                        .confirmationDialog(
                            "Are you sure?",
                            isPresented: $showLeaveDialog,
                            titleVisibility: .visible
                        ) {
                            Button("Yes", role: .destructive) {
                                Task {
                                    await roomViewModel.leaveRoom(room: currentRoom)
                                    currentRoom = roomViewModel.rooms.randomElement()
                                }
                                
                            }
                        }
                        Button {
                            showDeleteDialog = true
                        } label: {
                            Text("Delete Room")
                        }
                        .disabled(Auth.auth().currentUser?.uid != currentRoom?.ownerID || currentRoom == nil)
                        .confirmationDialog(
                            "Are you sure?",
                            isPresented: $showDeleteDialog,
                            titleVisibility: .visible
                        ) {
                            Button("Yes", role: .destructive) {
                                roomViewModel.deleteARoom(room: currentRoom ?? Room())
                                currentRoom = roomViewModel.rooms.randomElement()
                             
                            }
                        }
                    }
                }
            }
            .popover(isPresented: $showCreateARoomPopover) {
                CreateARoomView(roomViewModel: roomViewModel, currentRoom: $currentRoom)
            }
            .popover(isPresented: $showJoinARoomPopOver) {
                JoinARoomView(roomViewModel: roomViewModel)
            }
            .navigationTitle("Settings")
   
        }
    }
}

//#Preview {
//    SettingsView(
//        currentRoom: .constant(nil),
//        roomViewModel: RoomViewModel(rooms: [])
//    )
//}
