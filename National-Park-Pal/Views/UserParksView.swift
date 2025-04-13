//
//  UserParksView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//

import SwiftUI
import FirebaseAuth

struct UserParksView: View {
    @ObservedObject var userModel: UserModel
    @EnvironmentObject var tabModel: TabSelectionModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("Saved Parks")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)

                List {
                    ForEach(userModel.user.savedParks, id: \.fullName) { park in
                        HStack {
                            NavigationLink(destination: ParkDetailView(userModel: userModel, park: park)) {
                                VStack(alignment: .leading) {
                                    Text(park.fullName ?? "")
                                        .font(.headline)
                                }
                            }

                            Spacer()

                            if let imageUrl = park.images?.first?.url,
                               let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    .onDelete(perform: userModel.removeParkLocally)
                }
                .listStyle(.plain)

                Spacer()

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
            }
        }
    }
}

#Preview {
    UserParksView(userModel: UserModel())
        .environmentObject(TabSelectionModel())
}
