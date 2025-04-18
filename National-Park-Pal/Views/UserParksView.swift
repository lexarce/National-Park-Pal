//
//  UserParksView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//  Modified by Alexis on 4/17/25.
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
                // Banner
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

                // List of saved parks
                List {
                    ForEach(userModel.user.savedParks, id: \.fullName) { park in
                        HStack(spacing: 12) {
                            // Thumbnail
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

                            // Text info and nav link
                            VStack(alignment: .leading, spacing: 4) {
                                NavigationLink(destination: ParkDetailView(userModel: userModel, park: park)) {
                                    VStack(alignment: .leading) {
                                        Text(park.fullName ?? "")
                                            .font(.headline)
                                        Text(park.designationAndState)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }

                            Spacer()

                            // Delete icon (always visible if isDeleting is true)
                            if isDeleting {
                                Button(action: {
                                    userModel.removeParkFromFirebase(park)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle()) // <- super important in a List row
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)

                // Bottom Tab Bar
                CustomTabBarView(userModel: userModel)
            }
            .onAppear {
                tabModel.selectedTab = 0
                userModel.loadParksFromFirebase()
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

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDeleting.toggle()
                    }) {
                        Image(systemName: isDeleting ? "xmark.circle.fill" : "trash.circle")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

// MARK: - Helper
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
