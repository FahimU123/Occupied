//
//  IPadRoomEntryView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/4/26.
//

import SwiftUI

struct IPadRoomEntryView: View {
    @State private var roomViewModel = RoomViewModel()
    @AppStorage("ipad_assigned_room_id") private var assignedRoomID = ""
    
    var assignedRoom: Room? {
        roomViewModel.rooms.first { $0.id == assignedRoomID }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.warmCharcoal), Color(.warmCharcoalDeep)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if let room = assignedRoom {
                RoomDisplayView(room: room, roomViewModel: roomViewModel)
            } else if roomViewModel.rooms.isEmpty {
                VStack(spacing: 20) {
                    ProgressView()
                        .tint(.adaptiveForeground)
                    Text("Loading Rooms")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.adaptiveForeground)
                }
            } else {
                IPadRoomSetupView(
                    roomViewModel: roomViewModel,
                    assignedRoomID: $assignedRoomID
                )
            }
        }
        .task {
            roomViewModel.fetchRooms()
        }
    }
}
