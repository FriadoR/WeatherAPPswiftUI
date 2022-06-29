//
//  WeatherManager.swift
//  weatherAPP
//
//  Created by Сергей Саченко on 28.06.2022.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponceBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\("a9a084758e0f00a1ebce9a64a393ad67")&units=metric") else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error getching weather data") }
        
        let decodeData = try JSONDecoder().decode(ResponceBody.self, from: data)
        
        return decodeData
    }
}

struct ResponceBody: Decodable {
    var coord: CoordinatesResponce
    var weather: [WeatherResponce]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    
    struct CoordinatesResponce: Decodable {
        var lon: Double
        var lat: Double
    }
    
    struct WeatherResponce: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }
    
    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponceBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
