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
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter Room Code", text: $code)
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
        }
    }
}

#Preview {
    JoinARoomView()
}
