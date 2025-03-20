//
//  SplashScreenView.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 3/20/25.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("National Park Pal")
        }
        .padding()
    }
}

#Preview {
    SplashScreenView()
}
