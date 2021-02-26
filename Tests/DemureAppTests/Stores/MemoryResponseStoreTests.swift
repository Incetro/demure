import DemureAPI
@testable import DemureApp
import Vapor
import XCTest

// MARK: - MemoryResponseStoreTests

final class MemoryResponseStoreTests: RequestTestCase {

    // MARK: - Properties

    private let store = MemoryResponseStore()

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        XCTAssertEqual(store.items, [])
    }

    // MARK: - Private

    private func perform(_ action: DemureAction, file: StaticString = #file, line: UInt = #line) {
        let future = store.perform(action, for: request)
        XCTAssertEqual(try future.wait().status, action.expectedStatus, file: file, line: line)
    }

    // MARK: - Tests

    func testPerformAdd() throws {

        /// given

        let mocks = ContactMock.mocks

        /// when

        mocks.forEach { perform(.add($0)) }

        /// then

        XCTAssertEqual(store.items.count, 4)
        XCTAssertEqual(store.items, mocks.map(\.item))
    }

    func testPerformUpdate() {

        /// given

        let createA = ContactMock.create(name: "A")
        let createB = ContactMock.create(name: "B")
        perform(.add(createB))

        /// when

        perform(.add(createA))

        /// then

        XCTAssertEqual(store.items, [createA.item])
    }

    func testPerformRemove() {

        /// given

        let first = ContactMock.first
        let second = ContactMock.second
        perform(.add(first))
        perform(.add(second))

        /// when

        perform(.remove(first))

        /// then

        XCTAssertEqual(store.items, [second.item])
    }

    func testPerformRemoveAll() {

        /// given

        ContactMock.mocks.forEach { perform(.add($0)) }

        /// when

        perform(.clear)

        /// then

        XCTAssertEqual(store.items, [])
    }

    func testResponseForRequest() throws {

        /// given

        ContactMock.mocks.forEach { perform(.add($0)) }

        /// when

        request.method = .GET
        request.url = "/api/contacts/1"
        let response = try store.response(for: request).wait()

        /// then

        XCTAssertEqual(response.status.code, 200)
        XCTAssertEqual(response.body.string, "first contact")
    }

    func testNotFoundResponse() throws {

        /// given

        ContactMock.mocks.forEach { perform(.add($0)) }

        /// when

        request.method = .GET
        request.url = "/api/contacts/4"
        let response = try store.response(for: request).wait()

        /// then

        XCTAssertEqual(response.status.code, 404)
        XCTAssertNil(response.body.string)
    }

    func testResponseLimit() throws {

        /// given

        ContactMock.mocks.forEach { perform(.add($0)) }

        /// when

        request.method = .GET
        request.url = "/api/contacts/2"
        XCTAssertEqual(try store.response(for: request).wait().status.code, 200)
        XCTAssertEqual(try store.response(for: request).wait().status.code, 200)
        let response = try store.response(for: request).wait()

        /// then

        XCTAssertEqual(response.status.code, 404)
        XCTAssertNil(response.body.string)
    }

    func testResponseDelay() throws {

        /// given

        let mock = ContactMock.far(delay: 2)
        perform(.add(mock))
        let start = Date()

        /// when

        request.method = .GET
        request.url = "/api/contacts/1000"
        let response = try store.response(for: request).wait()

        /// then

        XCTAssertEqual(Date().timeIntervalSince(start), 2, accuracy: 0.5)
        XCTAssertEqual(response.status.code, 200)
        XCTAssertEqual(response.body.string, "far contact")
    }
}
