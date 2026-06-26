import UIKit
import XCTest
@testable import YYUIKit

final class UIColorExtensionsTests: XCTestCase {
    func testHexColorFactoryAndHexStringRoundTrip() {
        XCTAssertEqual(UIColor.xy_getColor(hex: 0x336699).toHexString(), "#336699")
        XCTAssertEqual(UIColor.color(red: 51, green: 102, blue: 153).toHexString(), "#336699")
        XCTAssertEqual(kHexColor(0x336699).toHexString(), "#336699")
    }

    func testHexStringSupportsCommonFormats() {
        XCTAssertEqual(UIColor.hexString("#369").toHexString(), "#336699")
        XCTAssertEqual(UIColor.hexString("336699").toHexString(), "#336699")
        XCTAssertEqual(UIColor.hexString("0x336699").toHexString(), "#336699")
    }

    func testInvalidHexStringReturnsClearColor() {
        let rgba = UIColor.hexString("invalid").getRGBA()

        XCTAssertEqual(rgba.alpha, 0, accuracy: 0.001)
    }
}
