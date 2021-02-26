@testable import DemureApp
import Vapor

/// https://jsonplaceholder.typicode.com
struct TodoAPI {

    // MARK: - Todo

    struct Todo: Codable {
        let id: Int
        let title: String
        var path: String { "/todos/\(id)" }
    }

    // MARK: - Properties

    /// API host
    let host = URL(string: "https://jsonplaceholder.typicode.com").unwrap()

    /// API root directory
    let root = "/todos"

    /// Required headers for all requests
    let headers: HTTPHeaders = [
        "Accept": "text/plain"
    ]

    /// All todos
    let todos = [
        Todo(
            id: 11,
            title: "vero rerum temporibus dolor"
        ),
        Todo(
            id: 13,
            title: "et doloremque nulla"
        )
    ]
}
