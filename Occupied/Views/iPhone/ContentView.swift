//
//  ContentView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/8/26.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var roomViewModel = RoomViewModel()
    @State private var showSettingsSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if roomViewModel.rooms.isEmpty {
                    EmptyRoomStateView {
                        showSettingsSheet = true
                    }
                } else {
                    RoomDashboardView(roomViewModel: roomViewModel)
                }
            }
            .navigationTitle("Rooms")
            .navigationBarTitleDisplayMode(.large)
            .task {
                roomViewModel.fetchRooms()
            }
            .toolbar {
                if !roomViewModel.rooms.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Room", systemImage: "plus") {
                            showSettingsSheet = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView(roomViewModel: roomViewModel)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
