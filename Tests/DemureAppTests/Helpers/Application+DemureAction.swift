@testable import DemureAPI
import XCTVapor

// MARK: - Application

extension Application {

    func perform(_ action: DemureAction, file: StaticString = #file, line: UInt = #line) throws {
        let request = try action.request(to: URL(string: "/").unwrap())
        let method = try XCTUnwrap(request.httpMethod.map(HTTPMethod.init), file: file, line: line)
        let path = try XCTUnwrap(request.url?.path, file: file, line: line)
        var headers = HTTPHeaders()
        request.allHTTPHeaderFields?.forEach { key, value in
            headers.add(name: key, value: value)
        }
        let body = request.httpBody.map { (data: Data) -> ByteBuffer in
            var buffer = allocator.buffer(capacity: data.count)
            buffer.writeBytes(data)
            return buffer
        }
        try test(method, path, headers: headers, body: body, file: file, line: line, afterResponse:  { response in
            XCTAssertEqual(response.status, action.expectedStatus, "Response status", file: file, line: line)
            XCTAssertEqual(response.body.string, "", "Response body", file: file, line: line)
        })
    }
}

// MARK: - DemureAction

extension DemureAction {
    var expectedStatus: HTTPResponseStatus {
        switch self {
        case .update:
            return .created
        case .remove, .clear:
            return .noContent
        }
    }
}
