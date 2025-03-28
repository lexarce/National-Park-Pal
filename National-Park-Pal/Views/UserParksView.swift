//
//  UserParksView.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//

import SwiftUI
import FirebaseAuth

struct UserParksView: View {
    @ObservedObject var userModel: UserModel

    var body: some View {
        NavigationView {
            VStack {

                Text("Saved Parks View")
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    UserParksView(userModel: UserModel())
}
