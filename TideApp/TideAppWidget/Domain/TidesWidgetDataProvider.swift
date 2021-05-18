//
//  TidesWidgetDataProvider.swift
//  TideApp
//
//  Created by Marco Guerrieri on 10/05/2021.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation

protocol TidesWidgetDataProviderType {
  func retrieveData(for config: WidgetConfigurationIntent, completion: @escaping (TidesEntry.WidgetData) -> ())
}

class TidesWidgetDataProvider: NSObject, TidesWidgetDataProviderType, ObservableObject {
  private let weatherFetcher: WeatherDataFetchable
  private var cancellable : Set<AnyCancellable> = Set()
  private let userLocator: UserLocator

  init(weatherFetcher: WeatherDataFetchable, userLocator: UserLocator) {
    self.weatherFetcher = weatherFetcher
    self.userLocator = userLocator
    super.init()
    self.userLocator.start()
  }

  func retrieveData(for config: WidgetConfigurationIntent, completion: @escaping (TidesEntry.WidgetData) -> ()) {
    let latitude: Double?
    let longitude: Double?

    switch config.locationConfig {
    case .favourite where config.favourite?.latitude != nil && config.favourite?.longitude != nil:
      latitude = config.favourite?.latitude?.doubleValue
      longitude = config.favourite?.longitude?.doubleValue

    case .search where config.search?.location?.coordinate != nil:
      latitude = config.search?.location?.coordinate.latitude
      longitude = config.search?.location?.coordinate.longitude

    case .current:
      return getDataUsingCurrentUserLocation(completion: completion)

    default:
      return completion(.failure(error: "Seems that the current widget configuration is wrong. Please check it."))
    }

    guard let lat = latitude, let long = longitude else {
      return completion(.failure(error: "Location to show not found. Please check the widget configuration."))
    }

    getDataFor(latitude: lat, longitude: long, completion: completion)
  }

  private func getDataUsingCurrentUserLocation(completion: @escaping (TidesEntry.WidgetData) -> ()) {
    guard userLocator.isAuthorizedForWidgetUpdates() else {
      return completion(.failure(error: "Location to show not found. Please check the widget configuration."))
    }
    userLocator.$location
      .filter { $0.coordinate.latitude != 0 || $0.coordinate.longitude != 0  }
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { result in
        guard case .failure = result else { return }
        completion(.failure(error: "Error on retrieving your current location"))
      }, receiveValue: { location in
        self.getDataFor(latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude,
                        completion: completion)
      }).store(in: &cancellable)
  }

  private func getDataFor(latitude: Double, longitude: Double, completion: @escaping (TidesEntry.WidgetData) -> ()) {
    weatherFetcher
      .getStandardWeatherData(lat: latitude, lon: longitude)
      .flatMap { CLGeocoder().getLocationName(for: $0) }
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { result in
        guard case .failure = result else { return }
        completion(.failure(error: "Error on retrieving tide data"))
      }) { (place, widgetData) in
        completion(.success(place: place,
                            weatherData: widgetData))
      }
      .store(in: &cancellable)
  }

}

