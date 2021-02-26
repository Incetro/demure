@testable import DemureAPI
import XCTest

// MARK: - DemureTests

final class DemureTests: XCTestCase {

    // MARK: - ContactMock

    private enum ContactMock: DemureMockable {

        case apple

        var request: RequestSpecification {
            .init(method: .PUT, url: "/contacts/1")
        }

        var response: ResponseSpecification {
            .init(status: 200, body: Data("first contact".utf8))
        }
    }

    // MARK: - Properties

    /// Current Demure instance under test
    private lazy var demure = Demure(url: url, session: session)

    /// URLSession instance
    private var session: URLSession = {
        let configuration = Demure.session.configuration
        configuration.protocolClasses = [Network.self]
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
    }()

    /// Base url address
    private let url = URL(string: "https://example.com").unwrap()

    private var requests: [URLRequest] {
        Network.requests
    }

    // MARK: - Override

    override func tearDown() {
        super.tearDown()
        session.invalidateAndCancel()
        Network.clear()
    }

    // MARK: - Tests

    func testSendActionAdd() throws {

        /// given

        let action = DemureAction.add(ContactMock.apple)
        Network.result = .success(response(status: 200))

        /// when

        XCTAssertNoThrow(try demure.send(action))

        /// then

        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests.first, try action.request(to: url))
    }

    func testSendActionRemove() throws {

        /// given

        let action = DemureAction.remove(ContactMock.apple)
        Network.result = .success(response(status: 200))

        /// when

        XCTAssertNoThrow(try demure.send(action))

        /// then

        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests.first, try action.request(to: url))
    }

    func testSendActionRemoveAll() throws {

        /// given

        let action = DemureAction.clear
        Network.result = .success(response(status: 200))

        /// when

        XCTAssertNoThrow(try demure.send(action))

        /// then

        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests.first, try action.request(to: url))
    }

    @available(iOS 7, macOS 10.13, *)
    func testURLError() {

        /// given

        let connectionError = URLError(.networkConnectionLost)
        Network.result = .failure(connectionError)

        /// when

        XCTAssertThrowsError(try demure.send(.clear)) { (error: Error) in

            /// then

            XCTAssertEqual(error.localizedDescription, connectionError.localizedDescription)
        }
    }

    // MARK: - Private

    private func response(status: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil).unwrap()
    }
}
