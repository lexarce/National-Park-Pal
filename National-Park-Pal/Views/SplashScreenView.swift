//
//  SplashScreenView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/24/25.
//  Modified by Alexis on 3/25/25.
//

import SwiftUI
import FirebaseAuth

struct SplashScreenView: View {
    @StateObject private var userModel = UserModel()
    
    // Animation state variables
    @State private var animate = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "8AC63C")
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text("Welcome to")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .opacity(animate ? 1 : 0)
                            .offset(y: animate ? 0 : 20)
                            .animation(.easeOut(duration: 1).delay(0.2), value: animate)
                        
                        Text("NATIONAL PARK PAL")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .opacity(animate ? 1 : 0)
                            .offset(y: animate ? 0 : 20)
                            .animation(.easeOut(duration: 1).delay(0.4), value: animate)
                        
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 175)
                            .opacity(animate ? 1 : 0)
                            .scaleEffect(animate ? 1 : 0.8)
                            .animation(.easeOut(duration: 1).delay(0.6), value: animate)
                    }

                    // Navigation buttons
                    NavigationLink(destination: RegisterView(userModel: userModel)) {
                        Text("REGISTER")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(40)
                            .padding(.horizontal, 40)
                    }
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 0.8).delay(1), value: animate)

                    NavigationLink(destination: LoginView(userModel: userModel)) {
                        Text("I ALREADY HAVE AN ACCOUNT")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "494356"))
                            .cornerRadius(40)
                            .padding(.horizontal, 40)
                    }
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 0.8).delay(1.2), value: animate)

                    Spacer()
                }
            }
            .onAppear {
                animate = true
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SplashScreenView()
}

