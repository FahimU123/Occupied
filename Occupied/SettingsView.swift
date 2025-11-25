//
//  SettingsView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/24/25.
//

import SwiftUI

struct SettingsView: View {
    @Binding var currentRoom: Room?
    var roomViewModel: RoomViewModel
    
    @State private var showJoinARoomPopOver = false
    @State private var showCreateARoomPopover = false
    @State private var showLeaveAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section("Current Room: \(currentRoom?.name ?? "Unavailable") ") {
                        Text("Room Code: \(currentRoom?.joinCode ?? "N/A")")
                        
                        Button {
                            showLeaveAlert = true
                        } label: {
                            Text("Leave Room")
                        }
                        .disabled(currentRoom == nil)
                        .alert("Confirm You Want to Leave this Room", isPresented: $showLeaveAlert) {
                            Button("Leave", role: .destructive) {
                                Task {
                                    await roomViewModel.leaveRoom(room: currentRoom)
                                }
                            }
                            Button("Cancel", role: .cancel) {
                            }
                        } message: {
                            Text("Are you sure you want to leave this room? You will need the code to rejoin.")
                        }
                    }
                    
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
                }
            }
            // Attach popovers to the List or VStack so they present correctly over Settings
            .popover(isPresented: $showCreateARoomPopover) {
                CreateARoomView(roomViewModel: roomViewModel)
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
