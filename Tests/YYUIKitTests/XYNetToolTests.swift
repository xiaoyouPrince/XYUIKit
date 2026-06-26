import XCTest
@testable import YYUIKit

final class XYNetToolTests: XCTestCase {
    func testGetRequestEncodesQueryParametersAndKeepsExistingQuery() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com/search?existing=1"))

        let request = XYNetTool.makeRequest(
            url: url,
            method: .GET,
            paramters: [
                "keyword": "hello world",
                "symbol": "a&b"
            ],
            headers: ["Accept": "application/json"]
        )

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.timeoutInterval, 10)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")

        let components = try XCTUnwrap(URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false))
        let queryItems = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).compactMap { item in
            item.value.map { (item.name, $0) }
        })

        XCTAssertEqual(queryItems["existing"], "1")
        XCTAssertEqual(queryItems["keyword"], "hello world")
        XCTAssertEqual(queryItems["symbol"], "a&b")
        XCTAssertTrue(try XCTUnwrap(request.url?.absoluteString).contains("hello%20world"))
    }

    func testPostRequestSerializesJSONBodyAndHeaders() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com/api"))

        let request = XYNetTool.makeRequest(
            url: url,
            method: .POST,
            paramters: [
                "name": "YYUIKit",
                "count": 2
            ],
            headers: ["Content-Type": "application/json"],
            timeoutInterval: 3
        )

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.timeoutInterval, 3)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")

        let body = try XCTUnwrap(request.httpBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: body) as? [String: Any])
        XCTAssertEqual(json["name"] as? String, "YYUIKit")
        XCTAssertEqual(json["count"] as? Int, 2)
    }

    func testGetRequestWithoutParametersKeepsOriginalURL() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com/api"))

        let request = XYNetTool.makeRequest(url: url, method: .GET, paramters: [:], headers: nil)

        XCTAssertEqual(request.url, url)
        XCTAssertNil(request.httpBody)
    }
}
