//
//  RoomDashBoardView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/4/26.
//

import SwiftUI

struct RoomDashboardView: View {
    var roomViewModel: RoomViewModel
    
    var body: some View {
        List {
            ForEach(roomViewModel.rooms) { room in
                RoomCardView(room: room, roomViewModel: roomViewModel)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.silverMist)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        RoomSwipeActionsView(room: room, roomViewModel: roomViewModel)
                    }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .background(.silverMist)
    }
}
