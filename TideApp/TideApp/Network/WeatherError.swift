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
