import XCTest
@testable import MockServer

final class MockServerTests: XCTestCase {
  func testExample() {

    XCTAssertEqual(MockServer().text, "Hello, World!")
  }
}
