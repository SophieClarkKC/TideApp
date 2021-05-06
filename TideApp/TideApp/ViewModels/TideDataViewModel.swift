//
//  TideDataViewModel.swift
//  TideApp
//
//  Created by Dan Smith on 05/05/2021.
//

import Foundation
import Combine

final class TideDataViewModel: ObservableObject {

  @Published var requestLocation = ""

  private let weatherDataFetcher: WeatherDataFetchable
  private var cancellables = Set<AnyCancellable>()

  init(weatherDataFetcher: WeatherDataFetchable = WeatherDataFetcher()) {
    self.weatherDataFetcher = weatherDataFetcher
  }

  func getTideData() {
    weatherDataFetcher.getStandardWeatherData(lat: 51.489134, lon: -0.229391)
      .receive(on: DispatchQueue.main).sink { [weak self] (value) in
        guard let self = self else { return }
        switch value {
        case .failure(let error):
          print(error)
        case .finished:
          break
        }
      } receiveValue: { [weak self] weatherData in
        guard let self = self else { return }
        self.requestLocation = weatherData.request.first?.query ?? "No location received"
      }
      .store(in: &cancellables)
  }
}
