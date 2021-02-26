import Foundation

// MARK: - ResponseSpecification

/// Response model to our requests
public struct ResponseSpecification: Equatable, Codable {

    // MARK: - Properties

    /// HTTP status code
    public var status: Int

    /// Response headers
    public var headers: [String: String]

    /// Response body
    public var body: Data?

    /// Max number of processed requests
    public var limit: Int?

    /// Response delay
    public var delay: Int?

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - status: HTTP status code
    ///   - headers: response headers
    ///   - body: response body
    ///   - limit: max number of processed requests
    ///   - delay: response delay
    public init(
        status: Int = 200,
        headers: [String: String] = [:],
        body: Data? = nil,
        limit: Int? = nil,
        delay: Int? = nil
    ) {
        self.status = status
        self.headers = headers
        self.body = body
        self.limit = limit
        self.delay = delay
    }
}
