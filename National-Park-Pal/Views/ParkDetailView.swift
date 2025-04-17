//
//  Untitled.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//

import SwiftUI
import FirebaseAuth

struct ParkDetailView: View {
    @ObservedObject var userModel: UserModel
    let park: Park

    var body: some View {
        NavigationStack {
            VStack {

                Text(park.fullName ?? "")
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { userModel.savePark(park) }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
        }
    }
}

#Preview {
    ParkDetailView(userModel: UserModel(), park: Park(
        url: "https://www.nps.gov/sample-park",
        fullName: "Sample National Park",
        description: "A beautiful sample park for preview purposes.",
        latitude: "35.6895",
        longitude: "-105.9378",
        activities: [Activity(name: "Hiking"), Activity(name: "Camping")],
        addresses: [Address(
            countryCode: "US",
            city: "Sample City",
            postalCode: "12345",
            type: "Physical",
            line1: "123 Sample Street",
            stateCode: "AZ"
        )],
        images: [ParkImage(title: "Sample Image", url: "defaultPark")], // Placeholder image
        
        designation: "National Park",
                states: "AZ"
    ))
}
