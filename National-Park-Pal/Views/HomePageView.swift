//
//  HomePageView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/24/25.
//  Modified by Alexis on 4/13/25.
//

import SwiftUI
import FirebaseAuth

struct HomePageView: View {
    @ObservedObject var userModel: UserModel
    @StateObject private var parkModel = ParkModel()
    
    @State private var searchText = ""
    @State private var selectedTab = 2
    // 0: UserParksView, 1: MapView, 2: HomePageView

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Welcome message
                Text("Welcome \(userModel.user.name ?? "User")!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 60)
                
                // Trees
                ZStack(alignment: .bottom) {
                    Image("trees")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                }
                
                Spacer()
                    .frame(height: 16)

                // PARK LOCATOR Box
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 5)
                    Text("PARK LOCATOR")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    TextField("Search for a park, location, or activity", text: $searchText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .padding(.horizontal, 8)

                    NavigationLink(
                        destination: SearchResultsView(searchQuery: searchText, userModel: userModel),
                        label: {
                            Text("Search")
                                .fontWeight(.semibold)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    )
                    .padding(.horizontal, 80)
                    .padding(.bottom, 15)
                }
                .background(Color(hex: "64411F"))
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.top, -60) // Lift onto trees a bit
                .shadow(radius: 4)

                // Spacer between Park Locator and View Favorites
                Spacer().frame(height: 30)

                // View Favorites button
                NavigationLink(destination: UserParksView(userModel: userModel)) {
                    VStack {
                        Image(systemName: "heart")
                            .padding(.bottom, 4)
                        Text("VIEW FAVORITES")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "37542E"))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 16)
                .shadow(radius: 4)

                // Spacer between View Favorites and Explore Parks
                Spacer().frame(height: 25)

                // Explore Parks image button
                NavigationLink(destination: SearchParksView(parkModel: parkModel, userModel: userModel)) {
                    Image("exploreparksbutton")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                }

                Spacer()

                // Bottom Toolbar
                HStack {
                    Spacer()
                    Button(action: {
                        selectedTab = 0
                    }) {
                        Image(systemName: selectedTab == 0 ? "bookmark.fill" : "bookmark")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .background(
                        NavigationLink("", destination: UserParksView(userModel: userModel))
                            .opacity(0)
                    )

                    Spacer()
                    Button(action: {
                        selectedTab = 1
                    }) {
                        Image(systemName: selectedTab == 1 ? "map.fill" : "map")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .background(
                        NavigationLink("", destination: MapView(userModel: userModel))
                            .opacity(0)
                    )

                    Spacer()
                    Button(action: {
                        selectedTab = 2
                    }) {
                        Image(systemName: selectedTab == 2 ? "house.fill" : "house")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .disabled(true)
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.bottom, 24) // Push toolbar flush to bottom
                .background(Color.white.ignoresSafeArea(edges: .bottom).shadow(radius: 5))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomePageView(userModel: UserModel())
}
