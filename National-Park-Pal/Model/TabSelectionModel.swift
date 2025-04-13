//
//  TabSelectionModel.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/13/25.
//

import SwiftUI

class TabSelectionModel: ObservableObject {
    @Published var selectedTab: Int = 2
    // 0 = UserParksView, 1 = MapView, 2 = HomePageView
}
