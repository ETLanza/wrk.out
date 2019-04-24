//
//  SearchController.swift
//  wrk.out
//
//  Created by Sam on 8/27/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
class SearchController {

    var excercises: [Exercise] = []
    var categories: [Category] = []

    static let shared = SearchController()

    static let baseURL = URL(string: "https://wger.de/api/v2/exerciseinfo/?format=json")

    //  static let baseURL = URL(string: "https://wger.de/api/v2/exerciseinfo/?format=json&language=2&status=2")

    
    
    static func getWorkouts (completion: @escaping ([Exercise]?) -> Void) {
        var pageNumber: Int = 1
        while pageNumber < 11 {
            guard let aurl = baseURL else {completion(nil) ; return}
            var components = URLComponents(url: aurl, resolvingAgainstBaseURL: true)
            let languageQuery = URLQueryItem(name: "language", value: "2")
            let pageQuery = URLQueryItem(name: "page", value: String(pageNumber))
            let statusQuery = URLQueryItem(name: "status", value: "2")
            components?.queryItems = [languageQuery, pageQuery, statusQuery]
            guard let dataTaskURL = components?.url else { completion(nil) ; return }

            let key = Keys.Liftset.ckRecordID
            var request = URLRequest(url: dataTaskURL)

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
                    let exercises = try jsonDecoder.decode(TopLevelDictionary.self, from: data)
                    SearchController.shared.excercises += exercises.results
                    completion(exercises.results)
                } catch {
                    print("there was an error decoding workouts from json")
                }
            }
            pageNumber = pageNumber + 1
            dataTask.resume()
        }
    }

    static func getWorkoutImagesMaybe() {

    }
}
