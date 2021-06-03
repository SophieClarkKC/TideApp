//
//  GeneralHelpers.swift
//  TideApp
//
//  Created by Sophie Clark on 11/05/2021.
//

import Foundation

class GeneralHelpers {
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
    var deltaEndStart: Double
    if startValue > endValue {
      deltaEndStart = startValue - endValue
    } else {
      deltaEndStart = endValue - startValue
    }
    let heightFraction = timeFraction * deltaEndStart
    let additionValue = endValue < startValue ? endValue : startValue
    let currentHeight = heightFraction + additionValue
    
    return currentHeight
  }
}
