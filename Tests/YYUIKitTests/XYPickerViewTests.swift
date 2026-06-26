import XCTest
@testable import YYUIKit

final class XYPickerViewTests: XCTestCase {
    func testPickerItemModelUsesTitleAndCode() {
        let item = XYPickerViewItem.model(with: [
            "title": "Option A",
            "code": "a"
        ])

        XCTAssertEqual(item.title, "Option A")
        XCTAssertEqual(item.code, "a")
    }

    func testPickerItemModelFallsBackToEmptyStrings() {
        let item = XYPickerViewItem.model(with: [
            "title": 1,
            "code": NSNull()
        ])

        XCTAssertEqual(item.title, "")
        XCTAssertEqual(item.code, "")
    }

    func testPickerDataSourceUsesDataArray() {
        let picker = XYPickerView()
        let pickerView = UIPickerView()
        picker.dataArray = [
            XYPickerViewItem(title: "One", code: "1"),
            XYPickerViewItem(title: "Two", code: "2")
        ]

        XCTAssertEqual(picker.numberOfComponents(in: pickerView), 1)
        XCTAssertEqual(picker.pickerView(pickerView, numberOfRowsInComponent: 0), 2)
        XCTAssertEqual(picker.pickerView(pickerView, titleForRow: 1, forComponent: 0), "Two")
    }

    func testNormalizedSelectedRowHandlesEmptyAndOutOfRangeValues() {
        let picker = XYPickerView()

        XCTAssertNil(picker.normalizedSelectedRow())

        picker.dataArray = [
            XYPickerViewItem(title: "One", code: "1"),
            XYPickerViewItem(title: "Two", code: "2")
        ]

        picker.defaultSelectedRow = -10
        XCTAssertEqual(picker.normalizedSelectedRow(), 0)

        picker.defaultSelectedRow = 10
        XCTAssertEqual(picker.normalizedSelectedRow(), 1)

        picker.defaultSelectedRow = 1
        XCTAssertEqual(picker.normalizedSelectedRow(), 1)
    }

    func testShowPickerReturnsFalseForEmptyDataInsteadOfCrashing() {
        let picker = XYPickerView()

        let didShow = picker.showPicker { _ in
            XCTFail("Empty picker should not call completion")
        }

        XCTAssertFalse(didShow)
        XCTAssertNil(picker.superview)
    }
}
