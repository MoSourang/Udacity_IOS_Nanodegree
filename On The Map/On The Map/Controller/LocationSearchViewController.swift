//
//  LocationSearchViewController.swift
//  On The Map
//
//  Created by Mouhamed  on 7/27/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import UIKit
import MapKit

class LocationSearchViewController: UIViewController {

    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var URLTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        URLTextField.delegate = self
        navigationController?.isToolbarHidden = true
        
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        if locationTextField.text?.count != 0 , URLTextField.text?.count != 0 {
            
            URLTextField.resignFirstResponder()
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = locationTextField.text
            
            guard let addLvc = storyboard?.instantiateViewController(withIdentifier: K.VC.loginVC) as? LocationViewController else {
                fatalError("Could not instantiate VC")
            }
            
            addLvc.searchRequest = searchRequest
            addLvc.url = URLTextField.text ?? ""
            navigationController?.pushViewController(addLvc, animated: true)
        } else {
             alertManager()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Delegates

extension LocationSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    
}

//MARK: - Helpers

extension LocationSearchViewController {
    
    func alertManager() {
        let alert = UIAlertController(title: "Not Inputs Provided", message: "Please provide location & Link", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    

}

