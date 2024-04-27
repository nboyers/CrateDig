//
//  AuthViewModel.swift
//  Cratedig
//
//  Created by Noah Boyers on 4/10/24.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var showAlert = false
    @Published var alertMessage = ""

    func authenticateUser(username: String, password: String) {
        // Firebase Authentication for username and password
        Auth.auth().signIn(withEmail: username, password: password) {  authResult, error in
            if let error = error {
                self.showAlert = true
                self.alertMessage = "Authentication error: \(error.localizedDescription)"
            } else {
                // Authentication successful
                self.alertMessage = "Logging in."
                self.showAlert = true
                self.isAuthenticated = true
            }
        }
    }
    
    func signInAnonymously() {
        // Firebase Authentication for anonymous guest
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("Anonymous authentication error: \(error.localizedDescription)")
            } else {
                // Anonymous authentication successful
                self.isAuthenticated = true
            }
        }
    }
    
    func signUpUser(username: String, password: String) {
        // Firebase Authentication for signing up a new user
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            if let error = error {
                switch AuthErrorCode(AuthErrorCode.Code(rawValue: error._code) ?? AuthErrorCode.missingAppCredential) {
                case AuthErrorCode.emailAlreadyInUse:
                    // Email is already in use, navigate to login page
                    self.isAuthenticated = true
                    break
                    
                case AuthErrorCode.weakPassword:
                    // Weak password, show an alert
                    self.alertMessage = "Weak password or missing password"
                    self.showAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in showAlert = false }
                    break
                    
                case AuthErrorCode.missingEmail:
                    self.alertMessage = "Missing Email"
                    self.showAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in showAlert = false }
                    break
                    
                default:
                    // Other errors, show an alert
                    self.alertMessage = "Error creating user: \(error.localizedDescription)"
                    self.showAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in showAlert = false }
                }
            } else {
                // Sign up successful
                self.alertMessage = "Your account has been successfully created"
                self.showAlert = true
                self.isAuthenticated = true
            }
        }
    }
    
}
