import XCTest
@testable import YYUIKit

final class DateExtensionsTests: XCTestCase {
    func testDateFormatterRoundTripAndComponents() throws {
        let date = try XCTUnwrap(Date.date(withFormatter: "yyyy-MM-dd HH:mm:ss", dateString: "2026-06-26 13:45:30"))

        XCTAssertEqual(date.string(withFormatter: "yyyy-MM-dd HH:mm:ss"), "2026-06-26 13:45:30")
        XCTAssertEqual(date.current(component: .year), 2026)
        XCTAssertEqual(date.current(component: .month), 6)
        XCTAssertEqual(date.current(component: .day), 26)
    }

    func testSameDayComparison() throws {
        let morning = try XCTUnwrap(Date.date(withFormatter: "yyyy-MM-dd HH:mm:ss", dateString: "2026-06-26 08:00:00"))
        let evening = try XCTUnwrap(Date.date(withFormatter: "yyyy-MM-dd HH:mm:ss", dateString: "2026-06-26 22:00:00"))
        let nextDay = try XCTUnwrap(Date.date(withFormatter: "yyyy-MM-dd HH:mm:ss", dateString: "2026-06-27 08:00:00"))

        XCTAssertTrue(Date.isSameDay(morning, otherDate: evening))
        XCTAssertFalse(Date.isSameDay(morning, otherDate: nextDay))
    }

    func testTimeBetweenToDate() throws {
        let start = try XCTUnwrap(Date.date(withFormatter: "yyyy-MM-dd HH:mm:ss", dateString: "2026-06-26 00:00:00"))
        let end = try XCTUnwrap(Date.date(withFormatter: "yyyy-MM-dd HH:mm:ss", dateString: "2026-06-27 01:02:03"))

        XCTAssertEqual(start.timeBetweenToDate(end, component: .day), 1)
        XCTAssertEqual(start.timeBetweenToDate(end, component: .hour), 25)
        XCTAssertEqual(start.timeBetweenToDate(end, component: .minute), 1502)
        XCTAssertEqual(start.timeBetweenToDate(end, component: .second), 90123)
        XCTAssertEqual(start.timeBetweenToDate(end, component: .weekday), 0)
    }

    func testRemainingDaysInMonthAndWeek() throws {
        let date = try XCTUnwrap(Date.date(withFormatter: "yyyy-MM-dd HH:mm:ss", dateString: "2026-06-26 12:00:00"))

        XCTAssertEqual(date.daysRemainingInMonth(), 4)
        XCTAssertNotNil(date.daysRemainingInWeek())
    }
}
