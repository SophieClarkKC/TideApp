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
  typealias TidesWidgetData = TidesEntry.WidgetData
  func retrieveData(completion: @escaping (TidesWidgetData) -> ())
}

class TidesWidgetDataProvider: TidesWidgetDataProviderType {
  private let weatherFetcher: WeatherDataFetchable
  private var cancellable = [AnyCancellable]()

  init(weatherFetcher: WeatherDataFetchable) {
    self.weatherFetcher = weatherFetcher
  }

  func retrieveData(completion: @escaping (TidesWidgetData) -> ()) {
    weatherFetcher
      .getStandardWeatherData(lat: 41.902782, lon: 12.496366)
      .receive(on: DispatchQueue.main)
      .flatMap { CLGeocoder().getLocationName(for: $0) }
      .sink { result in
        guard case .failure(let error) = result else { return }
        completion(.failure(error: error.localizedDescription))
      } receiveValue: { (place, widgetData) in
        completion(.success(place: place,
                            weatherData: widgetData))
      }
      .store(in: &cancellable)
  }

}
