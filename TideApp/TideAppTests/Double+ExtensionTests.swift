//
//  Double+ExtensionTests.swift
//  TideAppTests
//
//  Created by Dan Smith on 20/05/2021.
//

import Foundation
import XCTest
@testable import TideApp

class DoubleExtensionTests: XCTestCase {
  func testCleanValueReturnsCorrectValues() {
    let oneWhole = Double(1.000000)
    let oneAndAHalf = Double(1.500000)
    let oneAndThreeQuarter = Double(1.75000)
    let lotsOfDigits = Double(1.2345)

    XCTAssertEqual(oneWhole.cleanValue(), "1")
    XCTAssertEqual(oneAndAHalf.cleanValue(), "1.5")
    XCTAssertEqual(oneAndThreeQuarter.cleanValue(), "1.75")
    XCTAssertEqual(lotsOfDigits.cleanValue(), "1.23")
  }
}
