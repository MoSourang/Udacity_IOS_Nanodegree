//
//  StudentInfo.swift
//  On The Map
//
//  Created by Mouhamed  on 8/2/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation

struct StudentInfo: Codable {
    
    let createdAt : String
    let firstName : String
    let lastName  : String
    let latitude  : Double
    let longitude : Double
    let mapString : String
    let mediaURL  : String
    let objectId  : String
    let uniqueKey : String
    let updatedAt : String
}
