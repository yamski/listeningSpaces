//
//  ServiceClient.swift
//  discogs
//
//  Created by John Yam on 2/13/18.
//

import Foundation
import OAuthSwift

typealias JSONDictionary = [String: AnyObject]

enum ApiResult<T> {
    case success(T)
    case error(Error)
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class ServiceClient {

    enum RequestError: Error {
        case genericError
        case parsingError(Error)
    }
    
    static let sharedInstance = ServiceClient()
    private init() {}
    
    let rootURL = "https://api.discogs.com/"
    let userAgent = "ListeningSpaces/0.1"
    
    let oauthSwift: OAuth1Swift = {
        let oauth = OAuth1Swift(consumerKey: "ywGyeFeUnAXXFzvjjhbh",
                    consumerSecret: "EndkvXSVGglBPdphvdwwuQlzokpoHkcr",
                    requestTokenUrl: "https://api.discogs.com/oauth/request_token",
                    authorizeUrl: "https://www.discogs.com/oauth/authorize",
                    accessTokenUrl: "https://api.discogs.com/oauth/access_token")
        return oauth
    }()
    
    let session = URLSession(configuration: .default)
    
    
    func makeRequest(with urlString: String, method: RequestType) -> URLRequest {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = method.rawValue
        return request
    }
    
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        
        guard let url = URL(string: resource.url) else {
            print("problem with URL: \(resource.url)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _ , _ in
            let result = data.flatMap(resource.parse)
            completion(result)
        }.resume()
    }

    
    func authorize<T>(resource: Resource<T>, viewController: UIViewController, completion: @escaping (T?) -> ()) {
        
        oauthSwift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauthSwift)
        
        let _ = oauthSwift.authorize(withCallbackURL: URL(string: "listeningspaces:/oauth_callback")!, success: { (credentials, response, parameters) in
            print("token: \(credentials.oauthToken), consumer secret: \(credentials.consumerSecret), token secret: \(credentials.oauthTokenSecret)")
            print("credentials: \(credentials)")
            
            self.getUserIdentity(resource: resource, completion: completion)
            
        }) { (error) in
            print(error)
        }
    }
    

    func getUserIdentity<T>(resource: Resource<T>, completion: @escaping (T?) -> ()) {
        let _ = oauthSwift.client.get("https://api.discogs.com/oauth/identity", success: { (response) in
//            guard let dataString = response.string else { return }
    
            let response = response.data
            
            let result = resource.parse(response)
            
//            let result = response.string.flatMap(resource.parse)
            
            if let r = result {
                completion(r)
            }
            
    
        }, failure: { (error) in
            print("error")
        })
        
        
    }
    
    func getUserIdentity() {
        let _ = oauthSwift.client.get("https://api.discogs.com/oauth/identity", success: { (response) in
            guard let dataString = response.string else { return }
            print(dataString)
        }, failure: { (error) in
            print("error")
        })
    }
    
    func getCollection() {
        let _ = oauthSwift.client.get("https://api.discogs.com/users/yamski/collection/folders", success: { (response) in
            guard let dataString = response.string else { return }
            print(dataString)
        }, failure: { (error) in
            print("error")
        })
    }
    
    func getCollectionByFolder() {
        let _ = oauthSwift.client.get("https://api.discogs.com/users/yamski/collection/folders/0/releases", success: { (response) in
            guard let dataString = response.string else { return }
            print(dataString)
        }, failure: { (error) in
            print("error")
        })
    }
}
