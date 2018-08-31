import XCTest
@testable import ClassRegistry

final class ClassRegistryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ClassRegistry().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
