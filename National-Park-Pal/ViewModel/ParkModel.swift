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

let NPS_API_KEY = "7g7IQXucHsbKsDrbOFdjDE4h4n8STjxLwajh7aRb"

class ParkModel: ObservableObject {
    @Published var npsResponse: NPSResponse
    
    init() {
        self.npsResponse = NPSResponse(data: [])
    }
    
    // State-based method for SearchParksView
    func getJsonData(stateCode: String) {
        let urlAsString = "https://developer.nps.gov/api/v1/parks?stateCode=\(stateCode)&limit=10&api_key=\(NPS_API_KEY)"
        
        guard let url = URL(string: urlAsString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
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
        }.resume()
    }
    
    // For MapView: fetch parks from all states
    func getAllParksForMap(completion: @escaping ([Park]) -> Void) {
        let stateCodes = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

        var combinedParks: [Park] = []
        let group = DispatchGroup()

        for code in stateCodes {
            group.enter()
            let urlString = "https://developer.nps.gov/api/v1/parks?stateCode=\(code)&limit=10&api_key=\(NPS_API_KEY)"
            
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
    
    // Search box function
    func searchParks(query: String, completion: @escaping ([Park]) -> Void) {
        let urlEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://developer.nps.gov/api/v1/parks?q=\(urlEncodedQuery)&limit=50&api_key=\(NPS_API_KEY)"

        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let decoded = try? JSONDecoder().decode(NPSResponse.self, from: data) {
                DispatchQueue.main.async {
                    completion(decoded.data ?? [])
                }
            } else {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
}


