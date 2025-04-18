//
//  VisitorCenter.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/17/25.
//

import Foundation

struct VisitorCenterResponse: Codable {
    let data: [VisitorCenter]
}

struct VisitorCenter: Codable, Identifiable {
    var id: String { idField ?? UUID().uuidString }
    let idField: String?
    let name: String
    let description: String
    let directionsInfo: String?
    let operatingHours: [OperatingHours]?
    let contacts: ContactInfo?
}

struct OperatingHours: Codable {
    let description: String?
    let standardHours: StandardHours?
}

struct StandardHours: Codable {
    let monday, tuesday, wednesday, thursday, friday, saturday, sunday: String?
}

struct ContactInfo: Codable {
    let phoneNumbers: [PhoneNumber]?
    let emailAddresses: [EmailAddress]?
}

struct PhoneNumber: Codable {
    let phoneNumber: String
    let type: String
}

struct EmailAddress: Codable {
    let emailAddress: String
}
