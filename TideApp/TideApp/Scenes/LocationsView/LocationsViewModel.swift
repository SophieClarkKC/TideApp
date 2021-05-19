//
//  LocationsViewModel.swift
//  TideApp
//
//  Created by John Sanderson on 14/05/2021.
//

import Combine
import CoreLocation

final class LocationsViewModel: ObservableObject {

  enum State {
    case idle
    case loading
    case error(Error)
    case success([WeatherInfo])
  }

  // MARK: - Properties -
  // MARK: Internal

  @Published var state: State = .idle

  // MARK: Private

  private let userLocator: UserLocator
  private let networkManager: NetworkManagerType
  private var cancellables: [AnyCancellable] = []


  // MARK: - Initialiser -

  init(userLocator: UserLocator = UserLocator(), networkManager: NetworkManagerType = NetworkManager()) {
    self.userLocator = userLocator
    self.networkManager = networkManager
  }

  // MARK: - Functions -
  // MARK: Internal

  func start() {
    userLocator.start()
    userLocator.$location
      .sink { self.getTideTimes(at: $0) }
      .store(in: &cancellables)
  }

  func refresh() {
    getTideTimes(at: userLocator.location)
  }

  // MARK: Private

  private func getTideTimes(for date: Date = Date(), at newLocation: CLLocation) {
    state = .loading
    let request = GetWeatherInformationRequest(location: newLocation, date: date, networkManager: networkManager)
    request.perform()
      .sink(receiveCompletion: { completion in
        guard case let .failure(error) = completion else {
          return
        }
        self.state = .error(error)
      }, receiveValue: { self.state = .success([$0]) })
      .store(in: &cancellables)
  }
}
