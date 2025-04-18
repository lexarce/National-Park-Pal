//
//  Untitled.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/22/25.
//

import Foundation
import UIKit
import SwiftUI

class User: Identifiable {
    var id: String
    var name: String?
    var email: String?
    var password: String?
    var savedParks: [Park]
    
    // Default initializer
    init() {
        self.id = ""
        self.name = ""
        self.email = ""
        self.password = ""
        self.savedParks = []
    }
    
    // Firestore initializer
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["name"] as? String
        self.email = data["email"] as? String
        self.password = data["password"] as? String
        
        // Decode saved parks using JSONDecoder
        if let parksArray = data["savedParks"] as? [[String: Any]] {
            self.savedParks = parksArray.compactMap { dict in
                if let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                   let park = try? JSONDecoder().decode(Park.self, from: jsonData) {
                    return park
                }
                return nil
            }
        } else {
            self.savedParks = []
        }
    }
}


