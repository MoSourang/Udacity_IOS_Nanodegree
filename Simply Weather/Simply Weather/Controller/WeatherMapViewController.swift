//
//  ViewController.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/10/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class WeatherMapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var WeatherModelManager: WeatherModelManager!
    var cityInfos = [CityInfo]()
    
    @IBOutlet var mapVIew: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotification()
        mapView.delegate = self 
        fetchData()
        setupGesture()
    }
    
    func fetchData() {
        let fetechRequest: NSFetchRequest = CityInfo.fetchRequest()
        do {
            cityInfos = try WeatherModelManager.Viewcontext.fetch(fetechRequest)
            fetchWeatherInfo(for: cityInfos)
        } catch {
            print(error)
            issuesGettingWeatherData()
        }
    }
    
    
    func fetchWeatherInfo(for citiesInfo:[CityInfo]) {
        for cityinfo in  cityInfos {
            WeatherSerivce.getCurrentWeather(lat: cityinfo.cityLatitude!, lon: cityinfo.cityLongitude!, exclude: "minutely,hourly,daily") { result in
                switch result {
                case .success(let currentWeather):
                    self.addWeatherInfoToMap(for: currentWeather, cityName: cityinfo.cityName!)
                case .failure(let error):
                    print(error)
                    self.issuesGettingWeatherData()
                }
            }
        }
    }
    
    func addWeatherInfoToMap(for currentWeather: CurrentWeather, cityName: String) {
        DispatchQueue.main.async {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: currentWeather.lat)!, longitude: currentWeather.lon)
            let cityWeatherMap = CityWeatherMap(name: cityName, url: String(Int(currentWeather.current.temp)) + "°", coordinate: coordinate)
            self.mapView.addAnnotation(cityWeatherMap)
        }
    }
    
    
    @objc func handlePinDrop(gestureRecognizer: UILongPressGestureRecognizer) {
        let Pinlocation = gestureRecognizer.location(in: mapView)
        let Pincoordinate = mapView.convert(Pinlocation, toCoordinateFrom: mapView)
        getWeatherData(for: Pincoordinate)
    }
    
    func getWeatherData(for location: CLLocationCoordinate2D) {
        let latitude = String(location.latitude)
        let longitude = String(location.longitude)
        
        WeatherSerivce.getCurrentWeather(lat: latitude , lon: longitude, exclude: "minutely,hourly,daily") { result in
            switch result {
            case .success(let weatherData):
                self.prepareWeatherData(for: weatherData)
            case .failure(let error):
                print(error)
                self.issuesGettingWeatherData()
            }
        }
    }
    
    func prepareWeatherData(for weatherData: CurrentWeather) {
        let cityLocation = CLLocation(latitude: CLLocationDegrees(weatherData.lat), longitude: CLLocationDegrees(weatherData.lon))
        getCityName(for: cityLocation) { (cityName) in
            self.addWeatherInfoToMap(for: weatherData, cityName: cityName)
            let cityInfo = CityInfo(context: self.WeatherModelManager.Viewcontext)
            var id  = Int()
            self.getObjectCount { (count) in id = count}
            cityInfo.cityName = cityName
            cityInfo.cityLatitude = String(weatherData.lat)
            cityInfo.cityLongitude = String(weatherData.lon)
            cityInfo.citySortId = Int32(id)
            self.saveData()
            self.postNotification(for: cityName)
        }
    }
    
    func getCityName(for location: CLLocation, completion: @escaping(String) -> ()) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {return }
            placemarks?.forEach({ (placemark) in
                guard  let city = placemark.locality else {return}
                completion(city)
            })
        }
    }
    
    func saveData() {
        do {
            try WeatherModelManager.Viewcontext.save()
        } catch {
            print("Issues Saving Data")
        }
    }
    
    func getObjectCount (completion: @escaping(Int) -> ()) {
        let objectCount: Int
        let fetechRequest: NSFetchRequest = CityInfo.fetchRequest()
        do {
            objectCount = try WeatherModelManager.Viewcontext.count(for: fetechRequest)
            completion(objectCount)
        } catch {
            print("Issues Fetching Data")
        }
    }
    
    @IBAction func refreshWeatherData(_ sender: Any) {
        fetchData()
    }
}

//MARK: - MKMapViewDelegate


extension WeatherMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is CityWeatherMap else {return nil}
        let indentifer = "CityWeatherMap"
        
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
        guard let city = view.annotation?.title else {return}
        
        WeatherHelper.getCoordinateData(for: city!) { (coordinate, cityName, error) in
            guard error == nil else {self.cantGetWeatherData(cityName: city!); return}
            DispatchQueue.main.async {
                let weatherDetailBoard = UIStoryboard(name: K.Storyboard.WeatherDetailedStoryboard, bundle: nil)
                guard let weatDetailVc = weatherDetailBoard.instantiateViewController(identifier: K.Controllers.WeatherDetailViewController)  as? WeatherDetailViewController else {return}
                weatDetailVc.cityName = cityName
                weatDetailVc.coordinate = coordinate
                self.navigationController?.present(weatDetailVc, animated: true, completion: nil)
            }
        }
    }
    
    func cantGetWeatherData(cityName: String) {
        let alert = UIAlertController(title: "Enable to get weather for \(cityName) ", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func issuesGettingWeatherData() {
        let alert = UIAlertController(title: "Issues getting weather please try again ", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

//MARK: - Notification & Setups

extension WeatherMapViewController {
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(TableViewChangedData(_:)), name: K.Notifications.LocationWeatherDataAdded.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TableViewChangedData(_:)), name: K.Notifications.TableViewDeletedData.name, object: nil)
    }
    
    func unsubscribeToNotification() {
        NotificationCenter.default.removeObserver(self, name: K.Notifications.LocationWeatherDataAdded.name, object: nil)
        NotificationCenter.default.removeObserver(self, name: K.Notifications.TableViewDeletedData.name, object: nil)
    }
    
    
    func postNotification(for cityName: String) {
        NotificationCenter.default.post(name: K.Notifications.MapWeatherDataAdded.name, object: self, userInfo: ["locationName" : cityName])
    }
    
    @objc func TableViewChangedData(_ notification: Notification) {
        mapVIew.removeAnnotations(mapVIew.annotations)
        fetchData()
    }
    
    func setupGesture() {
        let mapPingestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePinDrop(gestureRecognizer:)))
        mapPingestureRecognizer.delegate = self
        mapView.addGestureRecognizer(mapPingestureRecognizer)
    }
}
