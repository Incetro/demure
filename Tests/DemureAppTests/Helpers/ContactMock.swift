import DemureAPI
@testable import DemureApp
import Foundation

enum ContactMock: DemureMockable {

    case contacts
    case create(name: String)
    case first
    case second
    case far(delay: Int)

    static let mocks: [ContactMock] = [
        .contacts,
        .create(name: "3"),
        .first,
        .second
    ]

    var request: RequestSpecification {
        switch self {
        case .contacts:
            return RequestSpecification(method: .GET, url: "/api/contacts")
        case .create:
            return RequestSpecification(method: .POST, url: "/api/contacts")
        case .first:
            return RequestSpecification(method: .GET, url: "/api/contacts/1")
        case .second:
            return RequestSpecification(method: .GET, url: "/api/contacts/2")
        case .far:
            return RequestSpecification(method: .GET, url: "/api/contacts/1000")
        }
    }

    var response: ResponseSpecification {
        switch self {
        case .contacts:
            return ResponseSpecification(status: 200, body: Data("all contacts".utf8))
        case .create(let name):
            return ResponseSpecification(status: 201, body: Data("new contact: \(name)".utf8))
        case .first:
            return ResponseSpecification(status: 200, body: Data("first contact".utf8))
        case .second:
            return ResponseSpecification(status: 200, body: Data("second contact".utf8), limit: 2)
        case .far(let delay):
            return ResponseSpecification(status: 200, body: Data("far contact".utf8), delay: delay)
        }
    }

    var item: ResponseStoreItem {
        ResponseStoreItem(pattern: request, mock: response)
    }
}
