//
//  MemeCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Mouhamed Sourang on 7/12/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit
import CoreData


class MemeCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: K.didAddNewMeme.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: K.didDeleteMeme.name, object: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.identifiers.collectionCell  , for: indexPath) as? MemeCollectionViewCell else {
            fatalError("Could not get cell")
        }
        
        collectionCell.memeImageView.image = memes[indexPath.item].memeImage
        return collectionCell 
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let memeVC = storyboard?.instantiateViewController(identifier: K.identifiers.memeVC) as? MemeViewController else {
            fatalError("could not instantiate viewController")
        }
        
        memeVC.memeImage = memes[indexPath.row].memeImage
        self.navigationController?.pushViewController(memeVC, animated: true)
    }
    
    
        @objc func reloadData() {
        collectionView.reloadData()
    }
}


