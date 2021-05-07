//
//  Date+Helpers.swift
//  TideApp
//
//  Created by Sophie Clark on 07/05/2021.
//

import Foundation

extension Date {
  /// This function finds the two closest dates in a given array to a date (self) and returns them in an array
  ///
  /// - Parameter dates: The array of dates to be compared
  /// - Returns: An array of 2 dates which are the closest
  func closestDates(in dates: [Date]) -> [Date] {
    guard dates.count > 2 else { return dates }
    let sortedDates = dates.sorted()
    let closestPastDate = sortedDates.first { $0.timeIntervalSince(self) < 0 }
    let closestFutureDate = sortedDates.first { $0.timeIntervalSince(self) > 0 }
    return [closestPastDate, closestFutureDate].compactMap { $0 }
  }
  
  func difference(from date: Date?) -> Double {
    guard let date = date else {
      return 0
    }
    return self.timeIntervalSince1970 - date.timeIntervalSince1970
  }
}
