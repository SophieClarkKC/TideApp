//
//  TidesWidgetDataProvider.swift
//  TideApp
//
//  Created by Marco Guerrieri on 10/05/2021.
//

import Foundation
import Combine
import CoreLocation

protocol TidesWidgetDataProviderType {
  func retrieveData(for config: WidgetConfigurationIntent, completion: @escaping (TidesEntry.WidgetData) -> ())
}

final class TidesWidgetDataProvider: TidesWidgetDataProviderType, ObservableObject {
  private let weatherFetcher: WeatherDataFetchable
  private var cancellable : Set<AnyCancellable> = Set()

  init(weatherFetcher: WeatherDataFetchable) {
    self.weatherFetcher = weatherFetcher
  }

  func retrieveData(for config: WidgetConfigurationIntent, completion: @escaping (TidesEntry.WidgetData) -> ()) {
    let latitude: Double?
    let longitude: Double?

    switch config.locationConfig {
    case .favourite where config.favourite?.latitude != nil && config.favourite?.longitude != nil:
      latitude = config.favourite?.latitude?.doubleValue
      longitude = config.favourite?.latitude?.doubleValue

    case .search where config.search?.location?.coordinate != nil:
      latitude = config.search?.location?.coordinate.latitude
      longitude = config.search?.location?.coordinate.longitude

    case .current:
      // TODO: Set up CoreLocation location search
      latitude = 50.805832
      longitude = -1.087222

    default:
      latitude = nil
      longitude = nil
    }
    guard let lat = latitude, let long = longitude else {
      completion(.failure(error: "Location to show not found. Please check the widget configuration."))
      return
    }
    getDataFor(latitude: lat, longitude: long, completion: completion)
  }

  private func getDataFor(latitude: Double, longitude: Double, completion: @escaping (TidesEntry.WidgetData) -> () ) {
    weatherFetcher
      .getStandardWeatherData(lat: latitude, lon: longitude)
      .flatMap { CLGeocoder().getLocationName(for: $0) }
      .eraseToAnyPublisher()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { result in
        guard case .failure(let error) = result else { return }
        completion(.failure(error: error.localizedDescription))
      }) { (place, widgetData) in
        completion(.success(place: place,
                            weatherData: widgetData))
      }
      .store(in: &cancellable)
  }

}
