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
    @Published var npsResponse: NPSResponse
    
    init() {
        self.npsResponse = NPSResponse(data: [])
    }
    
    // State-based method for SearchParksView
    func getJsonData(stateCode: String) {
        let urlAsString = "https://developer.nps.gov/api/v1/parks?stateCode=" + stateCode + "&limit=10&api_key=7g7IQXucHsbKsDrbOFdjDE4h4n8STjxLwajh7aRb"
        
        guard let url = URL(string: urlAsString) else { return }
        
        let urlSession = URLSession.shared
        let jsonQuery = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(NPSResponse.self, from: data)
                DispatchQueue.main.async {
                    self.npsResponse = decodedData
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        jsonQuery.resume()
    }

    // For MapView: fetch parks from all states
    func getAllParksForMap(completion: @escaping ([Park]) -> Void) {
        let stateCodes = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

        var combinedParks: [Park] = []
        let group = DispatchGroup()

        for code in stateCodes {
            group.enter()
            let urlString = "https://developer.nps.gov/api/v1/parks?stateCode=\(code)&limit=10&api_key=7g7IQXucHsbKsDrbOFdjDE4h4n8STjxLwajh7aRb"
            
            guard let url = URL(string: urlString) else {
                group.leave()
                continue
            }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                defer { group.leave() }

                if let data = data,
                   let decoded = try? JSONDecoder().decode(NPSResponse.self, from: data) {
                    combinedParks.append(contentsOf: decoded.data ?? [])
                }
            }.resume()
        }

        group.notify(queue: .main) {
            completion(combinedParks)
        }
    }
}

