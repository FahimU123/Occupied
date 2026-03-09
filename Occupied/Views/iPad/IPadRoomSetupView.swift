//
//  IPadRoomSetupView.swift
//  Occupied
//
//  Created by Fahim Uddin on 3/8/26.
//

import SwiftUI

struct IPadRoomSetupView: View {
    var roomViewModel: RoomViewModel
    @Binding var assignedRoomID: String
    
    @State private var joinCode = ""
    @State private var showError = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.warmCharcoal), Color(.warmCharcoalDeep)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 48) {
                VStack(spacing: 12) {
                    Image(systemName: "door.left.hand.open")
                        .font(.system(size: 60, design: .rounded))
                        .foregroundStyle(.adaptiveForeground)
                    
                    Text("ROOM DISPLAY")
                        .font(.subheadline)
                        .tracking(4)
                        .foregroundStyle(.adaptiveForeground)
                    
                    Text("NOT ASSIGNED")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                        .tracking(4)
                        .foregroundStyle(.adaptiveForeground)
                }
                
                VStack(spacing: 16) {
                    Text("ENTER JOIN CODE")
                        .font(.subheadline)
                        .tracking(2)
                        .foregroundStyle(.adaptiveForeground)
                    
                    TextField("XXXXXX", text: $joinCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.center)
                        .font(.system(.title2, design: .monospaced))
                        .padding()
                        .background(Color(.adaptiveBackground), in: .rect(cornerRadius: 20))
                        .foregroundStyle(.adaptiveForeground)
                        .frame(maxWidth: 280)
          
                }
                
                Button {
                    Task {
                        if let roomID = await roomViewModel.joinARoom(joinCode: joinCode) {
                            assignedRoomID = roomID
                        } else {
                            showError = true
                        }
                    }
                } label: {
                    Label("Assign Room", systemImage: "checkmark.circle.fill")
                        .font(.headline.bold())
                        .frame(maxWidth: 400)
                        .padding(.vertical, 18)
                        .background(Color(.vacantGreen), in: .rect(cornerRadius: 24))
                        .foregroundStyle(.white)
                }
            }
            .padding(60)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 36))
            .frame(maxWidth: 640)
            .padding()
        }
        .statusBarHidden()
        .alert("Room not found. Check the code.", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        }
    }
}
