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
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if currentRoom == nil {
                        Text("Welcome! Tap the settings icon to join an existing room or create a new one.")
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        Text(currentRoom?.isOccupied ?? false
                             ? "Only mark vacant if you used it."
                             : "Tap to book only if using.")
                        .padding()
                        .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        showIsOccupiedConfimation = true
                    } label: {
                        // FIXME: Switch statement here for nil values
                        Image(currentRoom?.isOccupied ?? false ? "Occupied" : "Vacant")
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                    // fixme: chnage message
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
            .navigationTitle(currentRoom?.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
            
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
