//
//  FavouritesManager.swift
//  TideApp
//
//  Created by John Sanderson on 20/05/2021.
//

import Foundation
import Combine
import CoreLocation

final class FavouritesManager {

  // MARK: - Properties -
  // MARK: Internal

  @Published var favourites: [CLLocation] = []

  // MARK: Private

  private let userDefaults: UserDefaults
  private var cancellable: AnyCancellable?

  // MARK: - Initialiser -

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }

  // MARK: - Functions -
  // MARK: Internal

  /// Tells the manager to start publishing the favourites
  func start() {
    cancellable = userDefaults
      .publisher(for: \.favouriteLocations)
      .decode(type: [Location].self, decoder: PropertyListDecoder())
      .sink(receiveCompletion: { error in
        self.favourites = []
      }, receiveValue: { locations in
        self.favourites = locations.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
      })
  }

  /// Adds a new location to the favourites
  /// - Parameter location: The new `CLLocation` to add
  func add(_ location: CLLocation) {
    encodeAndUpdate(with: location) { $0 + [$1] }
  }

  /// Removes the given location from the favourites
  /// - Parameter location: The `CLLocation` to remove
  func remove(_ location: CLLocation) {
    encodeAndUpdate(with: location) { currentFavourites, proxy in
      currentFavourites.filter { $0 != proxy }
    }
  }

  // MARK: Private

  private func encodeAndUpdate(with location: CLLocation, modifier: ([Location], Location) -> [Location]) {
    let proxy = Location(location: location)
    let currentFavourites = favourites.map(Location.init)
    let newFavourites = modifier(currentFavourites, proxy)
    let encodedValue = try? PropertyListEncoder().encode(newFavourites)
    userDefaults.favouriteLocations = encodedValue ?? Data()
  }
}

// MARK: - Helpers -

/// Proxy class used to represent a `CLLocation` in a `Codable` format.
private struct Location: Codable, Equatable {
  let latitude: Double
  let longitude: Double

  init(location: CLLocation) {
    self.latitude = location.coordinate.latitude
    self.longitude = location.coordinate.longitude
  }
}

private extension UserDefaults {

  var favouriteLocationsKey: String { "favourite_locations" }

  @objc var favouriteLocations: Data {
    get {
      value(forKey: favouriteLocationsKey) as? Data ?? Data()
    }
    set {
      set(newValue, forKey: favouriteLocationsKey)
    }
  }
}
