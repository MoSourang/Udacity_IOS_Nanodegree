//
//  WeatherService.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/15/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct WeatherSerivce {
    
    static let header = ["application/json": "Content-Type"]
    static let APIkey = "Enter your API Key"
    
    static func getCurrentWeather(lat: String, lon: String, exclude: String, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
        
        let parameter = WeatherSerivce.setupParameter(lon: lon, lat: lat, exclude: exclude)
        
        do {
            let request = try HTTPNetworkRequest.configureHTTPRequest(with: parameter, includes: header, contains: nil, and: .get)
            
            serviceManager.getRequest(for: request) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                        completion(.success(currentWeather))
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            print("could not create request")
        }
    }
    
    static func getWeeklyWeather(lat: String, lon: String, exclude: String, completion:
        
        @escaping (Result<WeeklyWeather, Error>) -> ()) {
        
        let parameter = WeatherSerivce.setupParameter(lon: lon, lat: lat, exclude: exclude)
        
        do {
            
            let request = try HTTPNetworkRequest.configureHTTPRequest(with: parameter, includes: header, contains: nil, and: .get)
            
            serviceManager.getRequest(for: request) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let weeklyWeather = try JSONDecoder().decode(WeeklyWeather.self, from: data)
                        completion(.success(weeklyWeather))
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            print("could not create request")
        }
    }
    
    static func setupParameter(lon: String, lat: String, exclude: String) -> KeyValuePairs <String, String>? {
        
        let parameter: KeyValuePairs <String, String> = ["lat": lat , "lon": lon, "units": "imperial", "exclude": exclude, "appid": WeatherSerivce.APIkey]
        
        return parameter
    }
}


