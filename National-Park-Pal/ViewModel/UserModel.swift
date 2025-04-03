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
        self.user = user
        
        db.collection("users").getDocuments { collection, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            var isUniqueEmail = true
            for document in collection!.documents {
                let data = document.data()
                if data["email"] as? String == self.user.email {
                    isUniqueEmail = false
                    break
                }
            }
            
            if isUniqueEmail {
                db.collection("users").addDocument(data: self.toDict()) { error in
                    if let error = error {
                        print("Error adding document: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    } else {
                        self.user.id = db.collection("users").document().documentID
                        DispatchQueue.main.async {
                            self.isAuthenticated = true
                            completion(true)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }

    
    func loadParksFromFirebase() {
        guard !user.id.isEmpty else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.id).getDocument { document, error in
            if let error = error {
                return
            }
            
            if let data = document?.data(), let savedParksData = data["savedParks"] as? [[String: Any]] {
                let decodedParks = savedParksData.compactMap { parkData in
                    try? JSONSerialization.data(withJSONObject: parkData)
                }.compactMap { data in
                    try? JSONDecoder().decode(Park.self, from: data)
                }
                
                DispatchQueue.main.async {
                    self.user.savedParks = decodedParks
                }
            }
        }
    }
    
    func savePark(_ park: Park) {
        let db = Firestore.firestore()
        let parkDict = parkToDictionary(park) // Convert park to dictionary
        
        if !user.savedParks.contains(where: { $0.fullName == park.fullName }) {
            db.collection("users").document(user.id).updateData([
                "savedParks": FieldValue.arrayUnion([parkDict])
            ]) { error in
                if let error = error {
                } else {
                    self.loadParksFromFirebase()
                }
            }
        }
    }
    
    func removeParkFromFirebase(_ park: Park) {
        let db = Firestore.firestore()
        let parkDict = parkToDictionary(park)
        db.collection("users").document(user.id).updateData([
            "savedParks": FieldValue.arrayRemove([parkDict])
        ]) { error in
            if let error = error {
                print("Error removing park: \(error.localizedDescription)")
            } else {
                print("Park removed successfully!")
                self.loadParksFromFirebase()
            }
        }
    }
    
    func removeParkLocally(at offsets: IndexSet) {
            for index in offsets {
                let park = user.savedParks[index]
                removeParkFromFirebase(park) // Pass the park object to remove it from Firebase
            }
        }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [
            "name": user.name ?? "",
            "email": user.email ?? "",
            "password": user.password ?? ""
        ]
        
        let savedParksDict = user.savedParks.map { park -> [String: Any] in
            return parkToDictionary(park)
        }
        
        dict["savedParks"] = savedParksDict
        
        return dict
    }
    
    func parkToDictionary(_ park: Park) -> [String: Any] {
        return [
            "url": park.url ?? "",
            "fullName": park.fullName ?? "",
            "description": park.description ?? "",
            "latitude": park.latitude ?? "",
            "longitude": park.longitude ?? "",
            "activities": park.activities?.map { self.activityToDictionary($0) } ?? [],
            "addresses": park.addresses?.map { self.addressToDictionary($0) } ?? [],
            "images": park.images?.map { self.imageToDictionary($0) } ?? []
        ]
    }

    private func activityToDictionary(_ activity: Activity) -> [String: Any] {
        return ["name": activity.name ?? ""]
    }
    
    private func addressToDictionary(_ address: Address) -> [String: Any] {
        return [
            "countryCode": address.countryCode ?? "",
            "city": address.city ?? "",
            "postalCode": address.postalCode ?? "",
            "type": address.type ?? "",
            "line1": address.line1 ?? "",
            "stateCode": address.stateCode ?? ""
        ]
    }
    
    private func imageToDictionary(_ image: ParkImage) -> [String: Any] {
        return [
            "title": image.title ?? "",
            "url": image.url ?? ""
        ]
    }
}
