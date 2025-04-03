//
//  HomePageView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/24/25.
//

import SwiftUI
import FirebaseAuth

struct HomePageView: View {
    @ObservedObject var userModel: UserModel
    @StateObject private var parkModel = ParkModel()

    var body: some View {
        NavigationStack {
            VStack {

                NavigationLink(destination: UserParksView(userModel: userModel)) {
                    Text("View Saved Parks")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "494356"))
                        .cornerRadius(40)
                        .padding(.horizontal, 40)
                }
                    
                NavigationLink(destination: SearchParksView(parkModel: parkModel, userModel: userModel)) {
                    Text("Explore Parks")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "494356"))
                        .cornerRadius(40)
                        .padding(.horizontal, 40)
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomePageView(userModel: UserModel())
}

