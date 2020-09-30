//
//  HTTPNetworkRequest.swift
//  On The Map
//
//  Created by Mouhamed  on 8/1/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation

let baseURL = "https://onthemap-api.udacity.com/v1"
public typealias HTTPParameters = [String: Any]?
public typealias HTTPHeaders = [String:String]?

//Manages the creation of URL request, adding parameters and headers to the request
struct HTTPNetworkRequest {
    static func configureHTTPRequest(from route: HTTPNetworkRoute, with parameters: HTTPParameters?, includes headers: HTTPHeaders, contains data: Data? , and method: HTTPMethod) throws -> URLRequest {
    
        guard let url = URL(string: baseURL + route.rawValue) else {throw HTTPNetworkError.missingURL}
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
