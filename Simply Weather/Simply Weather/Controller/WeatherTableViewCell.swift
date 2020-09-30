//
//  WeatherTableViewCell.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/10/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet var city: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var temp: UILabel!
    @IBOutlet var weatherIcon: UIImageView!

}
