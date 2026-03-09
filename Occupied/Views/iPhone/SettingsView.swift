//
//  SettingsView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/24/25.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    var roomViewModel: RoomViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var joinCode = ""
    @State private var newRoomName = ""
    
    @State private var createdRoomCode = ""
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("General") {
                    
                    DisclosureGroup("Join a Room") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ask the host for their unique code.").font(.caption).foregroundStyle(.secondary)
                            
                            TextField("Enter Room Code", text: $joinCode)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.characters)
                            
                            Button {
                                Task {
                                    if await roomViewModel.joinARoom(joinCode: joinCode) != nil {
                                        dismiss()
                                    } else {
                                        showErrorAlert = true
                                    }
                                }
                            } label: {
                                Text("Join Room")
                                    .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 12)
                                    .background(Color(.warmBrown), in: .rect(cornerRadius: 10))
                                    .foregroundStyle(.adaptiveBackground)
                            }
                            .disabled(joinCode.isEmpty)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    DisclosureGroup("Create a Room") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Give your new room a name.").font(.caption).foregroundStyle(.secondary)
                            
                            TextField("Room Name", text: $newRoomName)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                Task {
                                    let code = String(UUID().uuidString.prefix(6))
                                    let uid = Auth.auth().currentUser?.uid ?? ""
                                    await roomViewModel.createARoom(name: newRoomName, joinCode: code, isOccupied: false, ownerID: uid, members: [uid])
                                    createdRoomCode = code
                                    showSuccessAlert = true
                                }
                            } label: {
                                Text("Create Room")
                                    .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 12)
                                    .background(Color(.warmBrown), in: .rect(cornerRadius: 10))
                                    .foregroundStyle(.adaptiveBackground)
                            }
                            .disabled(newRoomName.isEmpty)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Manage Rooms")
            .alert("Invalid Code", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            }
            .alert("Room Created!", isPresented: $showSuccessAlert) {
                Button("Copy & Close") {
                    UIPasteboard.general.string = createdRoomCode
                    dismiss()
                }
            } message: {
                Text("Share this code: \(createdRoomCode)")
            }
        }
    }
}
