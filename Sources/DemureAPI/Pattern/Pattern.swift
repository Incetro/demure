import Foundation

// MARK: - Pattern

/// The kind of pattern for matching request fields such as url and headers
public struct Pattern: Codable, Hashable {
    
    // MARK: - Kind

    /// Matching kind
    public enum Kind: String, Codable {

        /// checks for equality
        case equal

        /// checks for wildcard pattern
        case wildcard

        /// checks for regexp pattern
        case regexp
    }

    // MARK: - Properties

    /// Matching kind
    public let kind: Kind

    /// Matching value
    public let value: String

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - kind: matching kind
    ///   - value: matching value
    public init(kind: Kind, value: String) {
        self.kind = kind
        self.value = value
    }

    // MARK: - Static

    /// Returns instance with 'equal' pattern
    /// - Parameter value: mathcing value
    /// - Returns: instance with 'equal' pattern
    public static func equal(_ value: String) -> Pattern {
        Pattern(kind: .equal, value: value)
    }

    /// Returns instance with 'wildcard' pattern
    /// - Parameter value: mathcing value
    /// - Returns: instance with 'wildcard' pattern
    public static func wildcard(_ value: String) -> Pattern {
        Pattern(kind: .wildcard, value: value)
    }

    /// Returns instance with 'regexp' pattern
    /// - Parameter value: mathcing value
    /// - Returns: instance with 'regexp' pattern
    public static func regexp(_ value: String) -> Pattern {
        Pattern(kind: .regexp, value: value)
    }
}
