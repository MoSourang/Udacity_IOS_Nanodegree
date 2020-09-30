//
//  HTTPNetworkError.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/15/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
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
