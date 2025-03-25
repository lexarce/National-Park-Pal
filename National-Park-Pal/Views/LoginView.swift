//
//  SplashScreenView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 3/20/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @ObservedObject var userModel: UserModel
    @State private var email = ""
    @State private var password = ""
    @State private var showAuthenticationError = false

    var body: some View {
        NavigationView {
            VStack {
                
                TextField("Email Address", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                                
                Button("Login") {
                    userModel.authenticateUser(email: email, password: password) { success in
                        if success {
                            // Navigate to the next view or perform other actions
                        } else {
                            showAuthenticationError = true
                        }
                    }
                }
                .padding()
                .alert(isPresented: $showAuthenticationError) {
                    Alert(title: Text("Login Failed"), message: Text("Invalid email or password."), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(destination: HomePageView(), isActive: $userModel.isAuthenticated) {
                    EmptyView()
                }
            }
        }
        
    }
    
}

#Preview {
    SplashScreenView()
}
