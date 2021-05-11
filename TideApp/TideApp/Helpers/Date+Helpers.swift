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
  
  /// This function returns the difference in two dates as a `TimeInterval`
  ///
  /// - Parameter date: The date to find the difference from
  /// - Returns: A `TimeInterval` indicating the difference between self and the given date
  func difference(from date: Date) -> TimeInterval {
    return self.timeIntervalSince1970 - date.timeIntervalSince1970
  }
  
  /// This finds the weighted value given a start value and end value by calculating the time difference and
  /// how much of the time between two times has passed and using this to calculate the weighted value
  ///
  /// - Parameters:
  ///               - beginDate: The date at the start
  ///               - middleDate: The date which should be used to work out the percentage of time passed
  ///               - endDate: When the time for the period we are calculating the progress for ends
  ///               - startValue: The value associated with the beginDate
  ///               - endValue: The value associated with the end date
  /// - Returns: An array of 2 dates which are the closest
  static func getWeightedValue(from beginDate: Date, middleDate: Date, endDate: Date, startValue: Double, endValue: Double) -> Double {
    let timeBetweenBeginningAndEnd = endDate.difference(from: beginDate)
    let timeBetweenMiddleAndBeginning = middleDate.difference(from: beginDate)
    
    let safeMiddleAndBeginningDifference = timeBetweenMiddleAndBeginning == 0 ? 1 : timeBetweenMiddleAndBeginning
    let safeTimeDifferenceBetweenTides = timeBetweenBeginningAndEnd == 0 ? 1 : timeBetweenBeginningAndEnd
    
    let timeFraction = safeMiddleAndBeginningDifference / safeTimeDifferenceBetweenTides
    var deltaEndStart = startValue - endValue
    let heightFraction = timeFraction * deltaEndStart
    let currentHeight = heightFraction + endValue
    
    return currentHeight
  }
}
