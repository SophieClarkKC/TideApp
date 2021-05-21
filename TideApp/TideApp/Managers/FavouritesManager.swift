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
  func saveToFavourite(_ location: TALocation)
  func removeFromFavourite(_ location: TALocation)
  func clearFavourites()
}

final class FavouritesManager: FavouritesManagerType {
  @Published var favourites: [TALocation] = []

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

  func saveToFavourite(_ location: TALocation) {
    var favsDictionary = retrieveLocationsDictionary()
    favsDictionary[location.name] = location
    updateLocationsDictionary(favsDictionary)
  }

  func removeFromFavourite(_ location: TALocation) {
    var favsDictionary = retrieveLocationsDictionary()
    favsDictionary[location.name] = nil
    updateLocationsDictionary(favsDictionary)
  }

  func clearFavourites() {
    storage.setValue(nil, forKey: FavouritesManager.favsLocationsKey)
  }

  private func updateLocationsDictionary(_ dictionary: [String: TALocation]) {
    let data = try? PropertyListEncoder().encode(dictionary)
    storage.setValue(data, forKey: FavouritesManager.favsLocationsKey)
    fetch()
  }

  private func retrieveLocationsDictionary() -> [String: TALocation] {
    guard let data = storage.data(forKey: FavouritesManager.favsLocationsKey) else { return [:] }
    return (try? PropertyListDecoder().decode([String: TALocation].self, from: data)) ?? [:]
  }
}
