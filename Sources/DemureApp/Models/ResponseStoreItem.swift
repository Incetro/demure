import DemureAPI
import Vapor

// MARK: - ResponseStoreItem

struct ResponseStoreItem: Equatable {

    // MARK: - Properties

    /// Current request specification
    let pattern: RequestSpecification

    /// Current response specification
    private(set) var mock: ResponseSpecification

    /// Validation
    var isValid: Bool {
        mock.limit.map { $0 > 0 } ?? true
    }

    /// Make HTTP response from mock.
    var response: Response {
        let status = HTTPResponseStatus(statusCode: mock.status)
        var headers = HTTPHeaders()
        mock.headers.forEach { headers.add(name: $0.key, value: $0.value) }
        let body = mock.body.map { Response.Body(data: $0) } ?? .empty
        return Response(status: status, headers: headers, body: body)
    }

    // MARK: - Mutators

    mutating func decremented() -> ResponseStoreItem {
        if let limit = mock.limit {
            mock.limit = limit - 1
        }
        return self
    }

    // MARK: - Match

    func match(_ request: Request) -> Bool {
        return pattern.method.rawValue == request.method.string
            && pattern.url.match(request.url.string)
            && pattern.headers.allSatisfy { key, pattern in
                request.headers.first(name: key).map(pattern.match) ?? false
            }
    }
}
