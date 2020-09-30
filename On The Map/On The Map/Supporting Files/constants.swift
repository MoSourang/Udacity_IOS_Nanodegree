//
//  Constants.swift
//  On The Map
//
//  Created by Mouhamed  on 8/3/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation

struct K {
    
    struct URL {
         static let signUpUrl = "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
    }
    
    struct VC  {
        static let loginVC = "AddLocationViewController"
        static let loginNavVC = "loginNavigationController"
        static let tabVc = "TabarViewController"
    }
    

    struct Notifications {
        static let tableViewDidReloadData =  Notification(name: Notification.Name("tableViewReloadedData"))
        static let mapViewDidReloadData =  Notification(name: Notification.Name("mapViewReloadedData"))
        static let locationViewDidAddLocation = Notification(name: Notification.Name("locationViewAddedLocation"))
    }
    
    
}
