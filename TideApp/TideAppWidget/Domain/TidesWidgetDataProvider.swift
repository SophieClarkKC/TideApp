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
  func retrieveData(completion: @escaping (TidesEntry.WidgetData) -> ())
}

class TidesWidgetDataProvider: TidesWidgetDataProviderType, ObservableObject {
  private let weatherFetcher: WeatherDataFetchable
  private var cancellable : Set<AnyCancellable> = Set()

  init(weatherFetcher: WeatherDataFetchable) {
    self.weatherFetcher = weatherFetcher
  }

  func retrieveData(completion: @escaping (TidesEntry.WidgetData) -> ()) {
    weatherFetcher
      .getStandardWeatherData(lat: 41.902782, lon: 12.496366)
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
