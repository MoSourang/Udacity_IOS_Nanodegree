//
//  Weekly.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/20/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct Weekly: Codable {
    let dt: Double
    let temp: Temp
    let weather: [Weather]
}
