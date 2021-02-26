import DemureAPI

// MARK: - HeaderItemViewModel

struct HeaderItemViewModel: Encodable, Comparable {

    // MARK: - Initializers

    /// Current header key
    let key: String

    /// Current header value
    let value: String

    // MARK: - Initializers

    /// Pattern initializer
    /// - Parameter item: patter pair
    init(_ item: Dictionary<String, Pattern>.Element) {
        key = item.key
        value = item.value.value
    }

    /// String initializer
    /// - Parameter item: string pair
    init(_ item: Dictionary<String, String>.Element) {
        key = item.key
        value = item.value
    }

    // MARK: - Static
    
    static func < (lhs: HeaderItemViewModel, rhs: HeaderItemViewModel) -> Bool {
        lhs.key < rhs.key
    }
}
