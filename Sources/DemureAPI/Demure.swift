import Foundation

// MARK: - Demure

/// Our server's API mocker
public final class Demure {

    // MARK: - Static

    /// Current session's request timeout interval
    public static let timeoutInterval: TimeInterval = 5

    /// Localhost IPv4 representation.
    public static let localhost = URL(string: "http://127.0.0.1:8080").unwrap()

    /// Default network session
    public static var session: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = timeoutInterval
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
        session.sessionDescription = "Demure mock server session"
        return session
    }

    // MARK: - Properties

    /// Server URL adress
    public let url: URL

    /// Our assistive network session
    private let session: URLSession

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - url: server URL adress
    ///   - session: our assistive network session
    public init(url: URL = localhost, session: URLSession = session) {
        self.url = url
        self.session = session
    }

    // MARK: - Public

    /// Send the command to the server
    /// - Parameters:
    ///   - command: some mocking action
    ///   - completion: completion closure
    /// - Returns: URLSessionTask instance
    @discardableResult public func send(
        _ action: DemureAction,
        completion: @escaping (Error?) -> Void
    ) throws -> URLSessionTask {
        let request = try action.request(to: url)
        return dataTask(request, completion: completion)
    }

    /// Send the given command synchronously to the server
    /// - Parameter action: some mocking action
    /// - Throws: `URLError` or `DemureError`.
    public func send(_ action: DemureAction) throws {
        var outError: Error?
        let task = try send(action) { (error: Error?) in
            outError = error
        }
        task.wait()
        if let error = outError {
            throw error
        }
    }

    /// Mock the given request
    /// - Parameter mockable: target request mock
    /// - Throws: `URLError` or `DemureError`.
    public func mock(_ mockable: DemureMockable) throws {
        try send(.add(mockable))
    }

    /// Remove the given mock
    /// - Parameter mock: target request mock
    /// - Throws: `URLError` or `DemureError`.
    public func remove(mock: DemureMockable) throws {
        try send(.remove(mock))
    }

    /// Clear all currently stored mocks
    /// - Throws: `URLError` or `DemureError`.
    public func clear() throws {
        try send(.clear)
    }

    // MARK: - Private

    /// Executes the given request's session task
    /// - Parameters:
    ///   - urlRequest: target network request
    ///   - completion: completion closure
    /// - Returns: URLSessionTask instance
    private func dataTask(
        _ urlRequest: URLRequest,
        completion: @escaping (Error?) -> Void
    ) -> URLSessionTask {
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            switch (response, error) {
            case (_, let error?):
                completion(error)
            case (let http as HTTPURLResponse, _):
                completion(DemureError(response: http, data: data))
            default:
                completion(nil)
            }
        }
        task.resume()
        return task
    }
}
