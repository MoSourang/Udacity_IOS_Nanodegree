//
//  AddWeatherViewController.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/10/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit
import MapKit

class AddWeatherViewController: UIViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchCompleter.delegate = self
        locationSearchBar.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    var searchCompleter = MKLocalSearchCompleter()
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var locationSearchBar: UISearchBar!
    var searchResult = [String]()
    var locationName = String()
    var locationCoordinate = CLLocationCoordinate2D() 
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getWeatherData(for location: CLLocationCoordinate2D) {
        let latitude = String(location.latitude)
        let longitude = String(location.longitude)
        
        WeatherSerivce.getCurrentWeather(lat: latitude , lon: longitude, exclude: "minutely,hourly,daily") { result in
            switch result {
            case .success(let weatherData):
                DispatchQueue.main.async {
                    self.post(weatherData, name: self.locationName)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
//MARK: - Delegates

extension AddWeatherViewController: UITableViewDelegate , UITableViewDataSource, MKLocalSearchCompleterDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = searchResult[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results.map({$0.title})
        searchResult = results
        searchTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(locationSearchBar.text?.isEmpty ?? true) {
            searchCompleter.queryFragment = locationSearchBar.text!
        } else {
            searchResult.removeAll()
            searchTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        guard let selectedLocation = tableView.cellForRow(at: indexPath)?.textLabel?.text else {return}
        WeatherHelper.getCoordinateData(for: selectedLocation) { (locationCoordinate, locationName, error) in
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
            self.getWeatherData(for: locationCoordinate!)
            self.locationName = locationName!
            self.locationCoordinate = locationCoordinate!
        }
    }
}

//MARK: - Notifications

extension AddWeatherViewController {
    func post(_ weatherData: CurrentWeather, name: String) {
        NotificationCenter.default.post(name: K.Notifications.LocationWeatherDataAdded.name, object: self, userInfo: ["weatherData" : weatherData, "locationName": name, "locationCoordinate": locationCoordinate])
    }
}

