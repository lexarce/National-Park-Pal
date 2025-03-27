//
//  RegisterView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/24/25.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @ObservedObject var userModel: UserModel
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showRegisterFailError = false
    @State private var showError = false
    @State private var showSuccessAlert = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Logo and Titles
                VStack(spacing: 12) {
                    Text("NATIONAL PARK PAL")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                        .padding(.top)
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)

                    VStack(spacing: 4) {
                        Text("Sign up with")
                            .font(.title)
                            .fontWeight(.semibold)

                        Text("email")
                            .font(.title)
                            .fontWeight(.semibold)

                        Text("Create account")
                            .foregroundColor(Color(hex: "666666"))
                            .font(.body)
                            .fontWeight(.bold)
                    }
                }
                .padding(.top)

                // Input fields
                VStack(spacing: 20) {
                    CustomTextField(title: "Name", text: $name)
                    CustomTextField(title: "Email", text: $email)
                    CustomTextField(title: "Password", text: $password, isSecure: true)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                
                //Authenticate user. Navigate to next page
                Button(action: {
                    if name == "" || email == "" || password == "" {
                        showError = true
                    } else {
                        let newUser = User()
                        newUser.name = name
                        newUser.email = email
                        newUser.password = password
                        
                        userModel.createNewUser(newUser) { success in
                            if success {
                                showSuccessAlert = true
                            } else {
                                showError = true
                            }
                        }
                    }
                }) {
                    Text("CREATE ACCOUNT")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "4C8B2B")) // darker green
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }
                .padding(.horizontal, 30)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Account Created"),
                    message: Text("Your account was successfully created."),
                    dismissButton: .default(Text("OK"), action: {
                        dismiss() // automatically go back after success
                    })
                )
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Register Failed"),
                    message: Text("Please fill out all fields. Ensure email is not associated with an account already."),
                    dismissButton: .default(Text("OK"))
                )
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
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Custom Text Field
struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(Color(hex: "737373"))
                .fontWeight(.medium)

            if isSecure {
                SecureField("", text: $text)
                    .padding(.bottom, 8)
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
            } else {
                TextField("", text: $text)
                    .padding(.bottom, 8)
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    RegisterView(userModel: UserModel())
}

