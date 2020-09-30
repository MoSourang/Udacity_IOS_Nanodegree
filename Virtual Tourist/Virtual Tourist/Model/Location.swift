//
//  Location.swift
//  Virtual Tourist
//
//  Created by Mouhamed  on 8/20/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation
import MapKit

class Location: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    

}
