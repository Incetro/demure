import DemureAPI
import Vapor

// MARK: - ResponseStore

protocol ResponseStore {

    /// The internal representation for any page
    var items: [ResponseStoreItem] { get }

    /// Request from our main application
    /// - Parameter request: HTTP request
    func response(for request: Request) -> EventLoopFuture<Response>

    /// Action from our main application
    /// - Parameters:
    ///   - action: Demure API action
    ///   - request: HTTP request
    func perform(_ action: DemureAction, for request: Request) -> EventLoopFuture<Response>
}
