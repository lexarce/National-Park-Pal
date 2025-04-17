//
//  MapView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/16/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var parkModel = ParkModel()
    @State private var allParks: [Park] = []
    @State private var selectedPark: Park? = nil

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.35), // Start at the center of U.S.
        span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30)
    )

    // Default location is ASU in Tempe, AZ
    let startingLocation = CLLocationCoordinate2D(latitude: 33.4213174, longitude: -111.933163054132)

    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: validParks) { park in
                    MapAnnotation(coordinate: park.coordinate) {
                        Button {
                            openDirections(to: park.coordinate, name: park.name)
                        } label: {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.green)
                        }
                    }
                }
                .ignoresSafeArea()

                VStack {
                    // Top bar
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.white.opacity(0.85))
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        .padding(.leading, 16)

                        Spacer()

                        Text("National Parks Map")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.trailing, 40)

                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.horizontal)

                    Spacer()

                    // Zoom buttons
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            Button(action: zoomIn) {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .padding(10)
                                    .background(Color.white.opacity(0.85))
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                            }

                            Button(action: zoomOut) {
                                Image(systemName: "minus")
                                    .font(.title2)
                                    .padding(10)
                                    .background(Color.white.opacity(0.85))
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                            }
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 40)
                    }
                }
            }
            .onAppear {
                parkModel.getAllParksForMap { parks in
                    self.allParks = parks
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }

    // Filter only parks with valid latitude/longitude
    var validParks: [MappedPark] {
        allParks.compactMap { park in
            guard let lat = Double(park.latitude ?? ""),
                  let lon = Double(park.longitude ?? ""),
                  let name = park.fullName else { return nil }

            return MappedPark(id: park.id, name: name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
    }

    func openDirections(to destination: CLLocationCoordinate2D, name: String) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: startingLocation))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        destination.name = name

        MKMapItem.openMaps(with: [source, destination],
                           launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    func zoomIn() {
        region.span.latitudeDelta /= 2
        region.span.longitudeDelta /= 2
    }

    func zoomOut() {
        region.span.latitudeDelta *= 2
        region.span.longitudeDelta *= 2
    }
}

// Map pin wrapper
struct MappedPark: Identifiable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    MapView()
}

