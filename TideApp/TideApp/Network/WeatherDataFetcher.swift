//
//  WeatherDataFetcher.swift
//  TideApp
//
//  Created by Dan Smith on 05/05/2021.
//

import Foundation
import Combine

protocol WeatherDataFetchable {
  func getStandardWeatherData(lat: Double, lon: Double) -> AnyPublisher<WeatherData, WeatherError>
}

class WeatherDataFetcher {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
}

extension WeatherDataFetcher: WeatherDataFetchable {
  func getStandardWeatherData(lat: Double, lon: Double) -> AnyPublisher<WeatherData, WeatherError> {
    getWeatherData(lat: lat, lon: lon)
      .map(\.data)
      .eraseToAnyPublisher()
  }
  
  func getWeatherData(lat: Double, lon: Double, numOfDays: Int = 1, includeLocation: Bool = true, tp: Int = 3) -> AnyPublisher<WeatherResponse, WeatherError> {
    fetch(with: makeWeatherComponents(lat: lat, lon: lon, numOfDays: numOfDays, includeLocation: includeLocation, tp: tp))
  }
  
  private func fetch<T>(with components: URLComponents) -> AnyPublisher<T, WeatherError> where T: Decodable {
    guard let url = components.url else {
      let error = WeatherError.network(description: "Couldn't create URL")
      return Fail(error: error).eraseToAnyPublisher()
    }
    return session.dataTaskPublisher(for: URLRequest(url: url))
      .mapError { error in
        WeatherError.network(description: error.localizedDescription)
      }
      .flatMap(maxPublishers: .max(1)) { pair in
        WeatherDecoder().decode(pair.data)
      }
      .eraseToAnyPublisher()
  }
}

extension WeatherDataFetcher {
  struct WeatherDataAPI {
    static let scheme = "https"
    static let host = AppConfig.baseURL.host
    static let path = "/premium/v1/marine.ashx"
    
    static func makeQueryItems(lat: Double, lon: Double, numOfDays: Int, includeLocation: Bool, tp: Int) -> [URLQueryItem] {
      let validTP = Set([1, 3, 6, 12, 24]).contains(tp) ? tp : 3 // defaults the value to 3hourly if invalid
      
      return [URLQueryItem(name: "key", value: Keys.apiKey),
              URLQueryItem(name: "format", value: "json"),
              URLQueryItem(name: "q", value: "\(lat),\(lon)"),
              URLQueryItem(name: "tide", value: "yes"),
              URLQueryItem(name: "num_of_days", value: "\(numOfDays)"),
              URLQueryItem(name: "includelocation", value: includeLocation ? "yes" : "no"),
              URLQueryItem(name: "tp", value: "\(validTP)"),
      ]
    }
    
    func validTimePeriod(for timePeriod: Int) -> Int {
      switch timePeriod {
      case 1, 3, 6, 12, 24:
        return timePeriod
      default:
        return 3
      }
    }
  }
  
  func makeWeatherComponents(lat: Double, lon: Double, numOfDays: Int, includeLocation: Bool, tp: Int) -> URLComponents {
    var components = URLComponents()
    components.scheme = WeatherDataAPI.scheme
    components.host = WeatherDataAPI.host
    components.path = WeatherDataAPI.path
    components.queryItems = WeatherDataAPI.makeQueryItems(lat: lat, lon: lon, numOfDays: numOfDays, includeLocation: includeLocation, tp: tp)
    
    return components
  }
}
