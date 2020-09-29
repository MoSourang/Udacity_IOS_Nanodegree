//
//  MemeTableViewController.swift
//  MemeMe 2.0
//
//  Created by Mouhamed Sourang on 7/12/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit
import CoreData

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: K.didAddNewMeme.name, object: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.tableCell, for: indexPath) as?  MemeTableViewCell else {
            fatalError("Failled to get cell")
        }
        
        tableViewCell.memeImageView.image = memes[indexPath.row].memeImage
        tableViewCell.topLabel.text = memes[indexPath.row].toptextField
        tableViewCell.bottomLabel.text = memes[indexPath.row].bottomTextField
        return tableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memeVC = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as? MemeViewController else {
            fatalError("Could not instantiate View Controller")
        }
    
        memeVC.memeImage = memes[indexPath.row].memeImage
        navigationController?.pushViewController(memeVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            NotificationCenter.default.post(name: K.didDeleteMeme.name, object: self, userInfo: nil)
        }
    }
    

    @objc func reloadData() {
        tableView.reloadData()
    }
}
