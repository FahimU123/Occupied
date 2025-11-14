//
//  ContentView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isOccupied: Bool? = false
    @State private var roomViewModel = RoomViewModel(rooms: [])
    @State private var showCreateARoomPopover = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Button {
                        withAnimation {
                            isOccupied?.toggle()
                        }
                    } label: {
                        Image(isOccupied! ? "Occupied" : "Vacant")
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }
            }
            .navigationTitle("Privacy Room - ADA")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    // FIXME: We should have an alert here for them to make sure they diont delete on accident
                    Button {
                        
                    } label: {
                        Image(systemName: "trash")
                    }
                    Menu {
                        Button("Create a Room") {
                            showCreateARoomPopover = true
                        }
                        
                        
                        Button {
                            
                        } label: {
                            Text("Join a Room")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .popover(isPresented: $showCreateARoomPopover) {
                // FIXME
                // CreateARoom view has too many dependecies and I dont have the necessary objects to pass in
                
            }
        }
    }
}

#Preview {
    ContentView()
}

