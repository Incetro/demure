//
//  File.swift
//  
//
//  Created by incetro on 2/22/21.
//

import DemureApp
import Vapor

// MARK: - Runner

final public class Runner {

    // MARK: - Properties

    private let configurator = AppConfigurator()

    // MARK: - Run

    func run() throws {
        var env = try Environment.detect()
        let config = try AppConfiguration.obtain()
        try LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
        defer { app.shutdown() }
        try configurator.configure(app, config)
        try app.run()
    }
}
