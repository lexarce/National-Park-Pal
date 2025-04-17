//
//  ParkPreviewView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/16/25.
//

import SwiftUI

struct ParkPreviewView: View {
    var park: Park
    var onDirectionsTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(park.fullName ?? "Unknown Park")
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(1)

            Text(park.description ?? "No description available.")
                .font(.subheadline)
                .lineLimit(3)

            HStack {
                Spacer()
                Button(action: onDirectionsTapped) {
                    Label("Get Directions", systemImage: "car.fill")
                        .font(.callout)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    ParkPreviewView(
        park: Park(
            url: "https://www.nps.gov/zion/index.htm",
            fullName: "Zion National Park",
            description: "Zion is Utah’s first national park, known for its massive sandstone cliffs.",
            latitude: "37.2982",
            longitude: "-113.0263",
            activities: [Activity(name: "Hiking"), Activity(name: "Camping")],
            addresses: [],
            images: [ParkImage(title: "Zion Canyon", url: "https://www.nps.gov/common/uploads/structured_data/3C7D7357-1DD8-B71B-0B9BE52C052C88AA.jpg")]
        ),
        onDirectionsTapped: {
            print("Directions button tapped")
        }
    )
    .previewLayout(.sizeThatFits)
    .padding()
}

