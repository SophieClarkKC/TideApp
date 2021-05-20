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
  }

  func retrieveData(for config: WidgetConfigurationIntent, completion: @escaping (TidesEntry.WidgetData) -> ()) {
    let latitude: Double?
    let longitude: Double?

    switch config.locationConfig {
    case .some(let location) where location.isCurrentPosition?.boolValue == true:
      // Use GPS for Location
      return getDataUsingCurrentUserLocation(completion: completion)

    case .some(let location) where location.isCurrentPosition?.boolValue == false:
      // Use coordinates for location
      latitude = location.latitude?.doubleValue
      longitude = location.longitude?.doubleValue

    default:
      return completion(.failure(error: "Seems that the current widget configuration is wrong. Please check it."))
    }

    guard let lat = latitude, let long = longitude else {
      return completion(.failure(error: "Location to show not found. Please check the widget configuration."))
    }

    getDataFor(location: .init(latitude: lat, longitude: long), completion: completion)
  }

  private func getDataUsingCurrentUserLocation(completion: @escaping (TidesEntry.WidgetData) -> ()) {
    userLocator.$locationResult
      .receive(on: DispatchQueue.main)
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink(receiveValue: { result in
        switch result {
        case .awaiting:
          break // loading is authomated in widget

        case .unauthorized:
          completion(.failure(error: "Widget cannot access your current location.\nEdit the widget configuration to use a fixed location or authorize the app in Configuration -> Privacy -> Location services."))

        case .success(let location):
          self.getDataFor(location: location, completion: completion)
        }
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

