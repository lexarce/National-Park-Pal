//
//  MapView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/13/25.
//

import SwiftUI

struct MapView: View {
    @ObservedObject var userModel: UserModel

    var body: some View {
        VStack {
            Text("Map View")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Text("Map functionality coming soon!")
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .navigationTitle("Park Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MapView(userModel: UserModel())
}

