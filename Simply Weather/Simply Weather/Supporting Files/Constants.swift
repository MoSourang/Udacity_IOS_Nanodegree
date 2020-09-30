//
//  Constants .swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/16/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation


struct K {
    
    struct Notifications {
        static let LocationWeatherDataAdded = Notification(name: Notification.Name("LocationWeatherDataAdded"))
        static let MapWeatherDataAdded  = Notification(name: Notification.Name("MapWeatherDataAdded"))
        static let TableViewDeletedData = Notification(name: Notification.Name("TableViewDeletedData"))
    }
    
    struct Storyboard {
        static let WeatherDetailedStoryboard = "WeatherDetailedStoryboard"
    }
    
    struct Controllers {
        static let WeatherDetailViewController = "WeatherDetailViewController"
    }
    
    struct Cell {
        static let weatherCell  = "weatherCell"
    }
}
