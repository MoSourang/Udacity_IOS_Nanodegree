//
//  MemeViewController.swift
//  MemeMe 2.0
//
//  Created by Mouhamed Sourang on 7/14/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {
    
    var memeImage: UIImage?
    @IBOutlet var memeImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = memeImage
    }

}
