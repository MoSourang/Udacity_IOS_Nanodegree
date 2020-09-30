//
//  HTTPNetworkRequest.swift
//  Virtual Tourist
//
//  Created by Mouhamed  on 8/23/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation


let baseURL = "https://www.flickr.com/services/rest/"

public typealias HTTPParameters = KeyValuePairs <String, String>
public typealias HTTPHeaders = [String:String]?


//Manages the creation of URL request, adding parameters and headers to the request
struct HTTPNetworkRequest {
    
    static func configureHTTPRequest(with parameters: HTTPParameters?, includes headers: HTTPHeaders, contains data: Data? , and method: HTTPMethod) throws -> URLRequest {
    
        guard let url = URL(string: baseURL ) else {throw HTTPNetworkError.missingURL}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        try configureParametersAndHeaders(parameters: parameters, headers: headers, request: &request)
        return request
    }
    
    static func configureParametersAndHeaders(parameters: HTTPParameters?, headers: HTTPHeaders?, request: inout URLRequest) throws {
        do {
            if let headers = headers {
                   try URLEncoder.setHeaders(for: &request, with: headers)
            }
            if let parameters = parameters {
                try URLEncoder.encodeParameters(for: &request, with: parameters)
            }
        } catch {
            throw(HTTPNetworkError.encodingFailed)
        }
    }
}
