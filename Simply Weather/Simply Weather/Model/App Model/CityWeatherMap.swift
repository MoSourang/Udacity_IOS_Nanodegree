//
//  CityWeatherMap.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/20/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation
import MapKit

class CityWeatherMap: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, url: String, coordinate: CLLocationCoordinate2D) {
        self.title = name
        self.subtitle = url
        self.coordinate = coordinate
    }
}
