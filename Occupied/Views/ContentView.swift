//
//  ContentView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var roomViewModel = RoomViewModel(rooms: [])
    @State private var currentRoom: Room? = nil
    @State private var showSettingsPopover = false
    @State private var showIsOccupiedConfimation = false
    @AppStorage("last_active_room_id") private var lastActiveRoomID: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if currentRoom == nil {
                        VStack {
                            Spacer()
                            Image(systemName: "door.left.hand.open")
                                .font(.system(size: 120, weight: .bold))
                                .foregroundColor(.accentColor)
                                .padding(.bottom, 32)
                            Text("Tap the gear in the top right to join or create a room.")
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Spacer()
                        }
                    } else {
                        Text(currentRoom?.isOccupied ?? false
                             ? "Only mark vacant if you used it."
                             : "Tap to book only if using.")
                        .padding()
                        .multilineTextAlignment(.center)
                        
                        
                        Button {
                            showIsOccupiedConfimation = true
                        } label: {
                            Image(currentRoom?.isOccupied ?? false ? "Occupied" : "Vacant")
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                        .confirmationDialog("Are you sure?", isPresented: $showIsOccupiedConfimation, titleVisibility: .visible) {
                            Button("Yes", role: .confirm) {
                                Task {
                                    withAnimation {
                                        currentRoom?.isOccupied?.toggle()
                                    }
                                    await roomViewModel.updateRoomOccupancy(for: currentRoom, isOccupied: currentRoom?.isOccupied ?? false)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(currentRoom?.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
            
            .onAppear {
                roomViewModel.fetchRooms()
            }
            .onChange(of: roomViewModel.rooms) { _, newRooms in
                if let oldRoomID = currentRoom?.id,
                   let updatedRoom = newRooms.first(where: { $0.id == oldRoomID }) {
                    currentRoom = updatedRoom
                }
                
             
                else if currentRoom == nil, !lastActiveRoomID.isEmpty {
                    if let restoredRoom = newRooms.first(where: { $0.id == lastActiveRoomID }) {
                        currentRoom = restoredRoom
                    }
                }
            }
            
            .onChange(of: currentRoom) { _, newRoom in
                if let id = newRoom?.id {
                    lastActiveRoomID = id
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showSettingsPopover = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                
                if roomViewModel.rooms.count >= 2 {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Menu {
                            ForEach(roomViewModel.rooms, id: \.id) { room in
                                Button(room.name ?? "Unnamed Room") {
                                    currentRoom = room
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                    }
                }
            }
            .popover(isPresented: $showSettingsPopover) {
                SettingsView(
                    currentRoom: $currentRoom,
                    roomViewModel: roomViewModel
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
