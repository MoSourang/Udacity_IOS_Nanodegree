//
//  Current.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/16/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct Current: Codable {
    let dt: Double
    let temp: Double
    let weather: [Weather]
}
