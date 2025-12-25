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
				Color.silverMist.ignoresSafeArea()
				
				VStack {
					if currentRoom == nil {
						VStack(spacing: 0) {
							
							Spacer()
							
							Text("Tap the gear in the top right to join or create a room.")
								.font(.custom("", size: 24, relativeTo: .title2))
								.multilineTextAlignment(.center)
								.padding(.horizontal)
							
							Spacer()
							
							// The Sign
							ZStack {
								VStack(spacing: 0) {
									VStack(spacing: 0) {
										Button {
											// This could take the user to the room. If not, I could switch this button to be a simple view instead
										} label: {
											HStack {
												Image(systemName: "arrow.left")
												Text("Hello, world.")
											}
											.lineLimit(1)
										}
										.buttonStyle(SignButtonStyle())
										
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
									Button {
										// This could take the user to the room. If not, I could switch this button to be a simple view instead
									} label: {
										HStack {
											Text("Goodbye, world.")
											Image(systemName: "arrow.right")
										}
										.lineLimit(1)
									}
									.buttonStyle(SignButtonStyle())
									
									Image(.holder)
										.resizable()
										.scaledToFit()
										.frame(width: 95)
								}
								.offset(y: -80)
							}
							
							// Floor
							Rectangle()
								.ignoresSafeArea()
								.foregroundStyle(.woodBrown)
								.frame(height: 50)
						}
					} else {
						Text(currentRoom?.isOccupied ?? false
							 ? "Only mark vacant if you used it."
							 : "Tap to book only if using.")
						.padding()
						.multilineTextAlignment(.center)
						
						VStack(spacing: 0) {
							Button {
								showIsOccupiedConfimation = true
							} label: {
								Image(currentRoom?.isOccupied ?? false ? "doorClosed" : "doorOpen")
									.resizable()
									.scaledToFit()
							}
							.buttonStyle(RawButtonStyle())
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
							
							Rectangle()
								.ignoresSafeArea()
								.foregroundStyle(.woodBrown)
								.frame(height: 50)
						}
					}
				}
				.foregroundStyle(.deeperGray)
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
						Image(systemName: "gearshape.fill")
					}
					.buttonStyle(ToolBarButtonStyle())
				}
				.sharedBackgroundVisibility(.hidden) // This hides that glass background you don't like
				
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
						.buttonStyle(ToolBarButtonStyle())
					}
					.sharedBackgroundVisibility(.hidden) // This hides that glass background you don't like
				}
			}
			.sheet(isPresented: $showSettingsPopover) {
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
