//
//  GeneralHelpersTests.swift
//  TideAppTests
//
//  Created by Sophie Clark on 11/05/2021.
//

import XCTest
@testable import TideApp

class GeneralHelpersTests: XCTestCase {
  func testGetWeightedValueReturnsCorrectValue() {
    let calendar = Calendar.current
    let beginDateComponents = DateComponents(calendar: calendar,
                                             year: 2021,
                                             month: 02,
                                             day: 28,
                                             hour: 3)
    let middleDateComponents = DateComponents(calendar: calendar,
                                              year: 2021,
                                              month: 02,
                                              day: 28,
                                              hour: 5)
    let endDateComponents = DateComponents(calendar: calendar,
                                           year: 2021,
                                           month: 02,
                                           day: 28,
                                           hour: 7)
    let startDate = calendar.date(from: beginDateComponents)!
    let middleDate = calendar.date(from: middleDateComponents)!
    let endDate = calendar.date(from: endDateComponents)!
    
    let value = GeneralHelpers.getWeightedValue(from: startDate, middleDate: middleDate, endDate: endDate, startValue: 5, endValue: 1)
    
    XCTAssertEqual(value.rounded(), 3)
    
    let middleDateComponents2 = DateComponents(calendar: calendar,
                                               year: 2021,
                                               month: 02,
                                               day: 28,
                                               hour: 6)
    let middleDate2 = calendar.date(from: middleDateComponents2)!
    let value2 = GeneralHelpers.getWeightedValue(from: startDate, middleDate: middleDate2, endDate: endDate, startValue: 0.5, endValue: 1)
    
    XCTAssertEqual(value2, 0.875)
  }
}

