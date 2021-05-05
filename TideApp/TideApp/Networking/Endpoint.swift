//
//  Endpoint.swift
//  TideApp
//
//  Created by Dan Smith on 05/05/2021.
//

import Foundation

protocol EndpointType {
  /// HTTP or HTTPS
  var scheme: String { get }
  
  /// e.g. "api.worldweatherapp.om
  var baseURL: String { get }
  
  /// e.g. "/services/marine
  var path: String { get }
  
  /// [URLQueryItem(name: "api_key", value: API_KEY)]
  var parameters: [URLQueryItem] { get }
  
  /// GET, POST etc
  var method: String { get }
}

enum WeatherEndpoint: EndpointType {
  case fetchWeatherData(lat: Double, lon: Double)
  
  var scheme: String { return "https" }
  var baseURL: String { return "api.worldweatheronline.com" }
  var path: String { return "/premium/v1/marine.ashx" }
  
  var parameters: [URLQueryItem] {
    switch self {
    case .fetchWeatherData(let lat, let lon):
      return [URLQueryItem(name: "key", value: Keys.apiKey),
              URLQueryItem(name: "format", value: "json"),
              URLQueryItem(name: "q", value: "\(lat),\(lon)"),
              URLQueryItem(name: "tide", value: "yes"),
              URLQueryItem(name: "num_of_days", value: "1"),
              URLQueryItem(name: "includelocation", value: "yes"),
              URLQueryItem(name: "tp", value: "3")
      ]
    }
  }
  
  var method: String {
    switch self {
    case .fetchWeatherData:
      return "GET"
    }
  }
}
