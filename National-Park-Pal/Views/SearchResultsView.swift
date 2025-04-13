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

    var body: some View {
        VStack {
            Text("Results for:")
                .font(.headline)
            
            Text(searchQuery)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 2)
            
            // Placeholder – populate with real park data later
            Spacer()
            Text("Search results will appear here.")
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .navigationTitle("Search Results")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchResultsView(searchQuery: "Yosemite", userModel: UserModel())
}

