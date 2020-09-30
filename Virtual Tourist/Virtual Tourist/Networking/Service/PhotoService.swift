//
//  PhotoService.swift
//  Virtual Tourist
//
//  Created by Mouhamed  on 8/23/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation
import UIKit

struct PhotoService {
    
    static let header = ["application/json": "Content-Type"]
    static let method = ["method":"flickr.photos.search"]
    static var count = 1
    static var photosData = [Data]()
    static var APIKey = "Enter Your API Key"
    
    static func getPhotosforLocation(lat: String, lon: String, newPhotos: Bool , completion: @escaping (Result<Photos, Error>) -> () ) {
        let parameter: KeyValuePairs<String, String>
        
        if newPhotos {
            parameter = PhotoService.configureParameter(lat: lat, lon: lon, newPhotos: true)
        } else {
            parameter = PhotoService.configureParameter(lat: lat, lon: lon, newPhotos: false)
        }
        
        
        do {
            let request = try HTTPNetworkRequest.configureHTTPRequest(with: parameter, includes: PhotoService.header, contains: nil, and: .get)
            
            serviceManager.getRequest(for: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let photos = try JSONDecoder().decode(Photos.self, from: data)
                        completion(.success(photos))
                    }catch {
                        print(error)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            print("Issues creating request")
        }
    }
    
    
    
    static func getPhoto(photoInfo: photoResponse ,completion: @escaping (Data) -> ()) {
        
        var imagesFetched = [Data]()
        
            guard let photoURL =  URL(string: "https://farm\(photoInfo.farm).staticflickr.com/\(photoInfo.server)/\(photoInfo.id)_\(photoInfo.secret).jpg") else {return}
            
            let photoRequest = URLRequest(url: photoURL)
            serviceManager.getRequest(for: photoRequest) { (result) in
                switch result {
                case .success(let imageData):
                    completion(imageData)
                    imagesFetched.append(imageData)
                case .failure(let error):
                    print(error)
                }
            }
        
    }
    
    
    
    static func configureParameter(lat: String , lon: String, newPhotos: Bool) -> KeyValuePairs<String, String> {
        var parameter: KeyValuePairs<String, String>
        
        if newPhotos{
            var page: Int {
                count += 1
                return count
            }
            parameter  = ["method":"flickr.photos.search", "api_key": PhotoService.APIKey, "lat": lat,"lon": lon,"per_page": "200","page": "\(page)" ,"format":"json","nojsoncallback":"1" ]
            return parameter
            
        } else {
            parameter = ["method":"flickr.photos.search", "api_key": PhotoService.APIKey, "lat": lat,"lon": lon,"per_page": "200","format":"json","nojsoncallback":"1" ]
            return parameter
        }
    }
}
