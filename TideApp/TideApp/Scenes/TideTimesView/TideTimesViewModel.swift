//
//  TideTimesViewModel.swift
//  TideApp
//
//  Created by John Sanderson on 19/05/2021.
//

import Foundation
import Combine
import CoreLocation

enum TideTimesState {
  case idle
  case loading
  case error(Error)
  case success(WeatherInfo)
}

protocol TideTimesViewModelType: ObservableObject {

  var state: TideTimesState { get }

  func getTideTimes()
}

// MARK: - Network ViewModel -

/// A `TideTimesViewModelType` that fetches the `WeatherInfo` from the network using the provided location
final class TideTimesNetworkViewModel: TideTimesViewModelType {

  // MARK: - Properties -
  // MARK: Internal

  @Published var state: TideTimesState = .idle

  // MARK: Private

  private let location: CLLocation?
  private let networkManager: NetworkManagerType
  private var cancellable: AnyCancellable?

  // MARK: - Initialiser -

  init(location: CLLocation?, networkManager: NetworkManagerType = NetworkManager()) {
    self.location = location
    self.networkManager = networkManager
  }

  // MARK: - Functions -
  // MARK: Internal

  func getTideTimes() {
    state = .loading
    guard let location = location else {
      state = .error(WeatherError.parsing(description: "Invalid location"))
      return
    }
    let request = GetWeatherInformationRequest(coordinate: location.coordinate, date: Date(), networkManager: networkManager)
    cancellable = request.perform()
      .sink(receiveCompletion: { completion in
        guard case let .failure(error) = completion else { return }
        self.state = .error(error)
      }, receiveValue: {
        self.state = .success($0)
      })
  }
}

// MARK: - Local ViewModel -

/// A `TideTimesViewModelType` that is initialised directly with a `WeatherInfo` object
final class TideTimesLocalViewModel: TideTimesViewModelType {

  // MARK: - Properties -
  // MARK: Internal

  @Published var state: TideTimesState = .idle

  // MARK: Private

  private let weatherInfo: WeatherInfo

  // MARK: - Initialiser -

  init(weatherInfo: WeatherInfo) {
    self.weatherInfo = weatherInfo
  }

  // MARK: - Functions -
  // MARK: Internal

  func getTideTimes() {
    state = .success(weatherInfo)
  }
}
