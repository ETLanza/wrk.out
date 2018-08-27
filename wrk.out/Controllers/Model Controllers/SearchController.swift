//
//  SearchController.swift
//  wrk.out
//
//  Created by Sam on 8/27/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
class SearchController {
    static let shared = SearchController()
    
    static let baseURL = URL(string: "https://wger.de/api/v2/exercise/")
    
    static func getWorkouts (completion: @escaping (Results?) -> Void) {
        
        guard let aurl = baseURL else {completion(nil) ; return}
        var request = URLRequest(url: aurl)
        
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("there was an error handling the dataTask \(error.localizedDescription)")
                completion(nil) ; return
            }
            guard let data = data else { completion (nil) ; return }
            let jsonDecoder = JSONDecoder()
            do {
                let workouts = try jsonDecoder.decode(Results.self, from: data)
                completion(workouts)
            } catch {
                print("there was an error decoding workouts from json")
            }
        }
        dataTask.resume()
    }
    static func getWorkoutImagesMaybe() {
        
    }
    
    static func getWorkoutDescription() {
        
    }
}
