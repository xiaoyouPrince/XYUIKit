import XCTest
@testable import YYUIKit

final class XYRateLimiterTests: XCTestCase {
    private var limiter: XYRateLimiter!
    private var eventName: String!

    override func setUp() {
        super.setUp()
        limiter = XYRateLimiter()
        eventName = "test_\(UUID().uuidString)"
        limiter.resetRateLimitData(forEvent: eventName)
    }

    override func tearDown() {
        limiter.resetRateLimitData(forEvent: eventName)
        eventName = nil
        limiter = nil
        super.tearDown()
    }

    func testAllowsFirstExecution() {
        var executionCount = 0

        let didExecute = limiter.attemptExecution(
            forEvent: eventName,
            maxExecutionsPerDay: 1,
            minIntervalInSeconds: 0
        ) {
            executionCount += 1
        }

        XCTAssertTrue(didExecute)
        XCTAssertEqual(executionCount, 1)
    }

    func testBlocksWhenDailyLimitReached() {
        var executionCount = 0

        XCTAssertTrue(limiter.attemptExecution(
            forEvent: eventName,
            maxExecutionsPerDay: 1,
            minIntervalInSeconds: 0
        ) {
            executionCount += 1
        })

        XCTAssertFalse(limiter.attemptExecution(
            forEvent: eventName,
            maxExecutionsPerDay: 1,
            minIntervalInSeconds: 0
        ) {
            executionCount += 1
        })

        XCTAssertEqual(executionCount, 1)
    }

    func testBlocksWhenMinimumIntervalHasNotElapsed() {
        var executionCount = 0

        XCTAssertTrue(limiter.attemptExecution(
            forEvent: eventName,
            maxExecutionsPerDay: 2,
            minIntervalInSeconds: 60
        ) {
            executionCount += 1
        })

        XCTAssertFalse(limiter.attemptExecution(
            forEvent: eventName,
            maxExecutionsPerDay: 2,
            minIntervalInSeconds: 60
        ) {
            executionCount += 1
        })

        XCTAssertEqual(executionCount, 1)
    }

    func testResetAllowsExecutionAgain() {
        var executionCount = 0

        XCTAssertTrue(limiter.attemptExecution(
            forEvent: eventName,
            maxExecutionsPerDay: 1,
            minIntervalInSeconds: 0
        ) {
            executionCount += 1
        })

        limiter.resetRateLimitData(forEvent: eventName)

        XCTAssertTrue(limiter.attemptExecution(
            forEvent: eventName,
            maxExecutionsPerDay: 1,
            minIntervalInSeconds: 0
        ) {
            executionCount += 1
        })

        XCTAssertEqual(executionCount, 2)
    }
}
