//
//  File.swift
//  
//
//  Created by incetro on 2/22/21.
//

import Foundation

// MARK: - HTTPMethod

public struct HTTPMethod: RawRepresentable, Hashable, Codable {

    // MARK: - Properties

    /// HTTP method string value
    public let rawValue: String

    // MARK: - Initializers

    /// Default initializer
    /// - Parameter rawValue: HTTP method string value
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: - Static

    public static let GET    = HTTPMethod("GET")
    public static let PUT    = HTTPMethod("PUT")
    public static let POST   = HTTPMethod("POST")
    public static let PATCH  = HTTPMethod("PATCH")
    public static let DELETE = HTTPMethod("DELETE")
}

// MARK: - ExpressibleByStringLiteral

extension HTTPMethod: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

// MARK: - LosslessStringConvertible

extension HTTPMethod: LosslessStringConvertible {

    public var description: String { rawValue }

    public init(_ description: String) {
        self.rawValue = description
    }
}
