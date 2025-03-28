//
//  ParkModel.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI


class ParkModel: ObservableObject {
    @Published var parkList: [Park]
    
    init() {
        self.parkList = []
    }
    
}
