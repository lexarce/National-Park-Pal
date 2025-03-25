//
//  Untitled.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/22/25.
//

import Foundation
class User: Identifiable
{
    var id: String
    var name:String?
    var email:String?
    var password:String?
    
    //Initial
    init() {
        id = ""
        self.name = ""
        self.email = ""
        self.password = ""
    }
    
    //Firestore parsing
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["name"] as? String
        self.email = data["email"] as? String
        self.password = data["password"] as? String
    }
}
