//
//  ContentView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI

struct ContentView: View {
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
                    } label: {
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
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    if let currentRoom = currentRoom {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                        // FIXME: Better message
                        .alert("Are you sure you want to leave this room?", isPresented: $showDeleteAlert) {
                            Button("OK", role: .destructive) {
                                // Call deleteRoom func and pass in a room here
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
                                // FIXME: Based on choice chnage current room
                                Button(room.name ?? "Join or Create a Room") {
                                    currentRoom = room
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .popover(isPresented: $showCreateARoomPopover) {
                CreateARoomView(roomViewModel: roomViewModel)
            }
            .popover(isPresented: $showJoinARoomPopOver) {
                JoinARoomView()
            }
        }
    }
    func save() {
        if let currentRoom = currentRoom {
            if let encoded = try? JSONEncoder().encode(currentRoom) {
                UserDefaults.standard.set(encoded, forKey: "current_room")
            }
        }
    }
    
    func retrieve() {
        if let savedRoom = UserDefaults.standard.data(forKey: "current_room"),
           let decodedRoom = try? JSONDecoder().decode(Room.self, from: savedRoom) {
            currentRoom = decodedRoom
        }
    }
}

#Preview {
//    ContentView()
}
