//
//  GetWeatherInformationRequest.swift
//  TideApp
//
//  Created by John Sanderson on 19/05/2021.
//

import CoreLocation
import Combine

struct GetWeatherInformationRequest: RequestType {

  // MARK: - Properties -
  // MARK: Private

  private let coordinate: CLLocationCoordinate2D
  private let date: Date
  private let networkManager: NetworkManagerType

  // MARK: - Initialiser -

  init(coordinate: CLLocationCoordinate2D, date: Date, networkManager: NetworkManagerType) {
    self.coordinate = coordinate
    self.date = date
    self.networkManager = networkManager
  }

  // MARK: - Functions -
  // MARK: Internal

  func perform() -> AnyPublisher<WeatherInfo, Error> {
    let resource = Resource(coordinate: coordinate)
    return networkManager.fetch(resource)
      .receive(on: DispatchQueue.main)
      .map(\.data)
      .flatMap(CLGeocoder().getLocationName)
      .map(mapInfo)
      .eraseToAnyPublisher()
  }

  // MARK: Private

  private func mapInfo(_ tuple: (placeName: String, weatherData: WeatherData)) -> WeatherInfo {
    let tideData = tuple.weatherData.weather.first?.tides.first?.tideData ?? []
    let subTitle = "Tide times"
    let tideHeight: String? = tuple.weatherData.calculateCurrentTideHeight(with: date).flatMap({ "~\(String(format: "%.2f", $0))m" })
    let waterTemperature: Double? = tuple.weatherData.currentWaterTemperature(with: date).flatMap({ Double($0) })
    return WeatherInfo(locationName: tuple.placeName, subTitle: subTitle, tideTimes: tideData, tideHeight: tideHeight, waterTemperature: waterTemperature)
  }
}

// MARK: - Resource -

extension GetWeatherInformationRequest {

  struct Resource: ResourceType {

    typealias Output = WeatherResponse

    /// The location to request the weather for
    let coordinate: CLLocationCoordinate2D
    /// The number of days forecast we want to request
    var numOfDays: Int = 1
    /// Whether we want the location of the nearest weather station to the requested lat,lon
    var includeLocation: Bool = true
    /// The hourly _Time period_ for the weather forecast.
    /// Possible values are 1, 3, 6, 12 or 24 hour periods.
    /// For 24 hourly periods we receive one forecast with the average temperature for the day, but the full range of tide times and heights.
    var timeInterval: Int = 3
    let pathComponent: String = "/premium/v1/marine.ashx"
    var queryItems: [URLQueryItem] {
      let validTimeInterval = Set([1, 3, 6, 12, 24]).contains(timeInterval) ? timeInterval : 3 // defaults the value to 3hourly if invalid
      return [URLQueryItem(name: "key", value: Keys.apiKey),
              URLQueryItem(name: "format", value: "json"),
              URLQueryItem(name: "q", value: "\(coordinate.latitude),\(coordinate.longitude)"),
              URLQueryItem(name: "tide", value: "yes"),
              URLQueryItem(name: "num_of_days", value: "\(numOfDays)"),
              URLQueryItem(name: "includelocation", value: includeLocation ? "yes" : "no"),
              URLQueryItem(name: "tp", value: "\(validTimeInterval)")]
    }
  }
}

// MARK: - Helpers -

private extension CLLocationDegrees {

  var asDouble: Double { Double(self) }
}
