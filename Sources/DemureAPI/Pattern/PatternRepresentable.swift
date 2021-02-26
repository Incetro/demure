//
//  File.swift
//  
//
//  Created by incetro on 2/22/21.
//

import Foundation

// MARK: - PatternRepresentable

public protocol PatternRepresentable {
    var pattern: Pattern { get }
}

// MARK: - Pattern

extension Pattern: PatternRepresentable {
    public var pattern: Pattern { self }
}

// MARK: - String

extension String: PatternRepresentable {
    public var pattern: Pattern { .equal(self) }
}

// MARK: - URL

extension URL: PatternRepresentable {
    public var pattern: Pattern { .equal(absoluteString) }
}
