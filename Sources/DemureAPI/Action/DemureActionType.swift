//
//  File.swift
//  
//
//  Created by incetro on 2/22/21.
//

import Foundation

// MARK: - DemureActionType

enum DemureActionType: String, Codable {
    case update
    case remove
    case removeAll
}

// MARK: - Codable

extension DemureAction: Codable {

    enum CondingKeys: String, CodingKey {
        case type
        case pattern
        case response
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CondingKeys.self)
        let type = try container.decode(DemureActionType.self, forKey: .type)
        switch type {
        case .update:
            let response = try container.decode(ResponseSpecification.self, forKey: .response)
            let request = try container.decode(RequestSpecification.self, forKey: .pattern)
            self = .update(request, response)
        case .remove:
            let request = try container.decode(RequestSpecification.self, forKey: .pattern)
            self = .remove(request)
        case .removeAll:
            self = .clear
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CondingKeys.self)
        switch self {
        case .update(let pattern, let response):
            try container.encode(pattern, forKey: .pattern)
            try container.encode(response, forKey: .response)
            try container.encode(DemureActionType.update, forKey: .type)
        case .remove(let pattern):
            try container.encode(DemureActionType.remove, forKey: .type)
            try container.encode(pattern, forKey: .pattern)
        case .clear:
            try container.encode(DemureActionType.removeAll, forKey: .type)
        }
    }
}
