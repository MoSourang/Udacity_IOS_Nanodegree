//
//  WeatherTabBarController.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/20/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit

class WeatherTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let weatherModelManager = WeatherModelManager(model: "WeatherModel")
        weatherModelManager.loadData()
        let weatherNacVc = self.viewControllers![0] as? WeatherNavigationController
        let weatherMapNavVc = self.viewControllers![1] as? WeatherMapNavigationController
        weatherNacVc?.weatherModelManager = weatherModelManager
        weatherMapNavVc?.weatherModelManager = weatherModelManager
    }
}
