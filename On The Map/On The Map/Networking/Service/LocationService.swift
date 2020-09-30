//
//  GetLocations.swift
//  On The Map
//
//  Created by Mouhamed  on 8/2/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation

struct LocationSerivce {
    
    static let header = ["application/json": "Content-Type"]
    static let parameter = ["order": "-updatedAt"]
    
    static func getLocation(completion: @escaping (Result<StudentLocations, Error>) -> () ) {
        do {
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: .getPostPutLocatoin, with: LocationSerivce.parameter, includes: LocationSerivce.header, contains: nil, and: .get)
            serviceManager.getRequest(for: request) { (response: Result<Data, Error>) in
                switch response {
                case .success(let data):
                    guard let studentLocation = try? JSONDecoder().decode(StudentLocations.self, from: data) else {return}
                    completion(.success(studentLocation))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
        } catch {
            completion(Result.failure(HTTPNetworkError.badRequest))
        }
    }
    
    static func shareLocation(studentLocation: StudentLocation , completion: @escaping (Result<StudentLocationResponse, Error>) -> ()) {
        
        let studentLocation =  try? JSONEncoder().encode(studentLocation)
        
        do {
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: .getPostPutLocatoin, with: nil, includes: LocationSerivce.header, contains: studentLocation, and: .post)
            
            serviceManager.getRequest(for: request) { (response: Result<Data,Error>) in
                switch response {
                case .success(let data):
                    guard let studentLocationRespnse =  try? JSONDecoder().decode(StudentLocationResponse.self, from: data) else {return}
                    completion(.success(studentLocationRespnse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        catch {
            
        }
    }
}



