//
//  WeatherInfo.swift
//  TideApp
//
//  Created by John Sanderson on 14/05/2021.
//

import Foundation

struct WeatherInfo {

  typealias TideData = WeatherData.Weather.Tide.TideData

  let locationName: String
  let subTitle: String
  let tideTimes: [TideData]
  let tideHeight: String?
  let waterTemperature: Double?
}

extension Array where Element == WeatherInfo.TideData {

  var current: Element? {
    let dateOfTheClosestTide = Date().closestDates(in: compactMap({ $0.tideDateTime.date(with: .dateTime)})).first
    return first(where: { $0.tideDateTime.date(with: .dateTime) == dateOfTheClosestTide })
  }

  var next: Element? {
    let dateOfTheNextTide = Date().closestDates(in: compactMap({ $0.tideDateTime.date(with: .dateTime)})).last
    return first(where: { $0.tideDateTime.date(with: .dateTime) == dateOfTheNextTide })
  }
}

extension WeatherInfo.TideData {

  var description: String {
    switch tideType {
    case .high:
      return "High tide at \(tideTime)"
    case .low:
      return "Low tide at \(tideTime)"
    }
  }
}

extension WeatherInfo.TideData.TideType {

  typealias Description = (abbreviated: String, full: String)

  var description: Description {
    switch self {
    case .high:
      return ("Going out", "Currently, the tide is going out")
    case .low:
      return ("Coming in", "Currently, the tide is coming in")
    }
  }
}
