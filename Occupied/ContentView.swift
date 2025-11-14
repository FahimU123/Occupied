//
//  ContentView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isOccupied: Bool? = false
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
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            
                        } label: {
                            Text("Create a Room")
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
        }
    }
}

#Preview {
    ContentView()
}

