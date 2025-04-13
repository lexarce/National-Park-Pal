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
    @EnvironmentObject var tabModel: TabSelectionModel

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("NATIONAL PARK PAL")
                        .font(.title)
                        .fontWeight(.bold)
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

                VStack(spacing: 20) {
                    CustomTextField(title: "Name", text: $name)
                    CustomTextField(title: "Email", text: $email)
                    CustomTextField(title: "Password", text: $password, isSecure: true)
                }
                .padding(.horizontal, 40)

                Button(action: {
                    if name.isEmpty || email.isEmpty || password.isEmpty {
                        alertMessage = "Please fill out all fields."
                        showAlert = true
                    } else {
                        let newUser = User()
                        newUser.name = name
                        newUser.email = email
                        newUser.password = password

                        userModel.createNewUser(newUser) { success in
                            DispatchQueue.main.async {
                                if success {
                                    alertMessage = "Account created! Please log in to continue."
                                    showAlert = true
                                } else {
                                    alertMessage = "Email may already be in use. Try a different one."
                                    showAlert = true
                                }
                            }
                        }
                    }
                }) {
                    Text("CREATE ACCOUNT")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "4C8B2B"))
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }
                .padding(.horizontal, 30)

                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Notification"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage.contains("created") {
                            dismiss()
                        }
                    }
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Custom text field

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
        .environmentObject(TabSelectionModel())
}
