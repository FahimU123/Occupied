//
//  AuthViewModel.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import FirebaseAuth
import Foundation

@Observable
class AuthViewModel {
    var isAuthenticated = false
    var isLoading = true
    
    func checkAuthentication() async {
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
            isLoading = false
            return
        }
        
        do {
            try await Auth.auth().signInAnonymously()
            isAuthenticated = true
        } catch {
            print("Unable to sign in: \(error.localizedDescription)")
        }
        isLoading = false
    }
}
