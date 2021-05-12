//
//  WeatherError.swift
//  TideApp
//
//  Created by Dan Smith on 05/05/2021.
//

import Foundation

enum WeatherError: Error, LocalizedError {
  case parsing(description: String)
  case network(description: String)
}

extension WeatherError: CustomStringConvertible {
  var description: String {
    switch self {
    case .parsing:
      return "There was a problem reading the tide information. Please try again."
    case .network:
      return "There was a problem fetching the tide information. Please try again."
    }
  }
}
