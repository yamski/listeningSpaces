//
//  Resource.swift
//  discogs
//
//  Created by John Yam on 2/26/18.
//  Copyright © 2018 Blue Sombrero. All rights reserved.
//

import Foundation

struct Resource<T> {
    let url : String
    let parse: (Data) -> T?
}

extension Resource {
    init(url: String, parseJSON: @escaping (Any) -> T?) {
        self.url = url
        
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

extension Resource where T: Decodable {
    init(url: String) {
        self.url = url
        self.parse = { data in return try? JSONDecoder().decode(T.self, from: data) }
    }
}
