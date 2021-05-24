//
//  FavouritesManager.swift
//  TideApp
//
//  Created by Marco Guerrieri on 20/05/2021.
//

import Foundation
import Combine
import CoreLocation

protocol FavouritesManagerType: AnyObject {
  func fetch()
  func saveToFavourite(_ location: FavouriteLocation)
  func removeFromFavouriteLocation(named: String)
  func clearFavourites()
}

final class FavouritesManager: FavouritesManagerType {
  @Published var favourites: [FavouriteLocation] = []

  // MARK: Private
  private static let favsLocationsKey: String = "FAVOURITES_LOCATIONS_STORAGE_KEY"
  private let storage: UserDefaults

  // MARK: - Initialiser -

  init(with storage: UserDefaults = UserDefaults.shared) {
    self.storage = storage
  }

  // MARK: - Functions -
  // MARK: Internal

  func fetch() {
    favourites = Array(retrieveLocationsDictionary().values)
  }

  func saveToFavourite(_ location: FavouriteLocation) {
    var favsDictionary = retrieveLocationsDictionary()
    favsDictionary[location.name] = location
    updateLocationsDictionary(favsDictionary)
  }

  func removeFromFavouriteLocation(named: String) {
    var favsDictionary = retrieveLocationsDictionary()
    favsDictionary[named] = nil
    updateLocationsDictionary(favsDictionary)
  }

  func clearFavourites() {
    storage.setValue(nil, forKey: FavouritesManager.favsLocationsKey)
  }

  private func updateLocationsDictionary(_ dictionary: [String: FavouriteLocation]) {
    let data = try? PropertyListEncoder().encode(dictionary)
    storage.setValue(data, forKey: FavouritesManager.favsLocationsKey)
    fetch()
  }

  private func retrieveLocationsDictionary() -> [String: FavouriteLocation] {
    guard let data = storage.data(forKey: FavouritesManager.favsLocationsKey) else { return [:] }
    return (try? PropertyListDecoder().decode([String: FavouriteLocation].self, from: data)) ?? [:]
  }
}

struct FavouriteLocation: Codable {
  let name: String
  let latitude: Double
  let longitude: Double

  init(name: String, location: CLLocation) {
    self.name = name
    self.latitude = location.coordinate.latitude
    self.longitude = location.coordinate.longitude
  }
}
