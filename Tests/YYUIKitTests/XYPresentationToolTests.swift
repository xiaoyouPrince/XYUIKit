import XCTest
@testable import YYUIKit

final class XYPresentationToolTests: XCTestCase {
    func testImagePickerUtilitiesReturnSafelyWithoutVisibleViewController() {
        XYImagePicker.chooseImage { _ in
            XCTFail("Image callback should not be called when picker is not presented")
        }

        XYImagePicker.chooseVideo { _ in
            XCTFail("Video callback should not be called when picker is not presented")
        }
    }

    func testDatePickerReturnsSafelyWithoutVisibleViewController() {
        XYDatePicker.chooseDate(title: "Date", choosenDate: Date()) { _ in
            XCTFail("Date callback should not be called when picker is not presented")
        }
    }

    @available(iOS 14.0, *)
    func testColorPickerReturnsSafelyWithoutVisibleViewController() {
        XYColorPicker.showColorPicker { _ in
            XCTFail("Color callback should not be called when picker is not presented")
        }
    }
}
