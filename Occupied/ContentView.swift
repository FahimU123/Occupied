//
//  ContentView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI

struct ContentView: View {
    // can removestate since onservable? test later
    @State private var roomViewModel = RoomViewModel(rooms: [])
    @State private var currentRoom: Room?
    @State private var showCreateARoomPopover = false
    @State private var showJoinARoomPopOver = false
    @State private var showDeleteAlert = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Button {
                        withAnimation {
                            currentRoom?.isOccupied?.toggle()
                        }
                        
                        Task {
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
            .navigationTitle(currentRoom?.name! ?? "Join or Create a Room")
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
                ToolbarItemGroup(placement: .primaryAction) {
                    // FIXME: check if this works!
                    if let currentRoom = currentRoom {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                        // FIXME: Better message
                        .alert("Are you sure you want to leave this room?", isPresented: $showDeleteAlert) {
                            Button("OK", role: .destructive) {
                                // FIXME: after deleting chnage navigation title
                                roomViewModel.deleteARoom(room: currentRoom)
                            }
                        }
                    }
                    
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
                                Button {
                                    currentRoom = room
                                } label: {
                                    Text("\(room.name ?? "Join or Create a Room") (Join Code: \(room.joinCode ?? "N/A"))")
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
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
