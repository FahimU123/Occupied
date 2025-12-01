//
//  JoinARoomView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI

struct JoinARoomView: View {
    @State var code: String = ""
    var roomViewModel: RoomViewModel
    var body: some View {
        NavigationStack {
            VStack {
                // search field maybe
                Text("Enter a Code to Join a Room")
                    .font(.title)
                    .padding()
                TextField("Enter Room Code", text: $code)
                    .textFieldStyle(.roundedBorder)
                    
            }
            .navigationTitle("Join a Room")
            .onDisappear {
                roomViewModel.fetchRooms()
                roomViewModel.joinARoom(joinCode: code)
            }
        }
    }
}

#Preview {
//    JoinARoomView()
}
