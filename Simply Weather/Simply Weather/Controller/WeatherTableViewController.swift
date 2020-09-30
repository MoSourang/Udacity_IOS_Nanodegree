//
//  WeatherListTableViewController.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/10/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.

import UIKit
import MapKit
import CoreData

class WeatherTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        subscribeToNotification()
    }
    
    var citiesData = [CityCurrentWeather]()
    let group = DispatchGroup()
    var WeatherModelManager: WeatherModelManager!
    var cityInfos = [CityInfo]()
    var fetchedCityInfos = [CityInfo]()
    var sortID = Int()
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    func SaveCityInfo(for locationName:String, with locationCoordinate: CLLocationCoordinate2D) {
        let latitue = String(locationCoordinate.latitude)
        let longitude = String(locationCoordinate.longitude)
        var id = Int()
        getObjectCount { (count) in id = count }
        let cityInfo = CityInfo(context: WeatherModelManager.Viewcontext)
        cityInfo.cityLatitude = latitue
        cityInfo.cityLongitude = longitude
        cityInfo.cityName = locationName
        cityInfo.citySortId = Int32(id)
        saveData()
    }
    
    func saveData() {
        do {
            try WeatherModelManager.Viewcontext.save()
        } catch {
            print("Issues Saving Data")
        }
    }
    
    func fetchData() {
        if !cityInfos.isEmpty {cityInfos.removeAll()}
        if !citiesData.isEmpty {citiesData.removeAll()}
        let fetechRequest: NSFetchRequest = CityInfo.fetchRequest()
        let sortBy =  NSSortDescriptor(key: "citySortId", ascending: true)
        fetechRequest.sortDescriptors = [sortBy]
        do {
            cityInfos = try WeatherModelManager.Viewcontext.fetch(fetechRequest)
            fetchWeatherInfo(for: cityInfos)
            group.notify(queue: .main) {self.reloadData(); self.activityIndicator.stopAnimating(); self.activityIndicator.isHidden = true}
        } catch {
            issuesGettingWeatherData()
            print("Issues Fetching Data")
        }
    }
    
    func returnFetchedObject() ->  [CityInfo] {
        let fetechRequest: NSFetchRequest = CityInfo.fetchRequest()
        do {
            fetchedCityInfos = try WeatherModelManager.Viewcontext.fetch(fetechRequest)
        } catch {
            print("Issues Fetching Data")
        }
        return fetchedCityInfos
    }
    
    func fetchWeatherInfo(for citiesInfo:[CityInfo]) {
        for cityinfo in self.cityInfos {
            self.group.enter()
            self.activityIndicator.startAnimating()
            WeatherSerivce.getCurrentWeather(lat: cityinfo.cityLatitude!, lon: cityinfo.cityLongitude!, exclude: "minutely,hourly,daily") { result in
                switch result {
                case .success(let currentWeather):
                    self.citiesData.append(self.addCityWeatherData(with: currentWeather, and: cityinfo))
                case .failure(let error):
                    print(error)
                    self.issuesGettingWeatherData()
                }
                 self.group.leave()
            }
        }
    }
    
    func addCityWeatherData(with weatherData: CurrentWeather, and cityInfo: CityInfo) -> CityCurrentWeather {
        let cityName = cityInfo.cityName
        let cityTemperature = String(Int(weatherData.current.temp))
        let cityWeatherCondition = WeatherHelper.getWeatherIcon(weatherData.current.weather[0].id)
        let cityCurrentTime = WeatherHelper.getTime(for: weatherData.timezone)
        let lat = String(weatherData.lat)
        let lon = String(weatherData.lon)
        let currentWeather = CityCurrentWeather(temp: cityTemperature, cityName: cityName!, weatherIcon: cityWeatherCondition, currentTime: cityCurrentTime, lat: lat , lon: lon)
        return currentWeather
    }
    
    func getObjectCount (completion: @escaping(Int) -> ()) {
        let objectCount: Int
        let fetechRequest: NSFetchRequest = CityInfo.fetchRequest()
        do {
            objectCount = try WeatherModelManager.Viewcontext.count(for: fetechRequest)
            completion(objectCount)
        } catch {
            print("Issues getting object Count")
        }
    }
    
    func deleteObject(for cityName: String) {
        let objectFetchRequest: NSFetchRequest = CityInfo.fetchRequest()
        let predicate = NSPredicate(format: "cityName = %@", cityName )
        objectFetchRequest.predicate = predicate
        do {
            let objectTobeDeleted = try WeatherModelManager.Viewcontext.fetch(objectFetchRequest)
            for object in objectTobeDeleted {WeatherModelManager.Viewcontext.delete(object)}
            saveData()
        } catch {
            print("Issues Deleting Object")
        }
    }
    
    @IBAction func refreshWeatherData(_ sender: Any) {
        fetchData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func cantGetWeatherData(cityName: String) {
        let alert = UIAlertController(title: "Enable to get weather for \(cityName) ", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func issuesGettingWeatherData() {
        let alert = UIAlertController(title: "Issues getting weather, please try again ", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

//MARK: - Tableview Delegate

extension WeatherTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.weatherCell, for: indexPath) as? WeatherTableViewCell else {
            fatalError()
        }
        cell.temp.text = citiesData[indexPath.row].temp + "°"
        cell.city.text = citiesData[indexPath.row].cityName
        cell.weatherIcon.image = citiesData[indexPath.row].weatherIcon
        cell.time.text = citiesData[indexPath.row].currentTime
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WeatherTableViewCell else {return}
        guard let city = cell.city.text else {return}
        
        WeatherHelper.getCoordinateData(for: city) { (coordinate, cityName, error) in
            guard error == nil else {self.cantGetWeatherData(cityName: city); return}
            DispatchQueue.main.async {
                let weatherDetailBoard = UIStoryboard(name: K.Storyboard.WeatherDetailedStoryboard, bundle: nil)
                guard let weatDetailVc = weatherDetailBoard.instantiateViewController(identifier: K.Controllers.WeatherDetailViewController)  as? WeatherDetailViewController else {return}
                weatDetailVc.cityName = cityName
                weatDetailVc.coordinate = coordinate
                self.navigationController?.present(weatDetailVc, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let cityCell = tableView.cellForRow(at: indexPath) as? WeatherTableViewCell else {return}
            guard let cityName = cityCell.city.text else {return}
            citiesData.remove(at: indexPath.row)
            deleteObject(for: cityName)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            postNotification()
        }
    }
    
    func isWeatherDataAlreadyAdded(for lat: String,and lon: String) -> Bool {
        let citiesData = returnFetchedObject()
        var isAlreadyAdded = false
        for cityData in citiesData {
            if cityData.cityLatitude == lat && cityData.cityLongitude == lon {
                isAlreadyAdded = true
                break
            }
        }
        return isAlreadyAdded
    }
}

//MARK: - Notifcations

extension WeatherTableViewController {
    
    func postNotification() {
        NotificationCenter.default.post(name: K.Notifications.TableViewDeletedData.name, object: self, userInfo: nil)
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(weatherDataReceived(_:)),name: K.Notifications.LocationWeatherDataAdded.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(mapViewAddedSomeData(_:)), name: K.Notifications.MapWeatherDataAdded.name, object: nil)
    }
    
    func unsubscribeToNotification () {
        NotificationCenter.default.removeObserver(self, name: K.Notifications.LocationWeatherDataAdded.name, object: nil)
        NotificationCenter.default.removeObserver(self, name: K.Notifications.MapWeatherDataAdded.name, object: nil)
    }
    
    @objc func weatherDataReceived(_ notification: Notification) {
        guard let locationCoordinate = notification.userInfo?["locationCoordinate"] as? CLLocationCoordinate2D else {return}
        let lat = String(locationCoordinate.latitude)
        let lon = String(locationCoordinate.longitude)
        guard isWeatherDataAlreadyAdded(for: lat, and: lon) == false else {return}
        guard let locationName = notification.userInfo?["locationName"] as? String else {return}
        guard let weatherData = notification.userInfo?["weatherData"] as? CurrentWeather else {return}
        let temperature = String(Int(weatherData.current.temp))
        let currentTime = WeatherHelper.getTime(for: weatherData.timezone)
        let weatherCondition = WeatherHelper.getWeatherIcon(weatherData.current.weather[0].id)
        let currentWeather = CityCurrentWeather(temp: temperature, cityName: locationName, weatherIcon: weatherCondition, currentTime: currentTime, lat: lat , lon: lon)
        citiesData.append(currentWeather)
        reloadData()
        SaveCityInfo(for: locationName, with: locationCoordinate)
    }
    
    @objc func mapViewAddedSomeData(_ notification: Notification) {
        fetchData()
    }
}

