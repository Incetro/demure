@testable import DemureApp
import Vapor
import XCTest

// MARK: - ArbitraryMiddlewareTests

final class ArbitraryMiddlewareTests: RequestTestCase {

    func testAbortNotFound() {

        /// given & when

        let future = ArbitraryMiddleware
            .notFound {
                $0.eventLoop.makeSucceededFuture(Response(status: .ok))
            }
            .respond(
                to: request,
                chainingTo: ArbitraryResponder {
                    $0.eventLoop.makeFailedFuture(Abort(.notFound))
                }
            )

        /// then

        XCTAssertEqual(try future.wait().status, .ok, "Catch abort error 404 and retrun 200")
    }

    func testResponseNotFound() {

        /// given & when

        let future = ArbitraryMiddleware
            .notFound {
                $0.eventLoop.makeSucceededFuture(Response(status: .ok))
            }
            .respond(
                to: request,
                chainingTo: ArbitraryResponder {
                    $0.eventLoop.makeSucceededFuture(Response(status: .notFound))
                }
            )

        /// then

        XCTAssertEqual(try future.wait().status, .ok, "Catch response 404 and retrun 200")
    }

    func testAbortBadRequest() {

        /// given & when

        let future = ArbitraryMiddleware
            .notFound {
                $0.eventLoop.makeSucceededFuture(Response(status: .ok))
            }
            .respond(
                to: request,
                chainingTo: ArbitraryResponder {
                    $0.eventLoop.makeFailedFuture(Abort(.badRequest))
                }
            )

        /// then

        XCTAssertThrowsError(try future.wait(), "Not catch abort error 400")
    }

    func testCapture() {

        /// given

        let response = Response(status: .ok)
        var captured: (request: Request, response: Response)?

        /// when

        let future = ArbitraryMiddleware
            .capture { request, response in
                captured = (request, response)
                return request.eventLoop.makeSucceededFuture(response)
            }
            .respond(
                to: request,
                chainingTo: ArbitraryResponder {
                    $0.eventLoop.makeSucceededFuture(response)
                }
            )

        /// then

        XCTAssertNoThrow(try future.wait())
        XCTAssertTrue(captured?.request === request)
        XCTAssertTrue(captured?.response === response)
    }

}
