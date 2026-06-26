import CoreGraphics
import XCTest
@testable import YYUIKit

final class StringExtensionsTests: XCTestCase {
    func testSubstringHelpers() {
        XCTAssertEqual("abcdef".substringToIndex(to: 3), "abc...")
        XCTAssertEqual("abcdef".substringBeforeIndex(before: 3), "ab...")
        XCTAssertEqual("abc".substringToIndex(to: 3), "abc")
    }

    func testURLCodingAndParams() {
        let raw = "https://example.com/search?q=YY UIKit&lang=zh"
        let encoded = raw.urlEncoded

        XCTAssertNotEqual(encoded, raw)
        XCTAssertEqual(encoded.urlDecoded, raw)
        XCTAssertEqual("https://example.com?a=1&b=two".urlParams, ["a": "1", "b": "two"])
        XCTAssertEqual("https://example.com".toUrl?.host, "example.com")
    }

    func testPrimitiveConversions() {
        XCTAssertEqual("42".int, 42)
        XCTAssertEqual("invalid".intValue, 0)
        XCTAssertEqual("3.5".floatValue, 3.5, accuracy: 0.001)
        XCTAssertEqual("3.5".doubleValue, 3.5, accuracy: 0.001)
        XCTAssertEqual("3.5".cgValue, CGFloat(3.5), accuracy: 0.001)
        XCTAssertTrue("true".boolValue)
        XCTAssertTrue("1".boolValue)
        XCTAssertFalse("false".boolValue)
    }

    func testJSONConversions() throws {
        let dictionary = try XCTUnwrap("{\"name\":\"YYUIKit\",\"version\":1}".toDictionary)
        let array = try XCTUnwrap("[1,2,3]".toArray)

        XCTAssertEqual(dictionary["name"] as? String, "YYUIKit")
        XCTAssertEqual(dictionary["version"] as? Int, 1)
        XCTAssertEqual(array as? [Int], [1, 2, 3])
        XCTAssertNotNil("{\"ok\":true}".toJson)
    }

    func testMiscHelpers() {
        XCTAssertEqual("  YYUIKit \n".trim(), "YYUIKit")
        XCTAssertEqual(String.insertData(text: "abc", index: 1, newElement: "X"), "aXbc")
        XCTAssertEqual(String.insertData(text: "abc", index: 3, newElement: "X"), "abc")
        XCTAssertEqual(String.removeData(text: "abc", index: 1), "ac")
        XCTAssertEqual(String.removeData(text: "abc", index: 3), "abc")
        XCTAssertEqual("WVlVSUtpdA==".base64ToUTF8String, "YYUIKit")
        XCTAssertEqual("2".toMoneyString, "2.00")
    }
}
