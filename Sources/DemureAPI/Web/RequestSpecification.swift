import Foundation

// MARK: - RequestSpecification

/// Mocking request model
public struct RequestSpecification: Codable, Hashable {

    /// HTTP method
    public let method: HTTPMethod

    /// Request URL
    public let url: Pattern

    /// Request headers
    public let headers: [String: Pattern]

    /// Default initializer
    /// - Parameters:
    ///   - method: HTTP method
    ///   - url: Request URL
    ///   - headers: Request headers
    public init(
        method: HTTPMethod,
        url: PatternRepresentable,
        headers: [String: PatternRepresentable] = [:]
    ) {
        self.method = method
        self.url = url.pattern
        self.headers = headers.mapValues(\.pattern)
    }

}
