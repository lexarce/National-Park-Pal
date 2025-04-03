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

    var body: some View {
        NavigationStack {
            VStack {
                Text("Saved Parks")
                
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
                            
                            if let imageUrl = park.images?.first?.url, let url = URL(string: imageUrl) {
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
                
                
                
            }
        }
        .onAppear() {
            userModel.loadParksFromFirebase()
        }
    }
}

#Preview {
    UserParksView(userModel: UserModel())
}
