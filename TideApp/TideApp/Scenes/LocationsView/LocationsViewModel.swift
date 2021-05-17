//
//  LocationsViewModel.swift
//  TideApp
//
//  Created by John Sanderson on 14/05/2021.
//

import Combine
import CoreLocation

final class LocationsViewModel: ObservableObject {

  enum State {
    case idle
    case loading
    case error(WeatherError)
    case success([WeatherInfo])
  }

  // MARK: - Properties -
  // MARK: Internal

  @Published var state: State = .idle

  // MARK: Private

  private let userLocator: UserLocator
  private let weatherFetcher: WeatherDataFetchable
  private var cancellables: [AnyCancellable] = []

  // MARK: - Initialiser -

  init(userLocator: UserLocator = UserLocator(), weatherFetcher: WeatherDataFetchable = WeatherDataFetcher()) {
    self.userLocator = userLocator
    self.weatherFetcher = weatherFetcher
  }

  // MARK: - Functions -
  // MARK: Internal

  func start() {
    userLocator.start()
    userLocator.$location
      .sink { self.getTideTimes(at: $0) }
      .store(in: &cancellables)
  }

  func refresh() {
    getTideTimes(at: userLocator.location)
  }

  // MARK: Private

  private func getTideTimes(for date: Date = Date(), at newLocation: CLLocation) {
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
        let info = self.map(placeName: placeName, weatherData: weatherData, date: date)
        self.state = .success([info])
      })
      .store(in: &cancellables)
  }

  private func map(placeName: String, weatherData: WeatherData, date: Date) -> WeatherInfo {
    let tideData = weatherData.weather.first?.tides.first?.tideData ?? []
    let subTitle = "Tide times"
    let tideHeight: String? = weatherData.calculateCurrentTideHeight(with: date).flatMap({ "Current tide height: ~\(String(format: "%.2f", $0))m" })
    let waterTemperature: String? = weatherData.currentWaterTemperature(with: date).flatMap({ "Current water temperature: ~\(String(format: "%.0f", $0))c" })
    return WeatherInfo(locationName: placeName, subTitle: subTitle, tideTimes: tideData, tideHeight: tideHeight, waterTemperature: waterTemperature)
  }
}
