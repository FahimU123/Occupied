//
//  RoomCardView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/8/26.
//

import SwiftUI
import FirebaseAuth

struct RoomCardView: View {
    let room: Room
    var roomViewModel: RoomViewModel
    
    @State private var showVacantConfirmation = false
    @State private var showShareSheet = false
    @State private var showOccupySheet = false
    @State private var occupyTrigger = false
    @State private var releaseTrigger = false
    
    var isOccupied: Bool { room.isOccupied ?? false }
    
    var isOccupying: Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        return uid == room.occupiedByUID
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 16) {
                Image(isOccupied ? .doorClosed : .doorOpen)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 70)
                    .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(room.name ?? "Room")
                        .font(.system(.headline, design: .rounded))
                    
                    if isOccupied, let releaseAt = room.releaseAt {
                        CardCountdownView(
                            releaseAt: releaseAt,
                            room: room,
                            roomViewModel: roomViewModel
                        )
                        if isOccupying {
                            // Pull extend view out of the leading VStack so it gets full width
                            CardExtendTimeView(room: room, roomViewModel: roomViewModel)
                        }
                    } else {
                        Text("Available")
                            .foregroundStyle(Color(.vacantGreen))
                            .font(.system(.subheadline, design: .rounded).bold())
                    }
                }
                
                Spacer()

                Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "person.badge.plus")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Invite")
                .accessibilityHint("Share the room's join code")
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            
            Toggle(
                isOccupied ? "Occupied" : "Vacant",
                isOn: Binding(
                    get: { isOccupied },
                    set: { newValue in
                        if newValue {
                            showOccupySheet = true
                        } else {
                            showVacantConfirmation = true
                        }
                    }
                )
            )
            .font(.system(.subheadline, design: .rounded))
            .padding()
            .tint(isOccupied ? Color(.occupiedRed) : Color(.vacantGreen))
            .accessibilityLabel("Room status")
            .accessibilityValue(isOccupied ? "Occupied" : "Vacant")
        }
        .background(.background, in: .rect(cornerRadius: 20))
        .sensoryFeedback(.success, trigger: occupyTrigger)
        .sensoryFeedback(.warning, trigger: releaseTrigger)
        .confirmationDialog("Mark as Vacant?", isPresented: $showVacantConfirmation) {
            Button("Confirm", role: .destructive) {
                Task {
                    releaseTrigger.toggle()
                    await roomViewModel.updateRoomOccupancy(for: room, isOccupied: false)
                }
            }
        }
        .sheet(isPresented: $showOccupySheet) {
            OccupyDurationSheet(room: room, roomViewModel: roomViewModel)
        }
        .sheet(isPresented: $showShareSheet) {
            RoomCodeShareSheet(room: room)
        }
    }
}
