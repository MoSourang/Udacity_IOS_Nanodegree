//
//  WeatherDetailViewController.swift
//  Simply Weather
//
//  Created by Mouhamed Sourang on 9/10/20.
//  Copyright © 2020 Mouhamed Sourang. All rights reserved.
//

import UIKit
import MapKit

class WeatherDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeatherData()
    }
    
    var cityName: String!
    var coordinate: CLLocationCoordinate2D!
    
     // **outlets //
    @IBOutlet var currentWeatherCondition: UIImageView!
    @IBOutlet var currentTemperature: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    
    @IBOutlet var dayOne: UILabel!
    @IBOutlet var dayOneCondition: UIImageView!
    @IBOutlet var dayOneHigh: UILabel!
    @IBOutlet var dayOneLow: UILabel!
    
    @IBOutlet var dayTwo: UILabel!
    @IBOutlet var dayTwoCondition: UIImageView!
    @IBOutlet var dayTwoHigh: UILabel!
    @IBOutlet var dayTwoLow: UILabel!
    
    @IBOutlet var dayThree: UILabel!
    @IBOutlet var dayThreeCondition: UIImageView!
    @IBOutlet var dayThreeHigh: UILabel!
    @IBOutlet var dayThreeLow: UILabel!
    
    @IBOutlet var dayFour: UILabel!
    @IBOutlet var dayFourCondition: UIImageView!
    @IBOutlet var dayFourHigh: UILabel!
    @IBOutlet var dayFourLow: UILabel!
    
    @IBOutlet var dayFive: UILabel!
    @IBOutlet var dayFiveCondition: UIImageView!
    @IBOutlet var dayFiveHigh: UILabel!
    @IBOutlet var dayFiveLow: UILabel!
    
    func fetchWeatherData() {
        let latitude = String(coordinate.latitude)
        let longitude = String(coordinate.longitude)
        WeatherSerivce.getWeeklyWeather(lat: latitude, lon: longitude, exclude: "minutely,hourly") { (result) in
            switch result {
            case .success(let weatherData):
                DispatchQueue.main.async {
                    self.setupViewController(with: weatherData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupViewController(with weatherData: WeeklyWeather) {
        //Current Weather
        cityNameLabel.text = cityName
        currentTemperature.text = (String(Int(weatherData.current.temp))) + "°"
        currentWeatherCondition.image =  WeatherHelper.getWeatherIcon(weatherData.current.weather[0].id)
        
        let weeklyData = weatherData.daily
        
        let dayOneData = weeklyData[1]
        let dayTwoData = weeklyData[2]
        let dayThreeData = weeklyData[3]
        let dayFourData  = weeklyData[4]
        let dayFiveData = weeklyData[5]
        
        dayOne.text = WeatherHelper.convertDate(for:  dayOneData.dt)
        dayOneCondition.image? = WeatherHelper.getWeatherIcon(dayOneData.weather[0].id)
        dayOneHigh.text = String(Int(dayOneData.temp.max)) + "°"
        dayOneLow.text = String(Int(dayOneData.temp.min))  + "°"
        
        dayTwo.text = WeatherHelper.convertDate(for:  dayTwoData.dt)
        dayTwoCondition.image? = WeatherHelper.getWeatherIcon(dayTwoData.weather[0].id)
        dayTwoHigh.text = String(Int(dayTwoData.temp.max)) + "°"
        dayTwoLow.text = String(Int(dayTwoData.temp.min)) + "°"
        
        dayThree.text = WeatherHelper.convertDate(for:  dayThreeData.dt)
        dayThreeCondition.image? = WeatherHelper.getWeatherIcon(dayThreeData.weather[0].id)
        dayThreeHigh.text = String(Int(dayThreeData.temp.max)) + "°"
        dayThreeLow.text = String(Int(dayThreeData.temp.min))  + "°"
        
        dayFour.text = WeatherHelper.convertDate(for:  dayFourData.dt)
        dayFourCondition.image? = WeatherHelper.getWeatherIcon(dayFourData.weather[0].id)
        dayFourHigh.text = String(Int(dayFourData.temp.max))  + "°"
        dayFourLow.text = String(Int(dayFourData.temp.min))  + "°"
               
        dayFive.text = WeatherHelper.convertDate(for:  dayFiveData.dt)
        dayFiveCondition.image? = WeatherHelper.getWeatherIcon(dayFiveData.weather[0].id)
        dayFiveHigh.text = String(Int(dayFiveData.temp.max))  + "°"
        dayFiveLow.text = String(Int(dayFiveData.temp.min)) + "°"
    }
}
