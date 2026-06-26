import XCTest
@testable import YYUIKit

final class AuthorityManagerTests: XCTestCase {
    func testAuthRawValueMapsKnownCasesAndUnknownFallback() {
        XCTAssertEqual(Auth(rawValue: 0), .location)
        XCTAssertEqual(Auth(rawValue: 1), .bluetooth)
        XCTAssertEqual(Auth(rawValue: 2), .healthStepCount)
        XCTAssertEqual(Auth(rawValue: 3), .notification)
        XCTAssertEqual(Auth(rawValue: 4), .activity)
        XCTAssertEqual(Auth(rawValue: 999), .unknown)
    }

    func testGetStatusDoesNotCrashForAsyncOrPrivacyRestrictedStatuses() {
        let manager = AuthorityManager()

        XCTAssertEqual(manager.getStatus(for: .notification), .notDetermined)
        XCTAssertEqual(manager.getStatus(for: .healthStepCount), .notDetermined)
        XCTAssertEqual(manager.getStatus(for: .unknown), .notDetermined)
    }
}
