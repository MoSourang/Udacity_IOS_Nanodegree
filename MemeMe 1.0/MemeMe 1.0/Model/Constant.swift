//
//  Constant.swift
//  MemeMe 2.0
//
//  Created by Mouhamed Sourang on 7/14/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import Foundation

struct K {
    
    static var didAddNewMeme = Notification(name: Notification.Name(rawValue: "memeAdded"))
    static var didDeleteMeme = Notification(name: Notification.Name(rawValue: "memeDeleted"))
    
    struct identifiers {
         static let collectionCell = "MemeCollectionViewCell"
         static let tableCell = "memeTableViewCell"
         static let memeVC = "MemeViewController" 
    }
    
}
