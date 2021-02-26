//
//  File.swift
//  
//
//  Created by incetro on 2/22/21.
//

import Foundation

// MARK: - DemureMockable

public protocol DemureMockable {

    /// HTTP request specification
    var request: RequestSpecification { get }

    /// HTTP response mock
    var response: ResponseSpecification { get }
}
