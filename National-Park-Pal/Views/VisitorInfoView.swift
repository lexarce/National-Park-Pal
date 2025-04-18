//
//  VisitorInfoView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/17/25.
//

import SwiftUI

struct VisitorInfoView: View {
    let park: Park
    @StateObject private var viewModel = VisitorInfoViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Banner image and title
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

                // List of visitor centers
                List(viewModel.centers) { center in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(center.name)
                            .font(.headline)
                        Text(center.description)
                            .font(.body)

                        if let directions = center.directionsInfo {
                            Text("Directions: \(directions)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if let hours = center.operatingHours?.first {
                            Text("Hours: \(hours.standardHours?.monday ?? "") - \(hours.standardHours?.sunday ?? "")")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }

                        if let contact = center.contacts {
                            if let phone = contact.phoneNumbers?.first {
                                Text("Phone: \(phone.phoneNumber)")
                                    .font(.footnote)
                            }

                            if let email = contact.emailAddresses?.first {
                                Text("Email: \(email.emailAddress)")
                                    .font(.footnote)
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("Visitor Info", displayMode: .inline)
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
                viewModel.fetchVisitorInfo(for: park.parkCode ?? "")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VisitorInfoView(park: Park(
        url: "https://www.nps.gov/sample",
        fullName: "Zion National Park",
        description: "Zion's history and landscape.",
        latitude: "37.2982",
        longitude: "-113.0263",
        activities: nil,
        addresses: [Address(
            countryCode: "US",
            city: "Springdale",
            postalCode: "84767",
            type: "Physical",
            line1: "1 Zion Park Blvd",
            stateCode: "UT"
        )],
        images: [ParkImage(title: "Zion", url: "https://www.nps.gov/common/uploads/structured_data/3C7D0539-1DD8-B71B-0BCEB89A92B54A47.jpg")],
        designation: "National Park",
        states: "UT",
        parkCode: "zion"
    ))
}
