//
//  TideDataViewModel.swift
//  TideApp
//
//  Created by Dan Smith on 05/05/2021.
//

import Foundation

final class TideDataViewModel: ObservableObject {
  
  @Published var requestLocation = ""
  
  func getTideData() {
    NetworkManager.shared.fetchWeatherData(endpoint: WeatherEndpoint.fetchWeatherData(lat: 51.489134, lon: -0.229391)) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let weatherData):
          print(weatherData)
          self.requestLocation = weatherData.request.first?.query ?? "No request data"
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
}
