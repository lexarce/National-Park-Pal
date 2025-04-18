//
//  SearchResultsView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/13/25.
//

import SwiftUI

struct SearchResultsView: View {
    var searchQuery: String
    @ObservedObject var userModel: UserModel
    @StateObject private var parkModel = ParkModel()
    @State private var results: [Park] = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if results.isEmpty {
                Spacer()
                ProgressView("Searching parks for \"\(searchQuery)\"...")
                Spacer()
            } else {
                List(results, id: \.id) { park in
                    NavigationLink(destination: ParkDetailView(userModel: userModel, park: park)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(park.fullName ?? "")
                                    .font(.headline)
                                Text(park.states ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            if let url = URL(string: park.images?.first?.url ?? "") {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationBarTitle("Search Results", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            }
        }
        
        .onAppear {
            parkModel.searchParks(query: searchQuery) { foundParks in
                self.results = foundParks
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let mockPark = Park(
        url: "https://www.nps.gov/sample",
        fullName: "Grand Canyon National Park",
        description: "One of the most breathtaking natural wonders in the United States.",
        latitude: "36.1069",
        longitude: "-112.1129",
        activities: [Activity(name: "Hiking"), Activity(name: "Camping")],
        addresses: [Address(
            countryCode: "US",
            city: "Grand Canyon",
            postalCode: "86023",
            type: "Physical",
            line1: "S Entrance Rd",
            stateCode: "AZ"
        )],
        images: [ParkImage(
            title: "Canyon View",
            url: "https://www.nps.gov/common/uploads/structured_data/3C8611E8-1DD8-B71B-0B7EAD32D47511F6.jpg"
        )],
        designation: "National Park",
        states: "AZ",
        parkCode: "grca"
    )

    return SearchResultsView(
        searchQuery: "Grand Canyon",
        userModel: UserModel()
    )
    .onAppear {
    }
}

