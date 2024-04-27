//
//  SignupView.swift
//  Cratedig
//
//  Created by Noah Boyers on 4/26/24.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    var backToMenu = false
    
    @StateObject private var authViewModel = AuthViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image("CrateDig_Logo")
                    .resizable()
                    .frame(width: .infinity, height: 75)
                    .shadow(color: .white, radius: 2)
                    .padding()
            
                    
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding()
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding()
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding()
                
                Button(action: {
                    // Sign up the user using the AuthViewModel
                    authViewModel.signUpUser(username: email, password: password)
                }) {
                    Text("SIGN UP")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .padding(.bottom, 20)
                Spacer()
            }
            
           
        }
        .navigationDestination(isPresented: $authViewModel.isAuthenticated) {
            LoginPage()
                .navigationBarBackButtonHidden(true)
        }
        .overlay(
            GeometryReader { geometry in
                if authViewModel.showAlert {
                    VStack {
                        Spacer()
                        Text(authViewModel.alertMessage)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: geometry.size.width)
                            .background(Color.red) // Use green for success, red for failure
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: 0)
                }
            }
        )
    }
}


#Preview {
    SignupView()
}
