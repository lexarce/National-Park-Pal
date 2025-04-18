//
//  LoginView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 3/20/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @ObservedObject var userModel: UserModel
    @EnvironmentObject var tabModel: TabSelectionModel

    @State private var email = ""
    @State private var password = ""
    @State private var showAuthenticationError = false
    @State private var showPassword = false
    @State private var isLoggedIn = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 160)
                    .padding(.top, 50)

                // Welcome Text
                VStack(spacing: 6) {
                    Text("Welcome back")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Log into an existing account")
                        .foregroundColor(Color(hex: "737373"))
                        .font(.body)
                        .fontWeight(.medium)
                }

                // Email Field
                VStack(alignment: .leading, spacing: 6) {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)

                // Password field with toggle
                VStack(alignment: .leading, spacing: 6) {
                    ZStack {
                        if showPassword {
                            TextField("Password", text: $password)
                                .autocapitalization(.none)
                        } else {
                            SecureField("Password", text: $password)
                                .autocapitalization(.none)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 12)
                            }
                        }
                    )
                }
                .padding(.horizontal, 30)

                // Sign in button
                Button(action: {
                    userModel.authenticateUser(email: email, password: password) { success in
                        if success {
                            isLoggedIn = true
                        } else {
                            showAuthenticationError = true
                        }
                    }
                }) {
                    Text("SIGN IN")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "4C8B2B"))
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }
                .padding(.horizontal, 30)

                // Forgot password
                Button(action: {
                    // TODO: Add forgot password logic
                }) {
                    Text("FORGOT PASSWORD")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "53ADF0"))
                }
                .padding(.top, 4)

                Spacer()
            }
            .alert(isPresented: $showAuthenticationError) {
                Alert(title: Text("Login Failed"),
                      message: Text("Invalid email or password."),
                      dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $isLoggedIn) {
                HomePageView(userModel: userModel)
                    .environmentObject(tabModel)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Preview
#Preview {
    LoginView(userModel: UserModel())
        .environmentObject(TabSelectionModel())
}
