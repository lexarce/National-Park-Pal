//
//  ThingsToDo.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/17/25.
//

import Foundation

struct ThingsToDoResponse: Codable {
    let data: [ThingToDo]?
}

struct ThingToDo: Codable, Identifiable {
    var id: String { url ?? UUID().uuidString }
    let title: String
    let url: String?
    let shortDescription: String?
    let location: String?
    let duration: String?
    let fee: Bool?
    let images: [ParkImage]?
}

