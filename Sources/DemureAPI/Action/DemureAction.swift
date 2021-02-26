import Foundation

// MARK: - DemureAction

/// Our main API action helper class
public enum DemureAction: Equatable {

    /// Update the given mock
    case update(RequestSpecification, ResponseSpecification)

    /// Remove the given request
    case remove(RequestSpecification)

    /// Remove all currently stored mocks
    case clear
}

// MARK: - DemureMockConvertible

extension DemureAction {

    /// Add or update `ResponseSpecification` for `RequestPattern`.
    ///
    /// - Parameter mock: Mock representation.
    /// - Returns: A new `DemureAction`.
    public static func add(_ mock: DemureMockable) -> DemureAction {
        DemureAction.update(mock.request, mock.response)
    }

    /// Remove `ResponseSpecification` for `RequestPattern`.
    ///
    /// - Parameter mock: Mock representation.
    /// - Returns: A new `DemureAction`.
    public static func remove(_ mock: DemureMockable) -> DemureAction {
        DemureAction.remove(mock.request)
    }
}

// MARK: - URLRequest

extension DemureAction {

    private static let encoder = JSONEncoder()

    /// Create a new `URLRequest`.
    ///
    /// - Parameter url: Demure server base url.
    /// - Returns: Request to mock server.
    func request(to url: URL) throws -> URLRequest {
        var request = URLRequest(url: url.appendingPathComponent("demure/api/mocks"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try DemureAction.encoder.encode(self)
        return request
    }

}
