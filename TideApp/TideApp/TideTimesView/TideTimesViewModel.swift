//
//  TideTimesViewModel.swift
//  TideApp
//
//  Created by Sophie Clark on 04/05/2021.
//

import Foundation
import Combine
import CoreLocation

final class TideTimesViewModel: ObservableObject {
  
  @Published var locationName: String = ""
  @Published var subTitle: String = ""
  @Published var tideTimes: [WeatherData.Weather.Tide.TideData] = []
  @Published var tideHeight: String = ""
  @Published var error: WeatherError?
  
  private var weatherFetcher: WeatherDataFetchable
  private var cancellables = [AnyCancellable]()

  init(weatherFetcher: WeatherDataFetchable) {
    self.weatherFetcher = weatherFetcher
  }
  
  func getTideTimes() {
    // TODO: calculate current tide height
    weatherFetcher.getStandardWeatherData(lat: 51.489134, lon: -0.229391)
      .receive(on: DispatchQueue.main)
      .flatMap { CLGeocoder().getLocationName(for: $0) }
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.error = error
        case .finished:
          break
        }
      } receiveValue: { (placeName, weatherData) in
        self.subTitle = "Tide times"
        self.tideTimes = weatherData.weather.first?.tides.first?.tideData ?? []
        self.locationName = placeName
      }
      .store(in: &cancellables)

    tideHeight = "Current tide height: 0.78m"
  }
}
