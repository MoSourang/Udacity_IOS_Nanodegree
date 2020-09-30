//
//  WeatherNavigationController.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/19/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit

class WeatherNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        definesPresentationContext = true
        super.viewDidLoad()
        guard let WeatherTableViewController =  self.topViewController as? WeatherTableViewController else {fatalError()}
        WeatherTableViewController.WeatherModelManager = weatherModelManager
    }
    var weatherModelManager: WeatherModelManager!
}
