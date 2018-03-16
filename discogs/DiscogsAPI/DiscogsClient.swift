//
//  DiscogsClient.swift
//  discogs
//
//  Created by John Yam on 3/16/18.
//  Copyright © 2018 Blue Sombrero. All rights reserved.
//

import Foundation
import OAuthSwift

class DiscogsClient: ApiClient {
    
    static let shared: DiscogsClient = {
        let baseURL = "https://api.discogs.com/"
        let oauth = OAuth1Swift(consumerKey: "ywGyeFeUnAXXFzvjjhbh",
                                consumerSecret: "EndkvXSVGglBPdphvdwwuQlzokpoHkcr",
                                requestTokenUrl: "https://api.discogs.com/oauth/request_token",
                                authorizeUrl: "https://www.discogs.com/oauth/authorize",
                                accessTokenUrl: "https://api.discogs.com/oauth/access_token")
        
        return DiscogsClient(oauth: oauth, baseUrlString: baseURL)
    }()
    

    //    let userAgent = "ListeningSpaces/0.1"
    

    
    func setCredentialsFromKeychain(completion: @escaping (Bool) -> ()) {
        
        let cred = try? KeychainService.getCredentials()
        if let cred = cred {
            oauthSwift.client.credential.oauthTokenSecret = cred.tokenSecret
            oauthSwift.client.credential.oauthToken = cred.token
            completion(true)
        } else {
            completion(false)
            // log in
            print("keychain credentials not found.")
        }
    }
    
    
    func authorize(with viewController: UIViewController) {
        self.oauthSwift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauthSwift)
        
        let _ = oauthSwift.authorize(withCallbackURL: URL(string: "listeningspaces:/oauth_callback")!, success: { (credentials, response, parameters) in
            
            do {
                try KeychainService.saveCredentials(token: credentials.oauthToken, consumerSecret: credentials.consumerSecret, tokenSecret: credentials.oauthTokenSecret)
            } catch {
                print("keychain save error")
            }
        }) { (error) in
            print(error)
            
        }
    }
    
    func getUserIdentity<T>(resource: Resource<T>, completion: @escaping ApiResponseBlock<T>) {
        fetch(resource: resource, completion: completion)
    }
}
