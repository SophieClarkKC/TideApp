//
//  IntentHandler.swift
//  TideAppWidgetIntentHandler
//
//  Created by Marco Guerrieri on 14/05/2021.
//

import Intents

final class IntentHandler: INExtension, WidgetConfigurationIntentHandling {
  func provideFavouriteOptionsCollection(for intent: WidgetConfigurationIntent, with completion: @escaping (INObjectCollection<WidgetFavouriteLocation>?, Error?) -> Void) {
    let first = WidgetFavouriteLocation(identifier: "Southwark", display: "Southwark")
    first.latitude = 51.4500
    first.longitude = -0.0833

    let second = WidgetFavouriteLocation(identifier: "Rome", display: "Rome")
    second.latitude = 41.902782
    second.longitude = 12.496366

    let third = WidgetFavouriteLocation(identifier: "Buenos Aires", display: "Buenos Aires")
    third.latitude = -34.603722
    third.longitude = -58.381592

    let fourth = WidgetFavouriteLocation(identifier: "Sydney", display: "Sydney")
    fourth.latitude = -33.865143
    fourth.longitude = 151.209900

    let fifth = WidgetFavouriteLocation(identifier: "Dakar", display: "Dakar")
    fifth.latitude = 14.716677
    fifth.longitude = -17.467686

    completion(INObjectCollection(items: [first, second, third, fourth, fifth]), nil)
  }
}
