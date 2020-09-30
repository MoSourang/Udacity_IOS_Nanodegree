//
//  MapViewController.swift
//  On The Map
//
//  Created by Mouhamed  on 7/26/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var MapView: MKMapView!
    let studentInformation = StudentInformation()

    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        fetchLocation()
        subscribeToNotificaiton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToNotificaiton()
    }
   
    
     @objc func fetchLocation() {
        LocationSerivce.getLocation { (response) in
            switch response {
            case .success( let studentlocation):
                self.studentInformation.information = studentlocation.results
                self.setupMap()
            case.failure(let error):
                print("Error Fetching location data \(error)")
            }
        }
    }
    
    
    // iterate through the array of location data and populate the map
    func setupMap() {
        DispatchQueue.main.async {
            for location in self.studentInformation.information {
                if location.firstName != "" , location.lastName != "" {
                    let studentLocation = StudentLocationAnnotation(name: "\(location.firstName) \(location.lastName)", url: location.mediaURL, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    self.MapView.addAnnotation(studentLocation)
                }
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is StudentLocationAnnotation else {return nil}
        let indentifer = "identifier"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: indentifer)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: indentifer)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
         return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let _ = view.annotation as? StudentLocationAnnotation else {return}
        
        guard let url = view.annotation?.subtitle else {return}
        
        if HelperManager.openURL(urlString: url) {
              alertManager()
          }
    }
    
    
    @IBAction func refreshedTapped(_ sender: Any) {
        fetchLocation()
        sendNotification()
    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        SessionService.deleteSession { (response) in
            switch response {
            case .success( _):
                self.logoutUser()
                HelperManager.setLoginState(to: false)
            case .failure(let error):
                print("logout Failled\(error)")
            }
        }
        
    }
    
    func logoutUser() {
        DispatchQueue.main.async {
            guard let loginvc = self.storyboard?.instantiateViewController(identifier: K.VC.loginNavVC) else {return}
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginvc)
        }
    }
    
}

//MARK: - Helpers
extension MapViewController {
    
    func alertManager() {
        let alert = UIAlertController(title: "Invalid URL", message: "Please try another URl", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
    
    
    func subscribeToNotificaiton() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchLocation), name: K.Notifications.tableViewDidReloadData.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchLocation), name: K.Notifications.locationViewDidAddLocation.name, object: nil)
    }
    
    
    func unsubscribeToNotificaiton() {
        NotificationCenter.default.removeObserver(self, name: K.Notifications.tableViewDidReloadData.name, object: nil)
        NotificationCenter.default.removeObserver(self, name: K.Notifications.locationViewDidAddLocation.name, object: nil)
    }
    
    func sendNotification() {
        NotificationCenter.default.post(name: K.Notifications.mapViewDidReloadData.name, object: self)
    }
}
