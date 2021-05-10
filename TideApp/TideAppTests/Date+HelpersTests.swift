//
//  Date+HelpersTests.swift
//  TideAppTests
//
//  Created by Sophie Clark on 10/05/2021.
//

import XCTest
@testable import TideApp

class Date_HelpersTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    let calendar = Calendar.current
    
    let earliestDateComponents = DateComponents(calendar: calendar,
                                                year: 2021,
                                                month: 02,
                                                day: 14)
    let earlyDateComponents = DateComponents(calendar: calendar,
                                             year: 2021,
                                             month: 02,
                                             day: 28)
    let lateDateComponents = DateComponents(calendar: calendar,
                                            year: 2021,
                                            month: 03,
                                            day: 28)
    let latestDateComponents = DateComponents(calendar: calendar,
                                            year: 2021,
                                            month: 04,
                                            day: 28)
    let fakeCurrentDateComponents = DateComponents(calendar: calendar,
                                                   year: 2021,
                                                   month: 03,
                                                   day: 10)
    let earliestDate = calendar.date(from: earliestDateComponents)!
    let earlyDate = calendar.date(from: earlyDateComponents)!
    let lateDate = calendar.date(from: lateDateComponents)!
    let latestDate = calendar.date(from: latestDateComponents)!
    let fakeCurrentDate = calendar.date(from: fakeCurrentDateComponents)!
    
    let closestDates = fakeCurrentDate.closestDates(in: [earliestDate, earlyDate, lateDate, latestDate])
    
    XCTAssertEqual(closestDates.count, 2)
    XCTAssertEqual(closestDates.first, earlyDate)
    XCTAssertEqual(closestDates.last, lateDate)
  }
}
