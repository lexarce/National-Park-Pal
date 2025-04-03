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
    
    func getJsonData(stateCode: String) {
        let urlAsString = "https://developer.nps.gov/api/v1/parks?stateCode="+stateCode+"&limit=10&api_key=7g7IQXucHsbKsDrbOFdjDE4h4n8STjxLwajh7aRb"
        
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
}
