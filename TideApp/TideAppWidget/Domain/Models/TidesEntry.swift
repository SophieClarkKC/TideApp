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
  let configuration: WidgetConfigurationIntent

  enum WidgetData {
    case success(weatherInfo: WeatherInfo)
    case failure(error: String)
  }
}

extension TidesEntry {
  static func snapshotObject(onError: Bool = false) -> TidesEntry {
    let widgetData: WidgetData
    
    if onError {
      widgetData = .failure(error: "Generic Error")
    } else {
      let weatherData = createMockWeatherData()
      widgetData = .success(weatherInfo: .init(locationName: "Brighton",
                                               subTitle: "A place near the sea",
                                               tideTimes: weatherData.weather.first?.tides.first?.tideData ?? [],
                                               tideHeight: "1.4m",
                                               waterTemperature: 12))
    }

    return TidesEntry(widgetData: widgetData,
                      date: Date(),
                      configuration: WidgetConfigurationIntent())
  }

  private static func createMockWeatherData() -> WeatherData {
    typealias TideData = WeatherData.Weather.Tide.TideData

    let todayDate = Date().string(with: .date)
    let request = [WeatherData.LocationRequest(query: "Lat 51.49 and Lon -0.23")]
    let nearestArea = [WeatherData.NearestArea(latitude: "51.500", longitude: "-0.083")]
    let tideData = [TideData(tideTime: "1:21 AM",
                             tideHeightM: "6.29",
                             tideDateTime: "\(todayDate) 01:21",
                             tideType: .high),
                    TideData(tideTime: "7:34 AM",
                             tideHeightM: "0.34",
                             tideDateTime: "\(todayDate) 07:34",
                             tideType: .low),
                    TideData(tideTime: "1:44 PM",
                             tideHeightM: "6.51",
                             tideDateTime: "\(todayDate) 13:44",
                             tideType: .high),
                    TideData(tideTime: "7:36 PM",
                             tideHeightM: "0.68",
                             tideDateTime: "\(todayDate) 19:36",
                             tideType: .low)]
    let tides = [WeatherData.Weather.Tide(tideData: tideData)]
    let hourly = [WeatherData.Weather.Hourly(time: "0", waterTempC: "12", waterTempF: "53")]
    let weather = [WeatherData.Weather(date: todayDate,
                                       tides: tides,
                                       hourly: hourly)]
    return WeatherData(request: request,
                       nearestArea: nearestArea,
                       weather: weather)
  }
}
