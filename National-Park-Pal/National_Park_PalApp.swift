//
//  National_Park_PalApp.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 3/20/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        db.settings = FirestoreSettings()
        db.settings.isPersistenceEnabled = true // Enable offline and real-time sync
        return true
    }
}

@main
struct National_Park_PalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Shared ViewModels
    @StateObject var userModel = UserModel()
    @StateObject var parkModel = ParkModel()
    @StateObject var tabModel = TabSelectionModel()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(userModel)
                .environmentObject(parkModel)
                .environmentObject(tabModel)
        }
    }
}

