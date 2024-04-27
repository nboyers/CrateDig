//
//  LoginPage.swift
//  Cratedig
//
//  Created by Noah Boyers on 4/10/24.
//

import SwiftUI
import FirebaseAuth

struct LoginPage: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    @StateObject private var authViewModel = AuthViewModel()
    @State private var isShowingHomeViewAsGuest = false // State to manage guest navigation

    var body: some View {
        NavigationStack {
            VStack {
                Image("CrateDig_Logo")
                    .resizable()
                    .frame(width: .infinity, height: 75)
                    .shadow(color: .white, radius: 2)
                Spacer()

                TextField("Email", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)


                Button(action: {
                    // Use the view model to authenticate the user
                    if !username.isEmpty {
                        authViewModel.authenticateUser(username: username, password: password)
                    } else {
                        // Show an alert for empty username
                        alertMessage = "Username field is empty"
                        showAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showAlert = false
                            }
                        }
                    }
                }) {
                    Text("LOGIN")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    // Send a password reset email to the user's email address
                    if !username.isEmpty {
                        Auth.auth().sendPasswordReset(withEmail: username) { error in
                            if let error = error {
                                alertMessage = "Error sending password reset email: \(error.localizedDescription)"
                                // Show an error message indicating the failure to send the reset email
                                alertMessage = "Failed to send reset email"
                            } else {
                                alertMessage =  "Password reset email sent successfully"
                                // Show a success message indicating that the reset email has been sent
                                alertMessage = "Check your email to reset the password"
                            }
                            showAlert = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showAlert = false
                                }
                            }
                        }
                    } else {
                        // Show an error message indicating that the username field is empty
                        alertMessage = "Username field is empty"
                        showAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showAlert = false
                            }
                        }
                    }
                }) {
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.top, 5)
                Spacer()
                // Continue as Guest Button
                Button("Continue as Guest") {
                    // Use the view model to sign in anonymously
                    authViewModel.signInAnonymously()
                }
                .foregroundColor(Color(.systemGray2))
                .padding()

                Spacer().frame(height:10)
            }
            .navigationDestination(isPresented: $authViewModel.isAuthenticated) {
                DiscoverMusicView()
                    .navigationBarBackButtonHidden(true)
            }
            .padding()
    
            .overlay(
                GeometryReader { geometry in
                    if showAlert {
                        VStack {
                            Spacer()
                            Text(alertMessage)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: geometry.size.width)
                                .background(Color.green) // Use green for success, red for failure
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: 0)
                    }
                }
            )
        }

    }
}


#Preview {
    LoginPage()
}
