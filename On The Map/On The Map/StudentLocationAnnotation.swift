//
//  StudentLocation.swift
//  On The Map
//
//  Created by Mouhamed  on 8/4/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import UIKit
import MapKit

class StudentLocationAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, url: String, coordinate: CLLocationCoordinate2D) {
        self.title = name
        self.subtitle = url
        self.coordinate = coordinate
    }
    
}
