//
//  File.swift
//  
//
//  Created by incetro on 2/22/21.
//

import DemureAPI
import Vapor

// MARK: - AppConfigurator

final public class AppConfigurator {

    // MARK: - Initializers

    public init() {
    }

    // MARK: - Useful

    public func configure(_ app: Application, _ configuration: AppConfiguration) throws {
        app.routes.defaultMaxBodySize = ByteCount(stringLiteral: configuration.maxBodySize)
        let fileStore = FileResponseStore(directory: configuration.mocksDirectory)
        let inMemoryStore = MemoryResponseStore()
        app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
        switch configuration.mode {
        case .read:
            app.middleware.use(ArbitraryMiddleware.notFound(fileStore.response))
            app.middleware.use(ArbitraryMiddleware.notFound(inMemoryStore.response))
        case .write(let url):
            app.middleware.use(ArbitraryMiddleware.capture { request, response in
                let pattern = RequestSpecification(method: .init(request.method.rawValue), url: request.url.string)
                let mock = ResponseSpecification(status: Int(response.status.code), body: response.body.data)
                return fileStore.perform(.update(pattern, mock), for: request).map { _ in response }
            })
            app.middleware.use(RedirectMiddleware(serverURL: url))
        }
        let render = HTMLRender(
            viewsDirectroy: app.directory.viewsDirectory,
            allocator: app.allocator
        )
        app.group("demure") { demure in
            demure.get("github") { $0.redirect(to: "https://github.com/Incetro/synopsis") }
            demure.get { request in
                try render.render("index.html", ["page": PageViewModel(items: inMemoryStore.items)])
            }
            demure.group("api") { api in
                api.group("mocks") { mocks in
                    mocks.post { (request: Request) -> EventLoopFuture<Response> in
                        let action = try request.content.decode(DemureAction.self)
                        return inMemoryStore.perform(action, for: request)
                    }
                }
            }
        }
    }

}
