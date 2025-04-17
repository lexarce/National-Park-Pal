//
//  Park.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//

import Foundation
import UIKit
import SwiftUI

struct NPSResponse: Codable {
    let data: [Park]?
}

struct Park: Codable, Identifiable {
    var id: String { url ?? UUID().uuidString }
    let url: String?
    let fullName: String?
    let description: String?
    let latitude: String?
    let longitude: String?
    let activities: [Activity]?
    let addresses: [Address]?
    let images: [ParkImage]?
    
    let designation: String?
    let states: String?
}

struct Activity: Codable {
    let name: String?
}

struct Address: Codable {
    let countryCode: String?
    let city: String?
    let postalCode: String?
    let type: String?
    let line1: String?
    let stateCode: String?
}

struct ParkImage: Codable {
    let title: String?
    let url: String?
}
