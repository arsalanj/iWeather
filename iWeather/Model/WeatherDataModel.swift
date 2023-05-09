//
//  WeatherDataModel.swift
//  iWeather
//
//  Created by Muhammad Mehdi on 08/05/2023.
//

import Foundation


struct WeatherData: Codable {
//    let hourly: HourlyData
    let daily: DailyData
}



struct DailyData: Codable {
    let time: [String]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
    let precipitation_probability_max: [Int]

}


struct Forecast {
    let date: String
//    let temperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let precipitationProbability: Int
}

