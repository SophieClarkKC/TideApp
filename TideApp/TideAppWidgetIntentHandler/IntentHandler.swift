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
    first.latitude = 41.0
    first.longitude = 1.0

    let second = WidgetFavouriteLocation(identifier: "Brighton", display: "Brighton")
    first.latitude = 42.0
    first.longitude = 2.0

    let third = WidgetFavouriteLocation(identifier: "Margate", display: "Margate")
    first.latitude = 43.0
    first.longitude = 3.0

    completion(INObjectCollection(items: [first, second, third]), nil)
  }
}
