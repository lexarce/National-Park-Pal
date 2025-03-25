//
//  Untitled.swift
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

    var body: some View {
        NavigationView {
            VStack {

                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                
                TextField("Email Address", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()


                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                //Authenticate user. Navigate to next page
                Button("Create Account") {
                    if name == "" || email == "" || password == "" {
                        showError = true
                    }
                    else {
                        let newUser = User()
                        newUser.name = name
                        newUser.email = email
                        newUser.password = password
                                        
                        userModel.createNewUser(newUser) { success in
                            if success {
                                // Navigate to the next view or perform other actions
                            } else {
                                showError = true
                            }
                        }
                    }
                }
                .padding()
                .alert(isPresented: $showError) {
                    Alert(title: Text("Register Failed"), message: Text("Please fill out all fields. Ensure email is not associated with an account already."), dismissButton: .default(Text("OK")))
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
