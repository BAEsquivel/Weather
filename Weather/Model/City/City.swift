//
//  City.swift
//  Weather
//
//  Created by Mustafa Ozhan on 01/07/2019.
//  Copyright © 2019 Mustafa Ozhan. All rights reserved.
//

import SwiftUI
import Combine

class City: BindableObject {
    
    var willChange = PassthroughSubject<City, Never>()
    
    var name: String
    var weather: Weather? {
        didSet {
            willChange.send(self)
        }
    }
    
    init(name: String) {
        self.name = name
        self.getWeather()
    }
    
    private func getWeather() {
        guard let url = URL(string: WeatherManager.baseUrl + "45.572353,5.915807?units=ca&lang=fr") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let weatherObject = try decoder.decode(Weather.self, from: data)
                
                DispatchQueue.main.async {
                    self.weather = weatherObject
                }
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
}
