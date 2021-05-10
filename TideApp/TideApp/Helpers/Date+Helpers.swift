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
    let dateTimeIntervals = dates.compactMap({ $0.timeIntervalSince(self) })
    let pastDates = dateTimeIntervals.filter({ $0 < 0 })
    let futureDates = dateTimeIntervals.filter({ $0 > 0 })
    
    let closestPastDate = pastDates.sorted(by: >).first
    let closestFutureDate = futureDates.sorted(by: <).first

    return [Date(timeInterval: closestPastDate ?? 0, since: self), Date(timeInterval: closestFutureDate ?? 0, since: self)].compactMap { $0 }
  }
  
  func difference(from date: Date) -> Double {
    return self.timeIntervalSince1970 - date.timeIntervalSince1970
  }
  
  static func getWeightedValue(from beginDate: Date, middleDate: Date, endDate: Date, startValue: Double, endValue: Double) -> Double {
    let beginningAndEndDifference = endDate.difference(from: beginDate)
    let middleAndBeginningDifference = middleDate.difference(from: beginDate)
    
    let safeMiddleAndBeginningDifference = middleAndBeginningDifference == 0 ? 1 : middleAndBeginningDifference
    let safeTimeDifferenceBetweenTides = beginningAndEndDifference == 0 ? 1 : beginningAndEndDifference
    
    let timeFraction = safeMiddleAndBeginningDifference / safeTimeDifferenceBetweenTides
    let deltaLowHigh = startValue - endValue
    let heightFraction = timeFraction * deltaLowHigh
    let currentHeight = heightFraction + endValue
    
    return currentHeight
  }
}
