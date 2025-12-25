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
    var roomViewModel: RoomViewModel
    @State private var showDeleteDialog = false
    @State private var showJoinARoomPopOver = false
    @State private var showCreateARoomPopover = false
    @State private var showLeaveDialog = false
    @State var code: String = ""
    @State private var showWrongCodeAlert = false
    @State private var name: String = ""
    @State private var isOccupied: Bool = false
    @State private var showShareCodeAlert = false
    @State private var createdRoomCode: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
			ZStack {
				Color.silverMist.ignoresSafeArea()
				VStack {
					List {
						Section("General") {
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
											roomViewModel.joinARoom(joinCode: code)
											if roomViewModel.showJoinCodeError {
												showWrongCodeAlert = true
											} else {
												dismiss()
											}
										}
										.alert("Wrong Code", isPresented: $showWrongCodeAlert) {
											Button(role: .cancel) {}
										}
									
									
								}
							}
							
							DisclosureGroup("Create a Room") {
								VStack(alignment: .leading, spacing: 10) {
									Text("Give your new room a name.")
										.font(.caption)
										.foregroundStyle(.secondary)
									
									TextField("Room Name (e.g., Privacy Room)", text: $name)
										.textFieldStyle(.roundedBorder)
									
									Button {
										let joinCode = UUID().uuidString.prefix(6)
										let newRoom = Room(
											name: name,
											joinCode: String(joinCode),
											isOccupied: isOccupied,
											ownerID: Auth.auth().currentUser?.uid ?? "No user found",
											members: []
										)
										roomViewModel.createARoom(
											name: newRoom.name ?? "",
											joinCode: newRoom.joinCode ?? "",
											isOccupied: newRoom.isOccupied ?? false,
											ownerID: newRoom.ownerID ?? "",
											members: ["\(newRoom.ownerID ?? "")"]
										)
										
										currentRoom = newRoom
										createdRoomCode = String(joinCode)
										showShareCodeAlert = true
										
									} label: {
										Text("Create Room")
											.frame(maxWidth: .infinity)
									}
									.buttonStyle(.borderedProminent)
									.foregroundStyle(.deeperGray)
									.disabled(name.isEmpty)
									
								}
								.padding(.vertical, 8)
							}
						}
						
						Section("Current Room: \(currentRoom?.name ?? "Unavailable") ") {
							Text("Room Code: \(currentRoom?.joinCode ?? "N/A")")
							
							Button {
								showLeaveDialog = true
							} label: {
								Text("Leave Room")
							}
							.disabled(currentRoom == nil || Auth.auth().currentUser?.uid == currentRoom?.ownerID)
							.confirmationDialog(
								"Are you sure?",
								isPresented: $showLeaveDialog,
								titleVisibility: .visible
							) {
								Button("Yes", role: .destructive) {
									Task {
										await roomViewModel.leaveRoom(room: currentRoom)
										currentRoom = roomViewModel.rooms.randomElement()
									}
									
								}
							}
							Button {
								showDeleteDialog = true
							} label: {
								Text("Delete Room")
							}
							.disabled(Auth.auth().currentUser?.uid != currentRoom?.ownerID || currentRoom == nil)
							.confirmationDialog(
								"Are you sure?",
								isPresented: $showDeleteDialog,
								titleVisibility: .visible
							) {
								Button("Yes", role: .destructive) {
									roomViewModel.deleteARoom(room: currentRoom ?? Room())
									currentRoom = roomViewModel.rooms.randomElement()
									
								}
							}
						}
					}
				}
			}
            .alert("Share this code to invite others!", isPresented: $showShareCodeAlert) {
                Button("Copy Code") {
                    UIPasteboard.general.string = createdRoomCode
                }
            } message: {
                Text(createdRoomCode)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
					} label: {
						Image(systemName: "xmark")
							.bold()
					}
					.buttonStyle(ToolBarButtonStyle())
                }
				.sharedBackgroundVisibility(.hidden)
            }
            .navigationTitle("Settings")
            .onDisappear {
                roomViewModel.fetchRooms()
            }
        }
		.scrollContentBackground(.hidden)
    }
}
