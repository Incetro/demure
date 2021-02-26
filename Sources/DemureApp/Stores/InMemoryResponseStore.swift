import DemureAPI
import Vapor
import NIO

// MARK: - MemoryResponseStore

final class MemoryResponseStore {

    // MARK: - Properties

    /// Currently stored reponse items
    private var inMemoryItems: [ResponseStoreItem] = []

    /// Current behaviour queue
    private let _queue = DispatchQueue(label: "com.incetro.demure.MemoryResponseStore")
}

// MARK: - ResponseStore

extension MemoryResponseStore: ResponseStore {

    var items: [ResponseStoreItem] {
        _queue.sync { inMemoryItems }
    }

    func response(for request: Request) -> EventLoopFuture<Response> {
        let item = _queue.sync { () -> ResponseStoreItem? in
            guard let index = inMemoryItems.firstIndex(where: { $0.match(request) }) else {
                return nil
            }
            let item = inMemoryItems[index].decremented()
            if !item.isValid {
                inMemoryItems.remove(at: index)
            }
            return item
        }

        let response = item?.response ?? Response(status: .notFound)

        if let delay = item?.mock.delay {
            let deadline = NIODeadline.now() + TimeAmount.seconds(Int64(delay))
            return request.eventLoop.scheduleTask(deadline: deadline, { response }).futureResult
        }
        return request.eventLoop.makeSucceededFuture(response)
    }

    func perform(_ action: DemureAction, for request: Request) -> EventLoopFuture<Response> {
        let status = _queue.sync { () -> HTTPStatus in
            switch action {
            case .update(let pattern, let mock):
                let item = ResponseStoreItem(pattern: pattern, mock: mock)
                if let index = inMemoryItems.firstIndex(where: { $0.pattern == pattern })  {
                    inMemoryItems[index] = item
                } else {
                    inMemoryItems.append(item)
                }
                return .created
            case .remove(let pattern):
                inMemoryItems.removeAll(where: { $0.pattern == pattern })
                return .noContent
            case .clear:
                inMemoryItems.removeAll(keepingCapacity: true)
                return .noContent
            }
        }
        return request.eventLoop.makeSucceededFuture(Response(status: status))
    }
}
