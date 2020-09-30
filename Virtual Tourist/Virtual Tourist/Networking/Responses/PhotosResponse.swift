//
//  PhotosResponse.swift
//  Virtual Tourist
//
//  Created by Mouhamed  on 8/24/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation

struct PhotosResponse: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [photoResponse]
}
