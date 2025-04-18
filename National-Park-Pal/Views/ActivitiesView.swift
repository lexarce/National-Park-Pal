//
//  ActivitiesView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/17/25.
//

import SwiftUI

struct ActivitiesView: View {
    let park: Park
    @StateObject private var viewModel = ActivitiesViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header image
                ZStack(alignment: .bottomLeading) {
                    if let imageUrl = park.images?.first?.url,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                        } placeholder: {
                            Color.gray.frame(height: 200)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text(park.fullName ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        if let address = park.addresses?.first {
                            Text("\(address.line1 ?? ""), \(address.city ?? ""), \(address.stateCode ?? "")")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                    .padding()
                }

                // Activity list
                List(viewModel.activities) { activity in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top) {
                            if let imageUrl = activity.images?.first?.url,
                               let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(10)
                                } placeholder: {
                                    Rectangle().fill(Color.gray.opacity(0.3))
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(10)
                                }
                            }

                            VStack(alignment: .leading) {
                                Text(activity.title)
                                    .font(.headline)
                                if let duration = activity.duration {
                                    Text(duration)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                if activity.fee == true {
                                    Text("• Fee Required")
                                        .font(.footnote)
                                        .foregroundColor(.red)
                                }
                            }
                        }

                        if let desc = activity.shortDescription {
                            Text(desc)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("Things to Do", displayMode: .inline)
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
            .onAppear {
                viewModel.fetchActivities(for: park.parkCode ?? "")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ActivitiesView(park: Park(
        url: "https://www.nps.gov/zion",
        fullName: "Zion National Park",
        description: "Test",
        latitude: "37.3", longitude: "-113.0",
        activities: nil,
        addresses: [Address(
            countryCode: "US",
            city: "Springdale",
            postalCode: "84767",
            type: "Physical",
            line1: "1 Zion Park Blvd",
            stateCode: "UT"
        )],
        images: [ParkImage(title: "Sample", url: "https://www.nps.gov/common/uploads/structured_data/3C7D0539-1DD8-B71B-0BCEB89A92B54A47.jpg")],
        designation: "National Park",
        states: "UT",
        parkCode: "zion"
    ))
}
