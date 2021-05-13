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

final class TidesWidgetDataProvider: TidesWidgetDataProviderType, ObservableObject {
  private let weatherFetcher: WeatherDataFetchable
  private var cancellable : Set<AnyCancellable> = Set()

  init(weatherFetcher: WeatherDataFetchable) {
    self.weatherFetcher = weatherFetcher
  }

  func retrieveData(completion: @escaping (TidesEntry.WidgetData) -> ()) {
    weatherFetcher
      .getStandardWeatherData(lat: 50.805832, lon: -1.087222)
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
