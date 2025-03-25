//
//  Untitled.swift
//  National-Park-Pal
//
//  Created by Kaleb on 3/22/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class UserModel: ObservableObject {
    @Published var user: User
    @Published var isAuthenticated: Bool
    
    init() {
        self.user = User()
        self.isAuthenticated = false
    }
    
    func toDict(user:User) -> [String: Any] {
        [
            "name": user.name,
            "email": user.email,
            "password": user.password,
        ]
    }
    
    func authenticateUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
            
        // Get all documents in the collection "users"
        db.collection("users").getDocuments { collection, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(false)
            }
                
            // Check email and password in firebase against each document
            var isAuthenticated = false
            for document in collection!.documents {
                let data = document.data()
                    
                if (data["email"] as? String == email) && (data["password"] as? String == password) {
                    
                    self.user = User(id: document.documentID, data: data) // Set the user data
                    self.isAuthenticated = true
                    isAuthenticated = true
                    break
                }
            }
            
            completion(isAuthenticated)
        }
    }
    
    func createNewUser(_ user: User, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
            
        // Get all documents in the collection "users"
        db.collection("users").getDocuments { collection, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(false)
            }
                
            // Check email and password in firebase against each document
            var isUniqueEmail = true
            for document in collection!.documents {
                let data = document.data()
                    
                if data["email"] as? String == user.email {
                    isUniqueEmail = false
                    break
                }
            }
            
            if isUniqueEmail {
                db.collection("users").addDocument(data: self.toDict(user: user)) { error in
                    if let error = error {
                        print("Error adding document: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        self.isAuthenticated = true
                        self.user = user
                        completion(true)
                    }
                }
            } else {
                completion(false)
        }
        }
    }
}
