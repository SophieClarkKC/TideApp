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
    case error(String)
    case success([WeatherInfo])
  }

  // MARK: - Properties -
  // MARK: Internal

  @Published var state: State = .idle

  // MARK: Private

  private let userLocator: UserLocator
  private let favouritesManager: FavouritesManager
  private let networkManager: NetworkManagerType
  private var cancellables: [AnyCancellable] = []

  private var weatherInfo: [WeatherInfo] = [] {
    didSet {
      state = .success(weatherInfo)
    }
  }

  // MARK: - Initialiser -

  init(userLocator: UserLocator = UserLocator(forWidget: false),
       favouritesManager: FavouritesManager = FavouritesManager(),
       networkManager: NetworkManagerType = NetworkManager()) {
    self.userLocator = userLocator
    self.favouritesManager = favouritesManager
    self.networkManager = networkManager
  }

  // MARK: - Functions -
  // MARK: Internal

  func start() {
    userLocator.$locationResult
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink(receiveValue: { result in
        switch result {
        case .awaiting:
          self.state = .loading

        case .unauthorized:
          self.state = .error("TideApp cannot access your current location.\nSearch for a specific location or authorize the app in Configuration -> Privacy -> Location services.")

        case .success(let location):
          self.getTideTimes(at: location)
        }
      })
      .store(in: &cancellables)

    favouritesManager.start()
    favouritesManager.$favourites
      .sink { locations in
        locations.forEach { self.getTideTimes(at: $0) }
      }
      .store(in: &cancellables)
  }

  func refresh() {
    guard case let .success(location) = userLocator.locationResult else {
      return self.state = .error("Current location not found")
    }
    getTideTimes(at: location)
  }

  // MARK: Private

  private func getTideTimes(for date: Date = Date(), at newLocation: CLLocation) {
    state = .loading
    let request = GetWeatherInformationRequest(location: newLocation, date: date, networkManager: networkManager)
    request.perform()
      .sink(receiveCompletion: { completion in
        guard case let .failure(error) = completion else { return }
        self.state = .error(error.localizedDescription)
      }, receiveValue: { 
        self.weatherInfo.append($0)
      })
      .store(in: &cancellables)
  }
}
