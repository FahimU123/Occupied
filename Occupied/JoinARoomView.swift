//
//  JoinARoomView.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import SwiftUI

struct JoinARoomView: View {
    @FocusState var isInputActive: Bool
    @State var code: String = ""
    var roomViewModel: RoomViewModel
    var body: some View {
        NavigationStack {
            VStack {
                // search field maybe
                TextField("Enter Room Code", text: $code)
                    .onSubmit {
                        roomViewModel.joinARoom(joinCode: code)
                    }
                    .focused($isInputActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Done") {
                                isInputActive = false
                            }
                        }
                    }
            }
            .navigationTitle("Join a Room")
            .onDisappear {
                roomViewModel.fetchRooms()
            }
        }
    }
}

#Preview {
//    JoinARoomView()
}
