//
//  WeatherDecoder.swift
//  TideApp
//
//  Created by Dan Smith on 05/05/2021.
//

import Foundation
import Combine

class WeatherDecoder {
  func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, WeatherError> {
    let decoder = JSONDecoder()

    return Just(data)
      .decode(type: T.self, decoder: decoder)
      .mapError { error in
        .parsing(description: error.localizedDescription)
      }
      .eraseToAnyPublisher()
  }
}
