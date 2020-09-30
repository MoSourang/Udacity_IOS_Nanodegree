//
//  StudentLocationRequest.swift
//  On The Map
//
//  Created by Mouhamed  on 8/6/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    let uniqueKey = "123"
    let firstName =  "John"
    let lastName = "Smith"
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double

}
