//
//  User.swift
//  discogs
//
//  Created by John Yam on 2/23/18.
//

import Foundation

struct User: Codable {
    let username: String
    let resourceUrl: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case username
        case resourceUrl = "resource_url"
        case id
    }
}

extension User {
    static let authenticatedUser = {
        return Resource<User>(url:"https://api.discogs.com/oauth/identity")
    }()
}
