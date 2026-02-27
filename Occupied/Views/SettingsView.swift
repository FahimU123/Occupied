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
    @Bindable var onboardingViewModel: OnboardingViewModel
    var roomViewModel: RoomViewModel
    
    @State private var showDeleteDialog = false
    @State private var showLeaveDialog = false
    @State private var showShareCodeAlert = false
    @State private var showPaywall = false
    @State private var createdRoomCode: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.silverMist
                    .ignoresSafeArea()
                
                List {
                    Section("General") {
                        JoinRoomSectionView(
                            roomViewModel: roomViewModel,
                            onJoined: { joinedRoom in
                                if let room = joinedRoom {
                                    currentRoom = room
                                }
                                dismiss()
                            }
                        )
                        CreateRoomSectionView(
                            onboardingViewModel: onboardingViewModel,
                            roomViewModel: roomViewModel,
                            currentRoom: $currentRoom,
                            createdRoomCode: $createdRoomCode,
                            showShareCodeAlert: $showShareCodeAlert,
                            showPaywall: $showPaywall,
                            onCreated: { dismiss() }
                        )
                    }
                    
                    if let room = currentRoom {
                        CurrentRoomSectionView(
                            room: room,
                            roomViewModel: roomViewModel,
                            currentRoom: $currentRoom,
                            showLeaveDialog: $showLeaveDialog,
                            showDeleteDialog: $showDeleteDialog
                        )
                    }
                }
            }
            .alert("Share this code to invite others!", isPresented: $showShareCodeAlert) {
                Button("Copy Code") {
                    UIPasteboard.general.string = createdRoomCode
                }
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text(createdRoomCode)
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                CustomPaywallView(isPresented: $showPaywall, onboarding: onboardingViewModel)
            }
        }
    }
}

// MARK: - Join Room

struct JoinRoomSectionView: View {
    var roomViewModel: RoomViewModel
    var onJoined: (Room?) -> Void
    
    @State private var code: String = ""
    @State private var showWrongCodeAlert = false
    
    var body: some View {
        DisclosureGroup("Join a Room") {
            VStack(alignment: .leading, spacing: 10) {
                Text("Ask the host for their unique code.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                TextField("Enter Room Code", text: $code)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            let success = await roomViewModel.joinARoom(joinCode: code)
                            if !success && roomViewModel.showJoinCodeError {
                                showWrongCodeAlert = true
                            } else {
                                let joined = roomViewModel.rooms.first { $0.joinCode == code }
                                onJoined(joined)
                            }
                        }
                    }
                    .alert("Wrong Code", isPresented: $showWrongCodeAlert) {
                        Button("OK", role: .cancel) {}
                    }
            }
        }
    }
}

// MARK: - Create Room

struct CreateRoomSectionView: View {
    @Bindable var onboardingViewModel: OnboardingViewModel
    var roomViewModel: RoomViewModel
    
    @Binding var currentRoom: Room?
    @Binding var createdRoomCode: String
    @Binding var showShareCodeAlert: Bool
    @Binding var showPaywall: Bool

    var onCreated: () -> Void
    
    @State private var name: String = ""
    
    var body: some View {
        DisclosureGroup("Create a Room") {
            VStack(alignment: .leading, spacing: 10) {
                Text("Give your new room a name.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                TextField("Room Name (e.g., Privacy Room)", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    if onboardingViewModel.isPremium {
                        createRoomAction()
                    } else {
                        showPaywall = true
                    }
                } label: {
                    HStack {
                        Text("Create Room")
                        if !onboardingViewModel.isPremium {
                            Image(systemName: "lock.fill")
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.deeperGray)
                .disabled(name.isEmpty)
            }
            .padding(.vertical, 8)
        }
    }
    
    func createRoomAction() {
        Task {
            let joinCode = String(UUID().uuidString.prefix(6))
            let ownerID = Auth.auth().currentUser?.uid ?? ""
            
            await roomViewModel.createARoom(
                name: name,
                joinCode: joinCode,
                isOccupied: false,
                ownerID: ownerID,
                members: [ownerID]
            )
            
            createdRoomCode = joinCode
            showShareCodeAlert = true
            
            if let created = roomViewModel.rooms.first(where: { $0.joinCode == joinCode }) {
                currentRoom = created
            }
        }
    }
}

// MARK: - Current Room

struct CurrentRoomSectionView: View {
    let room: Room
    var roomViewModel: RoomViewModel
    
    @Binding var currentRoom: Room?
    @Binding var showLeaveDialog: Bool
    @Binding var showDeleteDialog: Bool
    
    var isOwner: Bool {
        Auth.auth().currentUser?.uid == room.ownerID
    }
    
    var body: some View {
        Section("Current Room: \(room.name ?? "Unavailable")") {
            Text("Room Code: \(room.joinCode ?? "N/A")")
            
            Button {
                showLeaveDialog = true
            } label: {
                Label("Leave Room", systemImage: "rectangle.portrait.and.arrow.right")
            }
            .disabled(isOwner)
            .confirmationDialog(
                "Are you sure?",
                isPresented: $showLeaveDialog,
                titleVisibility: .visible
            ) {
                Button("Leave", role: .destructive) {
                    Task {
                        await roomViewModel.leaveRoom(room: room)
                        currentRoom = nil
                    }
                }
            }
            
            Button {
                showDeleteDialog = true
            } label: {
                Label("Delete Room", systemImage: "trash")
                    .foregroundStyle(.red)
            }
            .disabled(!isOwner)
            .confirmationDialog(
                "Are you sure?",
                isPresented: $showDeleteDialog,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    Task {
                        await roomViewModel.deleteARoom(room: room)
                        if let random = roomViewModel.rooms.randomElement() {
                            currentRoom = random
                        } else {
                            currentRoom = nil
                        }
                    }
                }
            }
        }
    }
}
