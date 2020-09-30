//
//  URLEncoder.swift
//  Virtual Tourist
//
//  Created by Mouhamed  on 8/23/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//
import Foundation

//encodes the URLRequest with parameters if any and headers
public struct URLEncoder {
    
    static func encodeParameters(for urlRequest: inout URLRequest, with parameters: HTTPParameters?) throws {
        guard parameters != nil else {return}
        
        guard let url = urlRequest.url , let unwrappedParameters = parameters else {throw HTTPNetworkError.missingURL}
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) , !unwrappedParameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value ) in unwrappedParameters {
                let quertyItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(quertyItem)
            }
            urlRequest.url = urlComponents.url
        }
    }
    
    static func setHeaders(for urlRequest: inout URLRequest, with headers: HTTPHeaders) throws {
        guard headers != nil else {return}
        guard let unwrappedHeaders = headers else {throw HTTPNetworkError.headersNil}
        
        for (key, value) in unwrappedHeaders {
            urlRequest.setValue(key , forHTTPHeaderField: value)
        }
    }
}
