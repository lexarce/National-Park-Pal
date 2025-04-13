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
    @ObservedObject var parkModel: ParkModel = ParkModel()
    @EnvironmentObject var tabModel: TabSelectionModel
    
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Welcome message
                let firstName = userModel.user.name?.components(separatedBy: " ").first ?? "User"
                Text("Welcome \(firstName)!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 60)

                // Trees image
                ZStack(alignment: .bottom) {
                    Image("trees")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                }

                Spacer().frame(height: 16)

                // PARK LOCATOR box
                VStack(spacing: 20) {
                    Spacer().frame(height: 5)

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
                .padding(.top, -60) // overlap trees
                .shadow(radius: 4)

                Spacer().frame(height: 30)

                // VIEW FAVORITES button
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

                Spacer().frame(height: 25)

                // EXPLORE PARKS image button
                NavigationLink(destination: SearchParksView(parkModel: parkModel, userModel: userModel)) {
                    Image("exploreparksbutton")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                }

                Spacer()

                // Bottom toolbar
                CustomTabBarView(userModel: userModel)
            }
            .onAppear {
                tabModel.selectedTab = 2 // Highlight home tab
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    HomePageView(userModel: UserModel())
        .environmentObject(TabSelectionModel())
}

