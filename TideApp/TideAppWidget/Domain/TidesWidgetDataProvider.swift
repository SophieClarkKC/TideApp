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

  private let networkManager: NetworkManagerType
  private var cancellable : Set<AnyCancellable> = Set()
  private let userLocator: UserLocator

  init(networkManager: NetworkManagerType, userLocator: UserLocator) {
    self.networkManager = networkManager
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

    getDataFor(location: .init(latitude: lat, longitude: long), completion: completion)
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
        self.getDataFor(location: location, completion: completion)
      }).store(in: &cancellable)
  }

  private func getDataFor(location: CLLocation, completion: @escaping (TidesEntry.WidgetData) -> ()) {
    let request = GetWeatherInformationRequest(location: location, date: Date(), networkManager: networkManager)
    request.perform()
      .sink(receiveCompletion: { result in
        guard case .failure = result else { return }
        completion(.failure(error: "Error on retrieving tide data"))
      }) { completion(.success(weatherInfo: $0)) }
      .store(in: &cancellable)
  }

}

