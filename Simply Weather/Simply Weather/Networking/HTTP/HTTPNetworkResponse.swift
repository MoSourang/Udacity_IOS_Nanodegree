//
//  HTTPNetworkResponse.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/15/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct HTTPNetworkResponse {
    
    static func handleNetworkResponse(for response: HTTPURLResponse?) -> Result<String, Error> {
        guard let res = response else {return Result.failure(HTTPNetworkError.unWrappingError.self)}
        switch res.statusCode {
        case 200...299: return Result.success(HTTPNetworkError.success.rawValue)
        case 401: return Result.failure(HTTPNetworkError.authenticationError.self)
        case 400...499: return Result.failure(HTTPNetworkError.authenticationError)
        case 500...599: return Result.failure(HTTPNetworkError.badRequest.self)
        default: return Result.failure(HTTPNetworkError.failed.self)
        }
    }
}
