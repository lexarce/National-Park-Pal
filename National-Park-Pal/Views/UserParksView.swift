//
//  UserParksView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//  Mo
//

import SwiftUI
import FirebaseAuth

struct UserParksView: View {
    @ObservedObject var userModel: UserModel
    @EnvironmentObject var tabModel: TabSelectionModel
    @Environment(\.dismiss) var dismiss
    @State private var isDeleting = false
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top banner with tree image and title
                ZStack(alignment: .bottom) {
                    Image("trees")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .clipped()
                    
                    Text("FAVORITE PARKS")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .padding(.bottom, 8)
                }
                
                // Parks List
                List {
                    ForEach(userModel.user.savedParks, id: \.fullName) { park in
                        NavigationLink(destination: ParkDetailView(userModel: userModel, park: park)) {
                            HStack(spacing: 12) {
                                if let imageUrl = park.images?.first?.url,
                                   let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                            .clipped()
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                    }
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(park.fullName ?? "")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text(park.designationAndState) // Helper below
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: userModel.removeParkLocally)
                }
                .listStyle(.plain)
                
                Spacer(minLength: 0)
                
                // Bottom tab bar
                CustomTabBarView(userModel: userModel)
            }
            .onAppear {
                tabModel.selectedTab = 0
                userModel.loadParksFromFirebase()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // Back button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.black)
                    }
                }

                // Delete icon
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .labelStyle(IconOnlyLabelStyle())
                        .foregroundColor(.red)
                        .imageScale(.large)
                        .overlay(
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        )
                }
            }
        }
    }
}

// Helper to format designation and state
extension Park {
    var designationAndState: String {
        let designation = self.designation ?? "National Park"
        let state = self.states ?? "Unknown"
        return "\(designation), \(state)"
    }
}

// MARK: - Preview
#Preview {
    UserParksView(userModel: UserModel())
        .environmentObject(TabSelectionModel())
}
