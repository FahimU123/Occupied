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
    @State private var currentRoom: Room? = nil


    @State private var showSettingsPopover = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Switch")
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
            // style
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
                    Menu {
                        ForEach(roomViewModel.rooms, id: \.id) { room in
                            Button(room.name ?? "Unnamed Room") {
                                currentRoom = room
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    
                        Button {
                            showSettingsPopover = true
                        } label: {
                            Image(systemName: "gear")
                        }
                }
            }
            .popover(isPresented: $showSettingsPopover) {
                SettingsView(
                    currentRoom: $currentRoom, // Pass the binding here
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
