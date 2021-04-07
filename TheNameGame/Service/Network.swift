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
    let endPoint = URL(string: "https://willowtreeapps.com/api/v1.0/profiles")!
    typealias completionHandler = (Result<[Profile], NetworkError>) -> Void
    
    func getProfiles(completion: @escaping  completionHandler) {
        let url = URLRequest(url: endPoint)
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                NSLog("Error occured getting request\(error)")
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
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
        }.resume()
     
    }
}
