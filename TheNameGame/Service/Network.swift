//
//  Network.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import Foundation
import Alamofire


enum NetworkError: Error {
    case failedToDecode
    case noData
    case invalidResponse
    case otherError
}

class Network {
    
    let endPointUrl = "https://willowtreeapps.com/api/v1.0/profiles"
    typealias completionHandler = (Result<[Profile], NetworkError>) -> Void
    
    internal func getProfiles(completion: @escaping  completionHandler) {
        
        AF.request(endPointUrl).response { response in
            if let error = response.error {
                NSLog("Error occured getting request\(error)")
                completion(.failure(.otherError))
            }
            
            guard let data = response.data else {
                NSLog("Failure no data from API")
                completion(.failure(.noData))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let profiles = try jsonDecoder.decode([Profile].self, from: data)
                completion(.success(profiles))
                
            } catch {
                NSLog("Failed to decode data", "\(error.localizedDescription)")
                completion(.failure(.failedToDecode))
            }
        }
    }
}
