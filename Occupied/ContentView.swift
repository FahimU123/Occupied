//
//  ContentView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var roomViewModel = RoomViewModel(rooms: [])
    @State private var isOccupied: Bool? = false
    @State private var showCreateARoomPopover = false
    @State private var showJoinARoomPopOver = false
    @State private var showDeleteAlert = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Button {
                        withAnimation {
                            isOccupied?.toggle()
                        }
                    } label: {
                        Image(isOccupied! ? "Occupied" : "Vacant")
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
            }
            .navigationTitle("Privacy Room - ADA")
            .onAppear {
                roomViewModel.fetchRooms()
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    // FIXME: Better message
                    .alert("Are you sure you want to leave this room?", isPresented: $showDeleteAlert) {
                        Button("OK", role: .destructive) {
                           // Call deleteRoom func and pass in a room here
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
                            ForEach(roomViewModel.rooms, id: \.joinCode) { room in
                                // FIXME: Based on choice chnage current room
                                Button(room.name) {
                                    
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .popover(isPresented: $showCreateARoomPopover) {
                // FIXME: CreateARoom view has too many dependecies and I dont have the necessary objects to pass in
                CreateARoomView(roomViewModel: roomViewModel)
            }
            .popover(isPresented: $showJoinARoomPopOver) {
                JoinARoomView()
            }
        }
    }
}

#Preview {
    ContentView()
}

