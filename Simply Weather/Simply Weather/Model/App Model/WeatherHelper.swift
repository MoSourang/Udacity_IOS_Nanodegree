//
//  WeatherHelper.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/17/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation
import MapKit

struct  WeatherHelper {
    
    static func getWeatherIcon(_ conditionId: Int)  -> UIImage {
        var conditionName: String {
            switch conditionId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain.fill"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.sun"
            default:
                return "cloud"
            }
        }
        
        return UIImage(systemName: conditionName)!
    }
    
    static func getCoordinateData(for location: String , completion: @escaping (CLLocationCoordinate2D?,String?,Error?) -> ())  {
        var locationCoordinate = CLLocationCoordinate2D()
        var locationName =  String()
        
        let locationRequest = MKLocalSearch.Request()
        locationRequest.naturalLanguageQuery = location
        
        let search = MKLocalSearch(request: locationRequest)
        search.start { (response, error) in
            
            guard error == nil else {
                completion(nil,nil,error)
                return
            }
            
            guard let response = response else {
                return
            }
            
            let attributes = response.mapItems
            for item in attributes {
                locationCoordinate = item.placemark.coordinate
                guard let location = item.placemark.title else {return}
                locationName = WeatherHelper.modifyString(LocationText: location)
                completion(locationCoordinate, locationName, nil)
            }
        }
    }
    
    static func modifyString(LocationText: String) -> String {
        let modifiedLocationText = LocationText.components(separatedBy: ",")[0]
        return modifiedLocationText
    }
    
    static func getTime(for timezone: String) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: timezone)
        let datetime = formatter.string(from: date)
        return datetime
    }
    
    static func convertDate(for date: Double) -> String {
        let date = NSDate(timeIntervalSince1970: date)
        let day = Calendar.current.component(.weekday, from: date as Date)
        
        var dayOfTheWeek: String {
            switch day {
            case 1:
                return "Sun"
            case 2:
                return "Mon"
            case 3:
                return "Tue"
            case 4:
                return "Wed"
            case 5:
                return "Thu"
            case 6:
                return "Fri"
            case 7:
                return  "Sat"
            default:
                return ""
            }
        }
        return dayOfTheWeek
    }
}
