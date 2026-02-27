//
//  ContentView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI
import FirebaseAuth
import RevenueCat

struct ContentView: View {
    @State private var roomViewModel = RoomViewModel()
    @State private var currentRoom: Room? = nil
    @State private var showSettingsSheet = false
    @State private var showIsOccupiedConfirmation = false
    @AppStorage("last_active_room_id") private var lastActiveRoomID: String = ""
    
    @Bindable var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.silverMist
                    .ignoresSafeArea()
                
                VStack {
                    if let room = currentRoom {
                        ActiveRoomView(
                            room: room,
                            showConfirmation: $showIsOccupiedConfirmation,
                            roomViewModel: roomViewModel
                        )
                    } else {
                        EmptyRoomStateView()
                    }
                }
                .foregroundStyle(.deeperGray)
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle(currentRoom?.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                roomViewModel.fetchRooms()
            }
            .onChange(of: roomViewModel.rooms) { _, newRooms in
                handleRoomUpdates(newRooms: newRooms)
            }
            .onChange(of: currentRoom) { _, newRoom in
                if let id = newRoom?.id {
                    lastActiveRoomID = id
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings", systemImage: "gearshape") {
                        showSettingsSheet = true
                    }
                }
                
                if roomViewModel.rooms.count >= 2 {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            ForEach(roomViewModel.rooms, id: \.id) { room in
                                Button(room.name ?? "Unnamed Room") {
                                    currentRoom = room
                                }
                            }
                        } label: {
                            Label("Switch Room", systemImage: "chevron.down")
                        }
                    }
                }
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView(
                    currentRoom: $currentRoom,
                    onboardingViewModel: onboardingViewModel,
                    roomViewModel: roomViewModel
                )
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    func handleRoomUpdates(newRooms: [Room]) {
        if let oldRoomID = currentRoom?.id,
           let updatedRoom = newRooms.first(where: { $0.id == oldRoomID }) {
            currentRoom = updatedRoom
        } else if currentRoom == nil, !lastActiveRoomID.isEmpty {
            if let restoredRoom = newRooms.first(where: { $0.id == lastActiveRoomID }) {
                currentRoom = restoredRoom
            }
        }
    }
}

// MARK: - Empty State

struct EmptyRoomStateView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("Tap the gear in the top right to join or create a room.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            ZStack {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        SignPostView(text: "Hello, world.", arrowLeading: true)
                        
                        Image(.holder)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 95)
                    }
                    
                    Image(.stick)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 450)
                }
                
                VStack(spacing: 0) {
                    SignPostView(text: "Goodbye, world.", arrowLeading: false)
                    
                    Image(.holder)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 95)
                }
                .offset(y: -80)
            }
            
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.woodBrown)
                .frame(height: 50)
        }
    }
}

struct SignPostView: View {
    let text: String
    let arrowLeading: Bool
    
    var body: some View {
        HStack {
            if arrowLeading {
                Image(systemName: "arrow.left")
            }
            Text(text)
                .lineLimit(1)
            if !arrowLeading {
                Image(systemName: "arrow.right")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.woodBrown, in: .rect(cornerRadius: 8))
        .foregroundStyle(.white)
    }
}

// MARK: - Active Room

struct ActiveRoomView: View {
    let room: Room
    @Binding var showConfirmation: Bool
    var roomViewModel: RoomViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text(room.isOccupied ?? false
                 ? "Only mark vacant if you used it."
                 : "Tap to book only if using.")
            .padding()
            .multilineTextAlignment(.center)
            
            VStack(spacing: 0) {
                Button {
                    showConfirmation = true
                } label: {
                    ZStack {
                        Image(room.isOccupied ?? false ? .doorClosed : .doorOpen)
                            .resizable()
                            .scaledToFit()
                        
                        Text(room.isOccupied ?? false ? "OCCUPIED" : "VACANT")
                            .font(.system(size: 14, weight: .bold, design: .serif))
                            .foregroundStyle(.black)
                            .offset(
                                x: room.isOccupied ?? false ? 0 : -43
                            )
                    }
                }
                .buttonStyle(RawButtonStyle())
                .confirmationDialog("Are you sure?", isPresented: $showConfirmation, titleVisibility: .visible) {
                    Button("Yes") {
                        toggleOccupancy()
                    }
                }
                
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundStyle(.woodBrown)
                    .frame(height: 50)
            }
        }
    }
    
    func toggleOccupancy() {
        Task {
            await roomViewModel.updateRoomOccupancy(for: room, isOccupied: !(room.isOccupied ?? false))
        }
    }
}
