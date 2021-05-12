//
//  TideTimesViewModel.swift
//  TideApp
//
//  Created by Sophie Clark on 04/05/2021.
//

import Foundation
import Combine
import CoreLocation

final class TideTimesViewModel: NSObject, ObservableObject {
  typealias TideData = WeatherData.Weather.Tide.TideData
  typealias Hourly = WeatherData.Weather.Hourly

  // MARK: - Properties -
  // MARK: Published
  @Published var error: WeatherError?
  @Published var locationName: String = ""
  @Published var subTitle: String = ""
  @Published var tideTimes: [TideData] = []
  @Published var tideHeight: String?
  @Published var tideStatus: String?
  @Published var waterTemperature: String?
  
  private var weatherFetcher: WeatherDataFetchable
  private var cancellables = [AnyCancellable]()

  // MARK: - Initialisation -
  init(weatherFetcher: WeatherDataFetchable) {
    self.weatherFetcher = weatherFetcher
    super.init()
  }
  
  func getTideTimes(for date: Date = Date(), lat: Double, lon: Double) {
    weatherFetcher.getStandardWeatherData(lat: lat, lon: lon)
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
        let tideData = weatherData.weather.first?.tides.first?.tideData ?? []
        self.subTitle = "Tide times"
        self.tideTimes = tideData
        self.locationName = placeName
        if let currentTideHeight = weatherData.calculateCurrentTideHeight(with: date) {
          self.tideHeight = "Current tide height: ~\(String(format: "%.2f", currentTideHeight))m"
        } else {
          self.tideHeight = nil
        }
        if let currentTemperature = weatherData.currentWaterTemperature(with: date) {
          self.waterTemperature = "Current water temperature: ~\(String(format: "%.0f", currentTemperature))c"
        } else {
          self.waterTemperature = nil
        }
        self.tideStatus = weatherData.calculateTideStatus(with: date)
      }
      .store(in: &cancellables)
  }
}
