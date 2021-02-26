import Vapor

// MARK: - RedirectMiddleware

final class RedirectMiddleware: Middleware {

    // MARK: - Properties

    /// Server URI
    private let redirectURI: URI

    // MARK: - Initializers

    /// Defaul initializer
    /// - Parameter serverURL: server URI
    init(serverURL: URL) {
        self.redirectURI = URI(string: serverURL.absoluteString)
    }

    // MARK: - Middleware

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        var clientRequest = ClientRequest(
            method: request.method,
            url: redirectURI,
            headers: request.headers,
            body: request.body.data)
        clientRequest.url.string += request.url.string
        return request
            .client
            .send(clientRequest)
            .map { (response: ClientResponse) -> Response in
                let body = response.body.map { Response.Body(buffer: $0) } ?? .empty
                return Response(
                    status: response.status,
                    version: request.version,
                    headers: response.headers,
                    body: body)
            }
    }
}
