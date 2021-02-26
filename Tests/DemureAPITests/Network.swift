import Foundation

// MARK: - Network

final class Network: URLProtocol {

    // MARK: - Properties

    private static var protocols: [URLProtocol] = []

    /// All current requests
    static var requests: [URLRequest] {
        protocols.map(\.request)
    }

    /// Request result
    static var result = Result<URLResponse, Error>.failure(URLError(.unsupportedURL))

    /// Currrent session task
    private var _task: URLSessionTask

    /// Currrent session task
    override var task: URLSessionTask? { _task }

    // MARK: - URLProtocol

    override class func canInit(with task: URLSessionTask) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    // MARK: - Initializers

    init(task: URLSessionTask, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        _task = task
        super.init(
            request: task.originalRequest.unwrap(),
            cachedResponse: cachedResponse,
            client: client
        )
    }

    // MARK: - Static

    static func clear() {
        protocols.removeAll()
        result = .failure(URLError(.unsupportedURL))
    }

    // MARK: - Override

    override func startLoading() {
        Network.protocols.append(self)

        switch Network.result {
        case .success(let response):
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
