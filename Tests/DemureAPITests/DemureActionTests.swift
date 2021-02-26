@testable import DemureAPI
import XCTest

// MARK: - DemureActionTests

final class DemureActionTests: XCTestCase {

    /// JSONDecoder instance
    private let decoder = JSONDecoder()

    /// Base url address
    private let baseURL = URL(string: "https://example.com").unwrap()

    /// Expected url address
    private var expectedURL: URL {
        baseURL.appendingPathComponent("demure/api/mocks")
    }

    // MARK: - Tests

    func testUpdate() throws {

        /// given

        let request = RequestSpecification(method: .GET, url: "/about")
        let response = ResponseSpecification(status: 200, body: Data("hello".utf8))
        let action = DemureAction.update(request, response)

        /// when

        let urlRequest = try XCTUnwrap(try action.request(to: baseURL))

        /// then

        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(urlRequest.url, expectedURL)
        XCTAssertEqual(try urlRequest.httpBody.map {
            try decoder.decode(DemureAction.self, from: $0)
        }, action)
    }

    func testRemove() throws {

        /// given

        let request = RequestSpecification(method: .GET, url: "/about")
        let action = DemureAction.remove(request)

        /// when

        let urlRequest = try XCTUnwrap(try action.request(to: baseURL))

        /// then

        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(urlRequest.url, expectedURL)
        XCTAssertEqual(try urlRequest.httpBody.map {
            try decoder.decode(DemureAction.self, from: $0)
        }, action)
    }

    func testClear() throws {

        /// given

        let action = DemureAction.clear
        
        /// when

        let urlRequest = try XCTUnwrap(try action.request(to: baseURL))

        /// then

        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(urlRequest.url, expectedURL)
        XCTAssertEqual(try urlRequest.httpBody.map {
            try decoder.decode(DemureAction.self, from: $0)
        }, action)
    }
}
