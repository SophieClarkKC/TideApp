//
//  IntentHandler.swift
//  TideAppWidgetIntentHandler
//
//  Created by Marco Guerrieri on 14/05/2021.
//

import Intents
import UIKit

final class IntentHandler: INExtension, WidgetConfigurationIntentHandling {
  private let locationSearcher = LocationSearcher()
  private let favouritesManager = FavouritesManager(with: UserDefaults.standard)
  
  func defaultLocationConfig(for intent: WidgetConfigurationIntent) -> WidgetLocation? {
    return createCurrentPositionItem()
  }
  
  func provideLocationConfigOptionsCollection(for intent: WidgetConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<WidgetLocation>?, Error?) -> Void) {
    guard let query = searchTerm, !query.isEmpty else {
      providePresetOptions(completion: completion)
      return
    }

    performLocationsSearch(with: query, completion: completion)
  }

  private func providePresetOptions(completion: @escaping (INObjectCollection<WidgetLocation>?, Error?) -> Void) {
    let currentPosition = createCurrentPositionItem()

    let favourites = retrieveFavoruitesLocations()

    completion(.init(items: [[currentPosition], favourites].flatMap { $0 } ), nil)
  }

  private func createCurrentPositionItem() -> WidgetLocation {
    let currentPosition = WidgetLocation(name: "Current Position",
                                         lat: 0,
                                         long: 0,
                                         type: .currentLocation)
    return currentPosition
  }

  private func performLocationsSearch(with query: String, completion: @escaping (INObjectCollection<WidgetLocation>?, Error?) -> Void) {
    locationSearcher.search(query: query) { items, error in
      guard error == nil else {
        return completion(nil, NSError(domain: "LocationSearcherError",
                                       code: 0,
                                       userInfo: [NSLocalizedDescriptionKey: "No result found. Please try to be more specific."]))
      }
      guard let items = items else {
        return completion(.init(items: []), nil)
      }

      let searchResults = items.compactMap { location -> WidgetLocation? in
        guard let name = location.name else { return nil }
        return WidgetLocation(name: name,
                              lat: location.placemark.coordinate.latitude,
                              long: location.placemark.coordinate.longitude,
                              type: .normal)
      }
      completion(.init(items: searchResults), nil)
    }
  }

  private func retrieveFavoruitesLocations() -> [WidgetLocation] {
    favouritesManager.fetch()
    return favouritesManager.favourites.map { WidgetLocation(name: $0.name,
                                                             lat: $0.latitude,
                                                             long: $0.longitude,
                                                             type: .favourite) }
//    let first = WidgetLocation(name: "Southwark", lat: 51.4500, long: -0.0833, type: .favourite)
//
//    let second = WidgetLocation(name: "Rome", lat: 41.902782, long: 12.496366, type: .favourite)
//
//    let third = WidgetLocation(name: "Buenos Aires", lat: -34.603722, long: -58.381592, type: .favourite)
//
//    let fourth = WidgetLocation(name: "Sydney", lat: -33.865143, long: 151.209900, type: .favourite)
//
//    let fifth = WidgetLocation(name: "Dakar", lat: 14.716677, long: -17.467686, type: .favourite)
//
//    return [first, second, third, fourth, fifth]
  }
}

fileprivate extension WidgetLocation {
  enum `Type` {
    case favourite
    case currentLocation
    case normal
  }

  private struct Images {
    static let gps = INImage(imageData: UIImage(systemName: SystemAsset.location.rawValue)?.pngData() ?? Data())
    static let favourite = INImage(imageData: UIImage(systemName: SystemAsset.favouriteFilled.rawValue)?.pngData() ?? Data())
  }

  convenience init(name: String, lat: Double, long: Double, type: Type) {
    let image: INImage?
    let subtitle: String?
    switch type {
    case .favourite:
      image = Images.favourite
      subtitle = nil

    case .currentLocation:
      image = Images.gps
      subtitle = "Use GPS, need to be authorized"

    default:
      image = nil
      subtitle = nil
    }
    self.init(identifier: name,
              display: name,
              subtitle: subtitle,
              image: image)
    self.latitude = NSNumber(value:lat)
    self.longitude = NSNumber(value:long)
    self.isCurrentPosition = NSNumber(value: type == .currentLocation)
  }
}
