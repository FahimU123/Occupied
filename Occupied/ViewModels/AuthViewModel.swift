//
//  AuthViewModel.swift
//  Occupied
//
//  Created by Fahim Uddin on 11/14/25.
//

import os
import FirebaseAuth
import Foundation

@Observable
class AuthViewModel {
    var isAuthenticated = false
    var isLoading = true
    
    func checkAuthentication() {
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
            isLoading = false
            return
        }
        
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                AppLogger.logger.error("unable to sign in \(error.localizedDescription)")
            }
            if authResult != nil {
                self.isAuthenticated = true
            }
            self.isLoading = false
        }
    }
}
