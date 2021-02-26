import DemureAPI

// MARK: - PageViewModel

struct PageViewModel: Encodable {

    // MARK: - Properties

    let patterns: [PatternViewModel]

    // MARK: - Initializers

    init(items: [ResponseStoreItem]) {
        patterns = items.enumerated().map { id, item in
            PatternViewModel(id: id, request: item.pattern, response: item.mock)
        }
    }
}
