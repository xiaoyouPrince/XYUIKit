import Foundation
import XCTest
@testable import YYUIKit

final class XYFileManagerTests: XCTestCase {
    private struct TestModel: Codable, Equatable {
        let id: Int
        let name: String
    }

    private var fileName: String!

    override func setUp() {
        super.setUp()
        fileName = "yyuikit-test-\(UUID().uuidString).json"
        XYFileManager.removeFile(with: fileName)
    }

    override func tearDown() {
        XYFileManager.removeFile(with: fileName)
        fileName = nil
        super.tearDown()
    }

    func testCreateAndRemoveFile() throws {
        XCTAssertTrue(XYFileManager.creatFile(with: fileName))

        let documentPath = try XCTUnwrap(XYFileManager.documentPath)
        let path = URL(fileURLWithPath: documentPath).appendingPathComponent(fileName).path
        XCTAssertTrue(FileManager.default.fileExists(atPath: path))

        XCTAssertTrue(XYFileManager.removeFile(with: fileName))
        XCTAssertFalse(FileManager.default.fileExists(atPath: path))
    }

    func testWriteReadAndAppendCodableModels() {
        let first = TestModel(id: 1, name: "one")
        let second = TestModel(id: 2, name: "two")

        XCTAssertEqual(XYFileManager.writeFile(with: fileName, models: [first]), [first])
        XCTAssertEqual(XYFileManager.readFile(with: fileName), [first])
        XCTAssertEqual(XYFileManager.appendFile(with: fileName, model: second), [first, second])
        XCTAssertEqual(XYFileManager.readFile(with: fileName), [first, second])
    }

    func testValidateURLCreatesIntermediateDirectoriesOnly() {
        let root = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("yyuikit-\(UUID().uuidString)")
        let fileURL = root
            .appendingPathComponent("level1")
            .appendingPathComponent("level2")
            .appendingPathComponent("data.json")

        defer {
            try? FileManager.default.removeItem(at: root)
        }

        XYFileManager.validateURL(url: fileURL)

        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.deletingLastPathComponent().path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: fileURL.path))
    }
}
