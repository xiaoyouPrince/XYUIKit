import CoreGraphics
import XCTest
@testable import YYUIKit

final class FoundationExtensionsTests: XCTestCase {
    func testArrayFirstStepSkipsMatchingElements() {
        let values = [1, 2, 3, 4, 5, 6]

        XCTAssertEqual(values.first(step: 0) { $0.isMultiple(of: 2) }, 2)
        XCTAssertEqual(values.first(step: 1) { $0.isMultiple(of: 2) }, 4)
        XCTAssertEqual(values.first(step: 2) { $0.isMultiple(of: 2) }, 6)
        XCTAssertNil(values.first(step: 3) { $0.isMultiple(of: 2) })
    }

    func testCollectionJSONConversion() throws {
        let dictionary: [String: Any] = ["name": "YYUIKit", "version": 1]

        let data = try XCTUnwrap(dictionary.toData)
        let decoded = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])

        XCTAssertEqual(decoded["name"] as? String, "YYUIKit")
        XCTAssertEqual(decoded["version"] as? Int, 1)
        XCTAssertNotNil(dictionary.toString)
    }

    func testCGRectSwapAndScale() {
        let rect = CGRect(x: 10, y: 20, width: 30, height: 40)

        XCTAssertEqual(rect.swapRectWH(), CGRect(x: 10, y: 20, width: 40, height: 30))
        XCTAssertEqual(rect.scale(with: 2), CGRect(x: 10, y: 20, width: 60, height: 80))
        XCTAssertEqual(CGSize(width: 12, height: 8).scale(with: 0.5), CGSize(width: 6, height: 4))
    }
}
