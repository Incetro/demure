//
//  File.swift
//  
//
//  Created by incetro on 2/24/21.
//

import Stencil
import PathKit
import Vapor

// MARK: - HTMLRender

final class HTMLRender {

    // MARK: - Properties

    private let environment: Stencil.Environment
    private let allocator: ByteBufferAllocator

    // MARK: - Initializers

    init(viewsDirectroy: String, allocator: ByteBufferAllocator) {
        let loader = FileSystemLoader(paths: [Path(viewsDirectroy)])
        self.environment = Environment(loader: loader)
        self.allocator = allocator
    }

    // MARK: - Useful

    func render(_ name: String, _ context: [String: Any]) throws -> View {
        let string = try environment.renderTemplate(name: name, context: context)
        var buffer = allocator.buffer(capacity: string.utf8.count)
        buffer.writeString(string)
        return View(data: buffer)
    }
}
