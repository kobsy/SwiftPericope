import XCTest
@testable import SwiftPericope

final class SwiftPericopeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftPericope().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
