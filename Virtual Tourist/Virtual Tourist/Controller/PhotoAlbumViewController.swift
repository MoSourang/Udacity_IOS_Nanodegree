//
//  PhotoAlbum ViewController.swift
//  Virtual Tourist
//
//  Created by Mouhamed  on 8/20/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var selectedLocation: PinLocation!
    var images = [UIImage]()
    var dataModelManager : DataModelManager!
    @IBOutlet var NewCollectionButton: UIButton!
    @IBOutlet var photoCollectionView: UICollectionView!
    var numberofReturnedImages = Int()
    var isDownloading = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepageImageArray()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        mapView.delegate = self
        addPin()
        fetchPhotos()
    }
    
    func fetchPhotos() {
        if selectedLocation.photos?.count == 0 {
            fetchPhotosFromFlicker()
        }  else {
            fetchPhotosFromCoreData()
        }
    }
    
    func addPin() {
        let regionRadious: Double = 1000
        let pinLocation = Location(coordinate: CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude))
        mapView.addAnnotation(pinLocation)
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude), latitudinalMeters: regionRadious, longitudinalMeters: regionRadious), animated: true)
    }
    
    func fetchPhotosFromFlicker() {
        NewCollectionButton.isEnabled = false
        let latitude: String = String(selectedLocation.latitude)
        let longitue: String = String(selectedLocation.longitude)
        PhotoService.getPhotosforLocation(lat: latitude, lon: longitue, newPhotos: false) { (result) in
            switch result {
            case .success(let photos):
                self.makeImage(for: photos)
            case .failure( _):
                print("Issues Fetching Image URLs")
            }
        }
    }
    
    func fetchPhotosFromCoreData () {
        guard let photos = selectedLocation.photos?.allObjects as? [Photo] else {return}
        guard let  imageCount = selectedLocation.photos?.count else {return}
        numberofReturnedImages = imageCount
        for photo in photos {
            guard let imageData = photo.photo else {return}
            if let image = UIImage(data: imageData) {
                images.append(image)
                reloadData()
            }
        }
    }
    
    
    func makeImage(for photos: Photos) {
        let photosInfo = photos.photos.photo
        
        if !photosInfo.isEmpty {
            self.numberofReturnedImages = photosInfo.count
            SetupImageArray(for: numberofReturnedImages)
            var photoIndex = 0
            var photoIndexPath = IndexPath(item: photoIndex, section: 0)
            for photoInfo in photosInfo {
                isDownloading = true
                PhotoService.getPhoto(photoInfo: photoInfo) { (photosData) in
                    guard let image = UIImage(data: photosData) else {return}
                    photoIndexPath = IndexPath(item: photoIndex, section: 0)
                    self.images[photoIndex] = image
                    self.reloadCell(at: photoIndexPath)
                    self.addFetchImagetoCoreData(image: image)
                    photoIndex += 1
                }
            }
            
            DispatchQueue.main.async {
                self.NewCollectionButton.isEnabled = true
                self.isDownloading = false
            }
        } else {
            return
        }
        
    }
    
    @IBAction func NewCollectionPressed(_ sender: UIButton) {
        images.removeAll()
        selectedLocation.photos = nil
        NewCollectionButton.isEnabled = false
        let latitude: String = String(selectedLocation.latitude)
        let longitue: String = String(selectedLocation.longitude)
        
        PhotoService.getPhotosforLocation(lat: latitude, lon: longitue, newPhotos: true) { (result) in
            switch result {
            case .success(let photos):
                if !photos.photos.photo.isEmpty {
                    DispatchQueue.main.async {
                        self.makeImage(for: photos)
                    }
                } else {
                    print("No more images at this location")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func SetupImageArray(for numberOfImages: Int) {
        for _ in 1...numberOfImages {
            guard let image = UIImage(named: "default") else {return}
            images.append(image)
        }
        reloadData()
    }
    
    func addFetchImagetoCoreData(image: UIImage) {
        guard let imageData = image.pngData() else {return}
        let fetchedImage = Photo(context: self.selectedLocation.managedObjectContext!)
        fetchedImage.photo = imageData
        self.selectedLocation.addToPhotos(fetchedImage)
        saveData()
    }
    
    func saveData() {
        do {
            try self.selectedLocation.managedObjectContext?.save()
        } catch {
            print("Issues Saving Data")
        }
    }
    
}


//MARK: - MapView Delegate

extension PhotoAlbumViewController: MKMapViewDelegate {
    
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
    
}

//MARK: - CollectionView Delegate & DataSource

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return numberofReturnedImages
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageViewCell", for: indexPath) as? ImageCollectionViewCell  else {fatalError()}
        
        DispatchQueue.main.async {
            cell.image.image =  self.images[indexPath.item]
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isDownloading {
            
            images.remove(at: indexPath.item)
            reloadData()
            numberofReturnedImages -= 1
            guard let Objects = selectedLocation.photos?.allObjects as? [Photo] else {return}
            let deleteObject = Objects[indexPath.item]
            selectedLocation.removeFromPhotos(deleteObject)
            
        } else {
            return
        }
        
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.photoCollectionView.reloadData()
        }
    }
    
    func reloadCell(at photoIndexPath: IndexPath ) {
        DispatchQueue.main.async {
            self.photoCollectionView.reloadItems(at: [photoIndexPath])
        }
    }
    
    func prepageImageArray() {
        if !images.isEmpty {
            images.removeAll()
        }
    }
}


