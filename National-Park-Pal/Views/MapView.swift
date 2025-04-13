//
//  MapView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/13/25.
//

import SwiftUI

struct MapView: View {
    @ObservedObject var userModel: UserModel
    @EnvironmentObject var tabModel: TabSelectionModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("Map View")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer()

                Text("Map functionality coming soon!")
                    .foregroundColor(.gray)

                Spacer()

                CustomTabBarView(userModel: userModel)
            }
            .padding()
            .onAppear {
                tabModel.selectedTab = 1
            }
            .navigationTitle("Park Map")
            .navigationBarTitleDisplayMode(.inline)
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
    MapView(userModel: UserModel())
        .environmentObject(TabSelectionModel())
}
