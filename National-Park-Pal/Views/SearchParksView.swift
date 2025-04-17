//
//  SearchParksView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//

import SwiftUI
import FirebaseAuth

struct SearchParksView: View {
    @ObservedObject var parkModel: ParkModel
    @ObservedObject var userModel: UserModel
    @EnvironmentObject var tabModel: TabSelectionModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedState = "AZ"
        
    let stateCodes = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC","SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tree banner with title
                ZStack(alignment: .bottom) {
                    Image("trees")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .clipped()
                    
                    Text("EXPLORE PARKS BY STATE")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .padding(.bottom, 8)
                }
                
                // State selector and fetch
                VStack(spacing: 16) {
                    Text("Selected State: \(selectedState)")
                        .font(.headline)

                    Menu {
                        ForEach(stateCodes.reversed(), id: \.self) { state in
                            Button(action: {
                                selectedState = state
                            }) {
                                Text(state)
                            }
                        }
                    } label: {
                        Label("Select State", systemImage: "chevron.down")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color(hex: "37542E").opacity(0.5))
                            .cornerRadius(8)
                    }

                    Button(action: {
                        parkModel.getJsonData(stateCode: selectedState)
                    }) {
                        Text("Fetch Parks in \(selectedState)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color(hex: "37542E"))
                            .cornerRadius(10)
                    }
                }
                .padding()

                // Park list
                List(parkModel.npsResponse.data ?? [], id: \.fullName) { park in
                    NavigationLink(destination: ParkDetailView(userModel: userModel, park: park)) {
                        HStack {
                            Text(park.fullName ?? "")
                                .font(.headline)
                            
                            Spacer()
                            
                            if let imageUrl = park.images?.first?.url,
                               let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 70 , height: 70)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)

                Spacer(minLength: 0)

                // Custom bottom tab bar
                CustomTabBarView(userModel: userModel)
            }
            .onAppear {
                tabModel.selectedTab = 1 // Highlight map tab
            }
            .navigationBarBackButtonHidden(true)
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
        }
    }
}

// MARK: - Preview
#Preview {
    SearchParksView(parkModel: ParkModel(), userModel: UserModel())
        .environmentObject(TabSelectionModel())
}
