//
//  CreateSession .swift
//  On The Map
//
//  Created by Mouhamed  on 8/1/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation

// creates a user session
struct SessionService {
    
    static let postSession = URLSession.shared
    static let header = ["application/json": "Content-Type"]
    
    static func createSession(username: String , password: String , completion: @escaping (Result<LoginResponse, Error>) -> () )  {
        
        let logInfo = LoginInfo(username: username, password: password)
        let userCred = UserCred(udacity: logInfo)
        let data =  try? JSONEncoder().encode(userCred)
        
        do {
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: .createAndDeleteSession, with: nil, includes: SessionService.header, contains: data, and: .post)
            
            serviceManager.getRequest(for: request) { (response) in
                switch response {
                case .success(let data):
                    let newData  =  HelperManager.parseData(data: data)
                    guard let loginresponse = try? JSONDecoder().decode(LoginResponse.self, from: newData) else {return}
                    completion(.success(loginresponse))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
            
        } catch {
            completion(.failure(HTTPNetworkError.badRequest))
        }
    }
    
    
    static func deleteSession(completion: @escaping (Result<LogoutResponse, Error>) -> ()) {
        
        let cookie = HelperManager.fetchCookie()
        do {
            let request =  try HTTPNetworkRequest.configureHTTPRequest(from: .createAndDeleteSession, with: nil, includes: cookie, contains: nil, and: .delete)
            
            serviceManager.getRequest(for: request) { (response) in
                switch response {
                case .success(let data):
                    let newData = HelperManager.parseData(data:data)
                    guard let session = try? JSONDecoder().decode(LogoutResponse.self, from: newData) else {return}
                    completion(.success(session))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(HTTPNetworkError.badRequest))
        }
    }
}


