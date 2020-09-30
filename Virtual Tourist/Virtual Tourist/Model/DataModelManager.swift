//
//  DataManager.swift
//  Virtual Tourist
//
//  Created by Mouhamed  on 8/20/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation
import CoreData

class DataModelManager {
    
    
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
