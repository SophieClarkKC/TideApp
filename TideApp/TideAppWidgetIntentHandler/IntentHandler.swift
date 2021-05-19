//
//  IntentHandler.swift
//  TideAppWidgetIntentHandler
//
//  Created by Marco Guerrieri on 14/05/2021.
//

import Intents
import MapKit


final class IntentHandler: INExtension, WidgetConfigurationIntentHandling {
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
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = query
    searchRequest.resultTypes = .address
    let search = MKLocalSearch(request: searchRequest)
    search.start { response, error in
      guard error == nil else {
        return completion(nil, error)
      }
      guard let response = response else {
        return completion(.init(items: []), nil)
      }

      let searchResults = response.mapItems.compactMap { location -> WidgetLocation? in
        guard let name = location.name else { return nil }
        return WidgetLocation(name: name,
                              lat: NSNumber(value: location.placemark.coordinate.latitude),
                              long: NSNumber(value: location.placemark.coordinate.longitude),
                              type: .normal)
      }
      completion(.init(items: searchResults), nil)
    }
  }

  private func retrieveFavoruitesLocations() -> [WidgetLocation] {
    // TODO: Implement real retrievement of favourites locations
    let first = WidgetLocation(name: "Southwark", lat: 51.4500, long: -0.0833, type: .favourite)

    let second = WidgetLocation(name: "Rome", lat: 41.902782, long: 12.496366, type: .favourite)

    let third = WidgetLocation(name: "Buenos Aires", lat: -34.603722, long: -58.381592, type: .favourite)

    let fourth = WidgetLocation(name: "Sydney", lat: -33.865143, long: 151.209900, type: .favourite)

    let fifth = WidgetLocation(name: "Dakar", lat: 14.716677, long: -17.467686, type: .favourite)

    return [first, second, third, fourth, fifth]
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

  convenience init(name: String, lat: NSNumber, long: NSNumber, type: Type) {
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
    self.latitude = lat
    self.longitude = long
    self.isCurrentPosition = NSNumber(value: type == .currentLocation)
  }
}
