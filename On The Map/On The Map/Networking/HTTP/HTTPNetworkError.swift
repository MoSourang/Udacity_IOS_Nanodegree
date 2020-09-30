//
//  HTTPNetworkError.swift
//  On The Map
//
//  Created by Mouhamed  on 8/1/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation

public enum HTTPNetworkError: String, Error {
    
    case parametersNil = "Paramaters are nil"
    case headersNil = "Headers are nil"
    case encodingFailed = "Enconding Failed"
    case decodingFailed = "Deconding Failed"
    case missingURL = "URL is missing"
    case couldNotParse = "Could not parse Json Data"
    case success = "Succesfull network request"
    case badRequest = "Bad Request"
    case pageNotFound = "Page not Found"
    case failed = "Request Failed"
    case serverSideError = "Server Error"
    case unWrappingError = "Unwrapping Error"
    case authenticationError = "Wrong Credentials"
    
}
