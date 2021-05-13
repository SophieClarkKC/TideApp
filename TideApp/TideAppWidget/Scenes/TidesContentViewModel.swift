//
//  TidesContentViewModel.swift
//  TideAppWidgetExtension
//
//  Created by Marco Guerrieri on 11/05/2021.
//

import Foundation

struct TidesContentViewModel {
  let place: String
  let tideStatus: String?
  let waterTemperature: String?
  let tidesTimes: [WeatherData.Weather.Tide.TideData]?

  init(place: String, weatherData: WeatherData) {
    self.place = place
    self.tideStatus = weatherData.tideStatusText(with: Date(), abbreviated: true) ?? nil
    self.tidesTimes = weatherData.weather.first?.tides.first?.tideData

    if let currentTemperature = weatherData.currentWaterTemperature(with: Date()) {
      self.waterTemperature = "Water at ~\(String(format: "%.0f", currentTemperature))c"
    } else {
      self.waterTemperature = nil
    }
  }

  func hasPrincipalInfos() -> Bool {
    return tideStatus != nil && waterTemperature != nil
  }

}
