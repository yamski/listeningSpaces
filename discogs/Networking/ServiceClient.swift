//
//  ServiceClient.swift
//  discogs
//
//  Created by John Yam on 2/13/18.
//

import Foundation
import OAuthSwift


enum ApiResult<T> {
    case success(T)
    case error(Error)
}

typealias ApiResponseBlock<T> = (ApiResult<T>) -> Void

class ApiClient {

    enum RequestError: Error {
        case genericError
        case parsingError(Error)
    }
    
    let oauthSwift: OAuth1Swift
    let baseUrlString: String
    
    init(oauth: OAuth1Swift, baseUrlString: String) {
        self.oauthSwift = oauth
        self.baseUrlString = baseUrlString
    }
   
    func fetch<T>(resource: Resource<T>, completion: @escaping ApiResponseBlock<T>) {
        
        let dispatchCompletion = dispatchMainQueue(completion)
        let url = buildUrlString(for: resource)
        
        let _ = oauthSwift.client.get(url, success: { (response) in
            
            switch response.response.statusCode {
            case 200:
                let result: ApiResult<T> = self.handleResourceData(response.data, resource: resource)
                dispatchCompletion(result)
            default:
                if let body = String(data: response.data, encoding: .utf8) {
                    print(body)
                }
                dispatchCompletion(.error(RequestError.genericError))
            }
        }) { (error) in
            dispatchCompletion(.error(RequestError.genericError))
        }
    }
    
    
    
    private func handleResourceData<R>(_ data: Data, resource: Resource<R>) -> ApiResult<R> {
        do {
            let object: R = try resource.parse(data)
            return .success(object)
        } catch let e {
            let wrappedError = RequestError.parsingError(e)
            return .error(wrappedError)
        }
    }
   
    private func buildUrlString<T>(for resource: Resource<T>) -> String {
        return baseUrlString + resource.url
    }
    
    private func dispatchMainQueue<T>(_ completion: @escaping ApiResponseBlock<T>) -> ApiResponseBlock<T> {
        return { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
}
