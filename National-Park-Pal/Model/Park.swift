//
//  Park.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/28/25.
//

import Foundation
import UIKit
import SwiftUI

class Park: Identifiable
{
    var id: UUID
    var name:String?
    var address:String?
    var description:String?
    var lat: Double
    var lon: Double
    var activities: [String]
    var image: UIImage?
    
    //Initial
    init() {
        self.id = UUID()
        self.name = ""
        self.address = ""
        self.description = ""
        self.lat = 0
        self.lon = 0
        self.activities = []
        self.image = UIImage(named: "default_park")
    }
}
