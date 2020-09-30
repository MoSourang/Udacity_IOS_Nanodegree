//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Mouhamed on 7/27/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController , MKMapViewDelegate {
    
    
    @IBOutlet var MapView: MKMapView!
    var searchRequest = MKLocalSearch.Request()
    var url = ""
    var studentLocation = StudentLocation(mapString: "", mediaURL: "", latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        searchLocation(for: searchRequest)
    }
    
    func searchLocation(for searchRequest : MKLocalSearch.Request) {
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                self.alertManager()
                return
            }
            
            let mapattribute = response.mapItems
            for item in mapattribute {
                let coordinate = item.placemark.coordinate
                let loocationName = item.placemark.title
                DispatchQueue.main.async {
                    self.pinLocation(pin: coordinate, for: loocationName )
                    
                }
            }
        }
    }
    
    func pinLocation(pin coordinate: CLLocationCoordinate2D?, for locationName: String?) {
        
        if let coordinate = coordinate , let locationName = locationName {
            studentLocation.latitude = coordinate.latitude
            studentLocation.longitude = coordinate.longitude
            studentLocation.mapString = locationName
            studentLocation.mediaURL = url
            let regionRadious: Double = 1000
            let annotation = StudentLocationAnnotation(name: locationName, url: url, coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
            MapView.addAnnotation(annotation)
            MapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), latitudinalMeters: regionRadious, longitudinalMeters: regionRadious), animated: true)
        } else {
            alertManager()
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is StudentLocationAnnotation else {return nil}
        let identifier = "StudentLocation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    
    
    @IBAction func FinishButtonPressed(_ sender: Any) {
        
        LocationSerivce.shareLocation(studentLocation: studentLocation) { (result) in
            switch result {
            case .success( _):
                self.sendNotification()
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            case . failure(let error):
                self.alertManager()
                print("someting went wrong \(error)")
            }
        }
    }
    
}


//MARK: - Helpers

extension LocationViewController {
    
    func alertManager() {
        let alert = UIAlertController(title: "Failed to share Location", message: "Please Try Again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func sendNotification() {
        NotificationCenter.default.post(name: K.Notifications.locationViewDidAddLocation.name, object: self)
    }
    
}




