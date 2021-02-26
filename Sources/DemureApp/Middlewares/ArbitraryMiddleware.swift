import Vapor

// MARK: - ArbitraryMiddleware

final class ArbitraryMiddleware: Middleware {

    // MARK: - Alias

    /// Request handler alias
    private typealias Handler = (Request, Responder) -> EventLoopFuture<Response>

    // MARK: - Properties

    /// Request handler
    private let handler: Handler

    // MARK: - Initializers

    /// Default initializer
    /// - Parameter handler: request handler
    private init(handler: @escaping Handler) {
        self.handler = handler
    }

    // MARK: - Middleware

    /// Called with each `Request` that passes through this middleware.
    /// - parameters:
    ///     - request: The incoming `Request`.
    ///     - next: Next `Responder` in the chain, potentially another middleware or the main router.
    /// - returns: An asynchronous `Response`.
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        handler(request, next)
    }

    // MARK: - Static

    /// A 'route not found' middleware
    ///
    /// - Parameter handler: request handler
    /// - Returns: a new `Middleware` instance
    static func notFound(_ handler: @escaping (Request) -> EventLoopFuture<Response>) -> Middleware {
        ArbitraryMiddleware { (request, responder) -> EventLoopFuture<Response> in
            responder
                .respond(to: request)
                .flatMap { response -> EventLoopFuture<Response> in
                    response.status == .notFound
                        ? handler(request)
                        : request.eventLoop.makeSucceededFuture(response)
                }
                .flatMapError { (error: Error) -> EventLoopFuture<Response> in
                    if let abort = error as? Abort, abort.status == .notFound {
                        return handler(request)
                    }
                    return request.eventLoop.makeFailedFuture(error)
                }
        }
    }

    /// A 'captured route' middleware
    /// - Parameter handle: request handler
    /// - Returns: a new `Middleware` instance
    static func capture(_ handle: @escaping (Request, Response) -> EventLoopFuture<Response>) -> Middleware {
        ArbitraryMiddleware { (request, responder) -> EventLoopFuture<Response> in
            responder
                .respond(to: request)
                .flatMap { response in
                    handle(request, response)
                }
        }
    }
}
