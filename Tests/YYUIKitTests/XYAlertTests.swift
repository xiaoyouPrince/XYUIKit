import XCTest
@testable import YYUIKit

final class XYAlertTests: XCTestCase {
    func testShowAlertReturnsFalseWhenNoVisibleViewController() {
        let didShow = XYAlert.showAlert(title: "Title", message: "Message", btnTitles: "OK") { _ in
            XCTFail("Alert action should not be called when alert is not presented")
        }

        XCTAssertFalse(didShow)
    }

    func testShowTextFieldAlertReturnsFalseWhenNoVisibleViewController() {
        let didShow = XYAlert.showTextFiledAlert(
            title: "Title",
            message: "Message",
            configurationHandlers: { _ in },
            btnTitles: "OK"
        ) { _, _ in
            XCTFail("Alert action should not be called when alert is not presented")
        }

        XCTAssertFalse(didShow)
    }

    func testShowCustomAndDismissReturnFalseWhenNoVisibleViewController() {
        XCTAssertFalse(XYAlert.showCustom(UIView()))
        XCTAssertFalse(XYAlert.dismiss())
    }
}
