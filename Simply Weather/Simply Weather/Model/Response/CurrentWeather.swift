//
//  CurrentWeather.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/16/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation


struct CurrentWeather: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: Current
}
