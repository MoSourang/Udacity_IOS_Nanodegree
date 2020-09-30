//
//  WeatherMapNavigationController.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/20/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit

class WeatherMapNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        definesPresentationContext = true
        super.viewDidLoad()
        guard let WeatherMapViewController =  self.topViewController as? WeatherMapViewController else {fatalError()}
        WeatherMapViewController.WeatherModelManager = weatherModelManager
    }
    var weatherModelManager: WeatherModelManager!
}
