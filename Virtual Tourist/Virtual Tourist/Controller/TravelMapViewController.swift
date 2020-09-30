//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Mouhamed  on 8/20/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelMapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var dataModelManager : DataModelManager!
    
    var locations = [PinLocation]()  {
        didSet {
            for location in locations {
                let location = Location(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                mapView.addAnnotation(location)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGesture()
        mapView.delegate = self
        fetchPinLocations()
    }
    
    func setupGesture() {
        let mapPingestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePinDrop(gestureRecognizer:)))
        mapPingestureRecognizer.delegate = self
        mapView.addGestureRecognizer(mapPingestureRecognizer)
    }
    
    
    @objc func handlePinDrop(gestureRecognizer: UILongPressGestureRecognizer) {
        let Pinlocation = gestureRecognizer.location(in: mapView)
        let Pincoordinate = mapView.convert(Pinlocation, toCoordinateFrom: mapView)
        let location = Location(coordinate: Pincoordinate)
        let coordinate = PinLocation(context: dataModelManager.Viewcontext)
        coordinate.latitude = location.coordinate.latitude
        coordinate.longitude = location.coordinate.longitude
        saveData()
        mapView.addAnnotation(location)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Location else {return nil}
        
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let latitude = view.annotation?.coordinate.latitude else {return}
        guard let longitude = view.annotation?.coordinate.longitude else {return}
        guard let selectedLocation = fetchSelectedLocationObject(latitude: latitude, longitude: longitude)?.first else {return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let photoAlbvC = storyboard.instantiateViewController(identifier: "PhotoAlbumViewController") as? PhotoAlbumViewController else {fatalError("Failled to instantiate View Controller")}
        photoAlbvC.selectedLocation = selectedLocation
        photoAlbvC.dataModelManager = dataModelManager
        navigationController?.pushViewController(photoAlbvC, animated: false)
    }
    
    
    func saveData() {
        do {
            try self.dataModelManager.Viewcontext.save()
            print("data has been saved")
        } catch {
            print("Error Saving data\(error)")
        }
    }
    
    func fetchPinLocations() {
        let locationFetch: NSFetchRequest<PinLocation> = PinLocation.fetchRequest()
        do {
            locations =  try dataModelManager.Viewcontext.fetch(locationFetch)
        } catch {
            print("Issues Fetching data \(error)")
        }
    }
    
    func fetchSelectedLocationObject(latitude:  CLLocationDegrees , longitude:  CLLocationDegrees) -> [PinLocation]? {
        
        let fetchRequest:NSFetchRequest<PinLocation> = PinLocation.fetchRequest()
        let lonpredicate = NSPredicate(format: "longitude = %@", "\(longitude)")
        let latpredicate = NSPredicate(format: "latitude = %@", "\(latitude)")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [lonpredicate, latpredicate])
        
        
        do {
            let pinLocation = try dataModelManager.Viewcontext.fetch(fetchRequest)
            return pinLocation
        } catch {
            print("Issue fetching object")
            return nil
        }
    }
}

