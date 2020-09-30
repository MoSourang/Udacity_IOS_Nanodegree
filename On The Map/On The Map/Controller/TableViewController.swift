//
//  TableViewController.swift
//  On The Map
//
//  Created by Mouhamed  on 7/26/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var studentInformation = StudentInformation()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocationData()
        subscribeToNotification()
        tableView.allowsSelection = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studentInformation.information.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let locationCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? LocationCellTableViewCell else { fatalError("Failed to create cell")}
        locationCell.nameLabel.text = ("\(self.studentInformation.information[indexPath.row].firstName)  \(self.studentInformation.information[indexPath.row].lastName)")
        locationCell.locationLink.text = self.studentInformation.information[indexPath.row].mediaURL
        return locationCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .gray
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        let mediaUrl = studentInformation.information[indexPath.row].mediaURL
        if HelperManager.openURL(urlString: mediaUrl) {
            alertManager()
        }
    }
    
    
    @IBAction func refreshedTapped(_ sender: Any) {
        fetchLocationData()
        sendNotification()
    }
    
    
    @IBAction func logOutTapped(_ sender: Any) {
            SessionService.deleteSession { (response) in
                switch response {
                case .success(_):
                    self.logoutUser()
                    HelperManager.setLoginState(to: false)
                    self.defaults.set(AppState.islogedIn, forKey: "loggedIn")
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    
    func logoutUser () {
        DispatchQueue.main.async {
            guard let loginVc = self.storyboard?.instantiateViewController(identifier: K.VC.loginNavVC) else {return}
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginVc)
        }
     }
    
    
    @objc func fetchLocationData() {
        LocationSerivce.getLocation { (result) in
            switch result {
            case .success(let studentlocation):
                self.studentInformation.information = studentlocation.results
                self.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Helpers 

extension TableViewController {
    
    func alertManager() {
        let alert = UIAlertController(title: "Invalid URL", message: "Please try another URl", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
    
    
    func sendNotification() {
        NotificationCenter.default.post(name: K.Notifications.tableViewDidReloadData.name, object: self)
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchLocationData), name: K.Notifications.mapViewDidReloadData.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchLocationData), name: K.Notifications.locationViewDidAddLocation.name, object: nil)
    }
    
    func unsubscribeToNotification() {
        NotificationCenter.default.removeObserver(self, name: K.Notifications.mapViewDidReloadData.name, object: nil)
        NotificationCenter.default.removeObserver(self, name: K.Notifications.locationViewDidAddLocation.name, object: nil)
    }
    
}

