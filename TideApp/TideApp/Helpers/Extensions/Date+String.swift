//
//  Date+String.swift
//  TideApp
//
//  Created by Sophie Clark on 07/05/2021.
//

import Foundation

extension Date {
  /// Converts a date to a given DateFormat
  ///
  /// - Parameter format: The `String.DateFormat` value indicating what format you want the date to be in
  /// - Returns a string represtenting the date in a given format
  func string(with format: String.DateFormat) -> String {
    return format.dateFormatter().string(from: self)
  }
}
