//
//  NetworkManager.swift
//  TideApp
//
//  Created by Dan Smith on 05/05/2021.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case invalidData
  case unableToComplete
}

final class NetworkManager {
  static let shared = NetworkManager()
  
  private init() {}
  
  func fetchWeatherData(endpoint: EndpointType, completed: @escaping(Result<WeatherData, NetworkError>) -> Void) {
    
    var components = URLComponents()
    components.scheme = endpoint.scheme
    components.host = endpoint.baseURL
    components.path = endpoint.path
    components.queryItems = endpoint.parameters
    
    guard let url = components.url else {
      completed(.failure(.invalidURL))
      return
    }
    
    let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
      
      if let _ = error {
        completed(.failure(.unableToComplete))
        return
      }
      
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completed(.failure(.invalidResponse))
        return
      }
      
      guard let data = data else {
        completed(.failure(.invalidData))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let decoderdResponse = try decoder.decode(WeatherResponse.self, from: data)
        completed(.success(decoderdResponse.data))
      } catch {
        completed(.failure(.invalidData))
      }
    }
    task.resume()
  }
}
