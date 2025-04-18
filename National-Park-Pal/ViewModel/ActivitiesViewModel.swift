//
//  ActivitiesViewModel.swift
//  National-Park-Pal
//
//  Created by Alexis Arce on 4/17/25.
//

import Foundation

class ActivitiesViewModel: ObservableObject {
    @Published var activities: [ThingToDo] = []

    func fetchActivities(for parkCode: String) {
        guard let url = URL(string: "https://developer.nps.gov/api/v1/thingstodo?parkCode=\(parkCode)&api_key=\(NPS_API_KEY)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching activities: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(ThingsToDoResponse.self, from: data)
                DispatchQueue.main.async {
                    self.activities = decoded.data ?? []
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
