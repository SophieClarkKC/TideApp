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
  private let widgetLocationManager: TidesWidgetLocationManager
  private var cancellable : Set<AnyCancellable> = Set()

  init(weatherFetcher: WeatherDataFetchable, widgetLocationManager: TidesWidgetLocationManager) {
    self.weatherFetcher = weatherFetcher
    self.widgetLocationManager = widgetLocationManager
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
    guard widgetLocationManager.isAuthorized() else {
      return completion(.failure(error: "The widget is not authorized to use your location. Please check the TideApp authorization for the location services in the device settings."))
    }
    widgetLocationManager.retrieveLocation { location in
      guard let coordinate = location?.coordinate else {
        return completion(.failure(error: "Current location not found"))
      }
      self.getDataFor(latitude: coordinate.latitude,
                      longitude: coordinate.longitude,
                      completion: completion)
    }
  }

  private func getDataFor(latitude: Double, longitude: Double, completion: @escaping (TidesEntry.WidgetData) -> ()) {
    weatherFetcher
      .getStandardWeatherData(lat: latitude, lon: longitude)
      .flatMap { CLGeocoder().getLocationName(for: $0) }
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

