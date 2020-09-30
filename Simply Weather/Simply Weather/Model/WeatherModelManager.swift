//
//  WeatherDataModelManager.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/19/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation
import CoreData

class WeatherModelManager {
    
    let persistentContainer: NSPersistentContainer!
    
    var Viewcontext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    init(model: String) {
        persistentContainer = NSPersistentContainer(name: model)
    }
    
    func loadData(completion: (()-> Void)? = nil ) {
        persistentContainer.loadPersistentStores { (description , error) in
            guard error == nil else {
                fatalError("Failed to load persistant Store")
            }
            completion?()
        }
    }
}
