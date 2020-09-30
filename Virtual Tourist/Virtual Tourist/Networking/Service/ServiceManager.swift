//
//  ServiceManager.swift
//  Virtual Tourist
//
//  Created by Mouhamed  on 8/23/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation

// Manages the processing of request from all of the different API calls
struct serviceManager {
    
    static let session = URLSession.shared
    
    static func getRequest(for request: URLRequest,  completion: @escaping (Result<Data, Error>) -> ()) {
        
        session.dataTask(with: request) { (data, res, err) in
            if let response = res as? HTTPURLResponse , let unwrappedata = data {
                let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                switch result {
                case .success:
                    completion(.success(unwrappedata))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    
    
    
}
