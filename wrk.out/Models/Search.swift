//
//  Search.swift
//  wrk.out
//
//  Created by Sam on 8/22/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
struct topLevelDictionary: Decodable {
    let results: [Results]
    
}

struct Results: Decodable {
    let name: String
    let description: String
    let category: [Category]
    
}

struct Category: Decodable {
    let name: String
    
}
