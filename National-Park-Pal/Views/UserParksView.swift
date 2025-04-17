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
                // Tree banner with title
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
                        HStack {
                            NavigationLink(destination: ParkDetailView(userModel: userModel, park: park)) {
                                HStack(spacing: 12) {
                                    // Image thumbnail
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

                                    // Park info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(park.fullName ?? "")
                                            .font(.headline)

                                        Text(park.designationAndState)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }

                            // Trash button if delete mode is active
                            if isDeleting {
                                Spacer()
                                Button(action: {
                                    if let index = userModel.user.savedParks.firstIndex(where: { $0.fullName == park.fullName }) {
                                        userModel.removeParkLocally(at: IndexSet(integer: index))
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
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

                // Delete toggle icon
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDeleting.toggle()
                    }) {
                        Image(systemName: isDeleting ? "xmark.circle.fill" : "minus.circle")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

// MARK: - Park display helper
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
