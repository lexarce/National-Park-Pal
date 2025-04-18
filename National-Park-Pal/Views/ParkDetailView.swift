//
//  ParkDetailView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//

import SwiftUI
import MapKit

struct ParkDetailView: View {
    @ObservedObject var userModel: UserModel
    let park: Park
    @Environment(\.dismiss) var dismiss

    @State private var isSaved = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // ASU Tempe location
    let asuLocation = CLLocationCoordinate2D(latitude: 33.4213174, longitude: -111.933163054132)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Banner image
                ZStack(alignment: .bottomLeading) {
                    if let imageUrl = park.images?.first?.url,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(height: 240)
                                .clipped()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                                .frame(height: 240)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(park.fullName ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        if let address = park.addresses?.first {
                            Text("\(address.line1 ?? ""), \(address.city ?? ""), \(address.stateCode ?? "") \(address.postalCode ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .shadow(radius: 4)
                }

                // Description
                Text(park.description ?? "")
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.leading)

                Spacer().frame(height: 16)

                // Buttons
                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        NavigationLink(destination: ActivitiesView(park: park)) {
                            ParkActionButton(icon: "mountain.2", text: "THINGS TO DO")
                                .padding(.bottom, 5)
                        }

                        NavigationLink(destination: VisitorInfoView(park: park)) {
                            ParkActionButton(icon: "book", text: "VISITOR INFO")
                                .padding(.bottom, 5)
                        }
                    }

                    Button(action: openMaps) {
                        ParkActionButton(icon: "map", text: "GET DIRECTIONS", isFullWidth: true)
                    }
                }
                .padding(.horizontal)

                Spacer()

                CustomTabBarView(userModel: userModel)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.black)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: toggleSaveStatus) {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage))
            }
            .onAppear {
                isSaved = userModel.user.savedParks.contains(where: { $0.fullName == park.fullName })
            }
        }
    }

    func toggleSaveStatus() {
        if isSaved {
            userModel.removeParkFromFirebase(park)
            alertMessage = "Park removed from favorites!"
        } else {
            userModel.savePark(park)
            alertMessage = "Park saved successfully!"
        }

        isSaved.toggle()
        showAlert = true
    }

    func openMaps() {
        guard let lat = Double(park.latitude ?? ""),
              let lon = Double(park.longitude ?? "") else { return }

        let destination = MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)))
        destination.name = park.fullName

        let source = MKMapItem(placemark: .init(coordinate: asuLocation))
        source.name = "ASU Tempe"

        MKMapItem.openMaps(with: [source, destination], launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

struct ParkActionButton: View {
    var icon: String
    var text: String
    var isFullWidth: Bool = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.headline)
            Text(text)
                .fontWeight(.bold)
        }
        .frame(maxWidth: isFullWidth ? .infinity : 150, minHeight: 50)
        .background(Color(hex: "37542E"))
        .foregroundColor(.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}

// MARK: - Preview
#Preview {
    ParkDetailView(
        userModel: UserModel(),
        park: Park(
            url: "https://www.nps.gov/sample",
            fullName: "Zion National Park",
            description: "Walk ancient paths, marvel at towering sandstone cliffs, and explore narrow canyons. Zion’s unique wildlife and rich history offer an unforgettable adventure.",
            latitude: "37.2982",
            longitude: "-113.0263",
            activities: [Activity(name: "Hiking"), Activity(name: "Stargazing")],
            addresses: [Address(
                countryCode: "US",
                city: "Springdale",
                postalCode: "84767",
                type: "Physical",
                line1: "1 Zion Park Blvd.",
                stateCode: "UT"
            )],
            images: [ParkImage(
                title: "Zion Banner",
                url: "https://www.nps.gov/common/uploads/structured_data/3C7D0539-1DD8-B71B-0BCEB89A92B54A47.jpg"
            )],
            designation: "National Park",
            states: "UT",
            parkCode: "zion"
        )
    )
    .environmentObject(TabSelectionModel())
}
