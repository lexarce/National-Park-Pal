//
//  HomePageView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/24/25.
//

import SwiftUI
import FirebaseAuth

struct HomePageView: View {
    @ObservedObject var userModel: UserModel

    var body: some View {
        NavigationView {
            VStack {

                Text("Home Page")
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomePageView(userModel: UserModel())
}

