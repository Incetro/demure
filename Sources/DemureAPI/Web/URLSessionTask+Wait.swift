import Foundation

// MARK: - URLSessionTask

extension URLSessionTask {

    /// Wait for task completion
    func wait() {
        guard let timeout = currentRequest?.timeoutInterval else { return }
        let limitDate = Date(timeInterval: timeout, since: Date())
        while state == .running && RunLoop.current.run(mode: .default, before: limitDate) {}
    }
}
