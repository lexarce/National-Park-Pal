//
//  SearchParksView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//

import SwiftUI
import FirebaseAuth

struct SearchParksView: View {
    @ObservedObject var parkModel: ParkModel

    var body: some View {
        NavigationView {
            VStack {

                Text("Search Parks View")
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SearchParksView(parkModel: ParkModel())
}
