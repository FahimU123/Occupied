//
//  ContentView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    // can removestate since onservable? test later
    @State private var roomViewModel = RoomViewModel(rooms: [])
    @State private var currentRoom: Room?
    @State private var showCreateARoomPopover = false
    @State private var showJoinARoomPopOver = false
    @State private var showDeleteAlert = false
    @State private var showLeaveAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Button {
                        Task {
                            withAnimation {
                                currentRoom?.isOccupied?.toggle()
                            }
                            await roomViewModel.updateRoomOccupancy(for: currentRoom, isOccupied: currentRoom?.isOccupied ?? false)
                        }
                    } label: {
                        // FIXME: Switch statement here for nil values
                        
                        Image(currentRoom?.isOccupied ?? false ? "Occupied" : "Vacant")
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
            }
            .navigationTitle(currentRoom?.name ?? "Join or Create a Room")
            .onAppear {
                roomViewModel.fetchRooms()
                retrieve()
            }
            .onDisappear {
                save()
            }
            .onChange(of: roomViewModel.rooms) { _, newRooms in
                if let oldRoomID = currentRoom?.id,
                   let updatedRoom = newRooms.first(where: { $0.id == oldRoomID }) {
                    currentRoom = updatedRoom
                }
            }
            .toolbar {
                Menu {
                    Button("Create a Room") {
                        showCreateARoomPopover = true
                    }
                    
                    Button {
                        showJoinARoomPopOver = true
                    } label: {
                        Text("Join a Room")
                    }
                    Divider()
                    Menu("My Rooms") {
                        ForEach(roomViewModel.rooms, id: \.id) { room in
                            let isOwner = room.ownerID == Auth.auth().currentUser?.uid
             
                            Menu(room.name ?? "Unnamed Room") {
                                Button("Select Room") {
                                    currentRoom = room
                                }
                                Button("Show Join Code") {
                                    UIPasteboard.general.string = room.joinCode ?? "N/A"
                                }
                                if isOwner {
                                    Button(role: .destructive) {
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .alert("Are you sure you want to delete this room?", isPresented: $showDeleteAlert) {
                                        Button("OK", role: .destructive) {
                                            // FIXME: after deleting chnage navigation title
                                            roomViewModel.deleteARoom(room: room)
                                        }
                                    } 
                                } else {
                                    Button(role: .destructive) {
                                        Task {
                                            await roomViewModel.leaveRoom(room: room)
                                        }
                                    } label: {
                                        Label("Leave", systemImage: "rectangle.portrait.and.arrow.right")
                                    }
                                    .alert("Are you sure you want to leave this room?", isPresented: $showDeleteAlert) {
                                        Button("OK", role: .destructive) {
                                            Task {
                                                await roomViewModel.leaveRoom(room: room)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
            .popover(isPresented: $showCreateARoomPopover) {
                CreateARoomView(roomViewModel: roomViewModel, currentRoom: $currentRoom)
            }
            .popover(isPresented: $showJoinARoomPopOver) {
                JoinARoomView(roomViewModel: roomViewModel)
            }
        }
    }
    
    // FIXME: work in progress
    func save() {
        if let currentRoom = currentRoom {
            if let encoded = try? JSONEncoder().encode(currentRoom) {
                UserDefaults.standard.set(encoded, forKey: "current_room")
            }
        }
    }
    
    // FIXME: work in progress
    func retrieve() {
        if let savedRoom = UserDefaults.standard.data(forKey: "current_room"),
           let decodedRoom = try? JSONDecoder().decode(Room.self, from: savedRoom) {
            currentRoom = decodedRoom
        }
    }
}

#Preview {
    ContentView()
}
