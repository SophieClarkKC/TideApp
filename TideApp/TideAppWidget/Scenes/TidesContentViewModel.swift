//
//  TidesContentViewModel.swift
//  TideAppWidgetExtension
//
//  Created by Marco Guerrieri on 11/05/2021.
//

import Foundation

struct TidesContentViewModel {
  let place: String
  let waterTemperature: String?
  let tidesTimes: [WeatherData.Weather.Tide.TideData]?
  var tideStatus: String? { tidesTimes?.current?.tideType.description.abbreviated }

  init(weatherInfo: WeatherInfo) {
    self.place = weatherInfo.locationName
    self.tidesTimes = weatherInfo.tideTimes

    if let currentTemperature = weatherInfo.waterTemperature {
      self.waterTemperature = "Water at ~\(String(format: "%.0f", currentTemperature))c"
    } else {
      self.waterTemperature = nil
    }
  }

  func hasPrincipalInfos() -> Bool {
    return tideStatus != nil && waterTemperature != nil
  }

}
