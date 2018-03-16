//
//  UserDefaultsExtension.swift
//  discogs
//
//  Created by John Yam on 3/14/18.
//  Copyright © 2018 Blue Sombrero. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    private struct Keys {
        static let userDetails = "userDetails"
        static let userName = "userName"
        static let resourceUrl = "resourceUrl"
        static let userId = "userId"
        static let isLoggedIn = "isLoggedIn"
    }
    
    class func saveUserDetails(userName: String, resourceUrl: String, userId: Int) {
        self.userName = userName
        self.resourceUrl = resourceUrl
        self.userId = userId
    }
    
    class func getUserDetails() -> User? {
        if let userName = self.userName, let resourceUrl = self.resourceUrl, let userId = self.userId {
            return User(username: userName, resourceUrl: resourceUrl, id: userId)
        } else {
            return nil
        }
    }
    
    class var userName: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaults.Keys.userName)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.userName)
        }
    }
    
    class var resourceUrl: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaults.Keys.resourceUrl)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.resourceUrl)
        }
    }
    
    class var userId: Int? {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.Keys.userId)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.userId)
        }
    }
    
    class var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.Keys.isLoggedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.isLoggedIn)
        }
    }
    
    
}
