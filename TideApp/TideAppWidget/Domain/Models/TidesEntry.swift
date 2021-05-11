//
//  TidesEntry.swift
//  TideApp
//
//  Created by Marco Guerrieri on 10/05/2021.
//

import WidgetKit

struct TidesEntry: TimelineEntry {
  let widgetData: WidgetData
  let date: Date
  let configuration: ConfigurationIntent

  enum WidgetData {
    case success(place: String, weatherData: WeatherData)
    case failure(error: String)
  }
}

extension TidesEntry {
  static func snapshotObject(onError: Bool = false) -> TidesEntry {
    let widgetData: WidgetData
    
    if onError {
      widgetData = .failure(error: "Generic Error")
    } else {
      widgetData = .success(place: "Brighton",
                            weatherData: WeatherData(request: [],
                                                     nearestArea: [],
                                                     weather: [])
      )
    }

    return TidesEntry(widgetData: widgetData,
                      date: Date(),
                      configuration: ConfigurationIntent())
  }
}
