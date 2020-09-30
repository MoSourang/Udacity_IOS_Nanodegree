//
//  PhotoResponse.swift
//  Virtual Tourist
//
//  Created by Mouhamed Sourang on 8/24/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct photoResponse: Codable {
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String?
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    
}
