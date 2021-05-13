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
  
  enum State {
    case idle
    case loading
    case error(WeatherError)
    case success(WeatherInfo)
  }
  
  struct WeatherInfo {
    var locationName: String
    var subTitle: String
    var tideTimes: [TideData]
    var tideHeight: String?
    var waterTemperature: String?
    var tideStatus: String?
  }

  // MARK: - Properties -
  // MARK: Published
  @Published var state: State = .idle

  private var weatherFetcher: WeatherDataFetchable
  private var cancellables = [AnyCancellable]()

  // MARK: - Initialisation -
  init(weatherFetcher: WeatherDataFetchable) {
    self.weatherFetcher = weatherFetcher
    super.init()
  }

  func getTideTimes(for date: Date = Date(), at newLocation: CLLocation) {
    let newLatitude = Double(newLocation.coordinate.latitude)
    let newLongitude = Double(newLocation.coordinate.longitude)
    state = .loading
    weatherFetcher.getStandardWeatherData(lat: newLatitude, lon: newLongitude)
      .receive(on: DispatchQueue.main)
      .flatMap { CLGeocoder().getLocationName(for: $0) }
      .sink(receiveCompletion: { completion in
        guard case let .failure(error) = completion else {
          return
        }
        self.state = .error(error)
      }, receiveValue: { placeName, weatherData in
        self.state = .success(self.map(placeName: placeName, weatherData: weatherData, date: date))
      })
      .store(in: &cancellables)
  }
  
  private func map(placeName: String, weatherData: WeatherData, date: Date) -> WeatherInfo {
    let tideData = weatherData.weather.first?.tides.first?.tideData ?? []
    let subTitle = "Tide times"
    let tideHeight: String? = weatherData.calculateCurrentTideHeight(with: date).flatMap({ "Current tide height: ~\(String(format: "%.2f", $0))m" })
    let waterTemperature: String? = weatherData.currentWaterTemperature(with: date).flatMap({ "Current water temperature: ~\(String(format: "%.0f", $0))c" })
    let tideStatus = weatherData.tideStatusText(with: date, abbreviated: false)
    return WeatherInfo(locationName: placeName, subTitle: subTitle, tideTimes: tideData, tideHeight: tideHeight, waterTemperature: waterTemperature, tideStatus: tideStatus)
  }
}
