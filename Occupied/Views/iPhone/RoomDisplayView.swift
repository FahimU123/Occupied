//
//  RoomDisplayView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/4/26.
//

import SwiftUI

enum RoomDuration: Int, CaseIterable, Identifiable {
    case twoMin = 2
    case fiveMin = 5
    case fifteenMin = 15
    case twentyMin = 20
    
    var id: Int { rawValue }
    var label: String { rawValue == 1 ? "1 minute" : "\(rawValue) minutes" }
    var timeInterval: TimeInterval { Double(rawValue) * 60 }
}


struct RoomDisplayView: View {
    let room: Room
    var roomViewModel: RoomViewModel
    
    var isOccupied: Bool {
        room.isOccupied ?? false
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: isOccupied
                ? [Color(.occupiedRed), Color(.occupiedRedDeep)]
                : [Color(.vacantGreen), Color(.vacantGreenDeep)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if isOccupied {
                OccupiedDisplayView(room: room, roomViewModel: roomViewModel)
            } else {
                VacantDisplayView(room: room, roomViewModel: roomViewModel)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isOccupied)
        .statusBarHidden()
    }
}
