//
//  TidesContentViewModel.swift
//  TideAppWidgetExtension
//
//  Created by Marco Guerrieri on 11/05/2021.
//

import Foundation

struct TidesContentViewModel {
  let place: String

  let waterTemperatureDouble: Double?
  var waterTemperature: String? {
    if let temp = waterTemperatureDouble {
      return "\(Int(temp))℃"
    }
    return nil
  }
  let tideHeight: String?
  let tidesTimes: [WeatherData.Weather.Tide.TideData]?
  var tideStatus: String? { tidesTimes?.current?.tideType.description.abbreviated }

  init(weatherInfo: WeatherInfo) {
    self.place = weatherInfo.locationName
    self.tidesTimes = weatherInfo.tideTimes
    self.waterTemperatureDouble = weatherInfo.waterTemperature
    self.tideHeight = weatherInfo.tideHeight
  }

  func hasPrincipalInfos() -> Bool {
    return tideStatus != nil && waterTemperature != nil
  }

}
