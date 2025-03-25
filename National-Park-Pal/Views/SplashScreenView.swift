//
//  SplashScreenView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/24/25.
//

import SwiftUI
import FirebaseAuth

//MARK: The Login Page
struct SplashScreenView: View {
    @StateObject private var userModel = UserModel()

    var body: some View {
        NavigationView {
            VStack {

                NavigationLink(destination: RegisterView(userModel: userModel)) {
                    Text("REGISTER")
                        .foregroundColor(.blue)  // Style the text
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: LoginView(userModel: userModel)) {
                    Text("I ALREADY HAVE AN ACCOUNT")
                        .foregroundColor(.blue)  // Style the text
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
