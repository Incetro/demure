import Vapor

// MARK: - ArbitraryResponder

struct ArbitraryResponder: Responder {

    // MARK: - Properties

    let handler: (Request) -> EventLoopFuture<Response>

    // MARK: - Responder

    func respond(to request: Request) -> EventLoopFuture<Response> {
        handler(request)
    }
}
