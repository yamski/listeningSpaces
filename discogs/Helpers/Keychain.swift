//
//  Keychain.swift
//  discogs
//
//  Created by John Yam on 3/14/18.
//  Copyright © 2018 Blue Sombrero. All rights reserved.
//

import Foundation
import KeychainAccess


enum KeychainError: Error {
    case saveError
    case readError
}


struct KeychainCredentials {
    let token: String
    let consumerSecret: String
    let tokenSecret: String
}


class KeychainService {

    static let keychain: Keychain = {
        return Keychain(service: "bsb.discogs")
    }()
    
    class func saveCredentials(token: String, consumerSecret: String, tokenSecret: String) throws {        
        do {
            try keychain.set(token, key: "token")
            try keychain.set(consumerSecret, key: "consumerSecret")
            try keychain.set(tokenSecret, key: "tokenSecret")
        } catch {
            throw KeychainError.saveError
        }
    }
    
    class func getCredentials() throws -> KeychainCredentials {
        do {
            let token = try keychain.get("token")
            let consumerSecret = try keychain.get("consumerSecret")
            let tokenSecret = try keychain.get("tokenSecret")
            
            if let token = token, let consumerSecret = consumerSecret, let tokenSecret = tokenSecret {
                return KeychainCredentials(token: token, consumerSecret: consumerSecret, tokenSecret: tokenSecret)
            } else {
                throw KeychainError.readError
            }
        } catch {
            throw KeychainError.readError
        }
    }

}
