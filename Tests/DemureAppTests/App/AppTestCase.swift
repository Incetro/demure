@testable import DemureApp
import XCTVapor

// MARK: - AppTestCase

class AppTestCase: XCTestCase {

    // MARK: - Properties

    let configurator = AppConfigurator()
    let mocksDirectory = AppConfiguration.sourceDir + "/Tests/DemureAppTests/Files"

    private(set) var app = Application(.testing) {
        willSet { app.shutdown() }
    }

    // MARK: - Useful

    func setUpApp(mode: AppConfiguration.Mode) throws {
        let config = AppConfiguration(
            mode: mode,
            mocksDirectory: URL(string: mocksDirectory).unwrap(),
            maxBodySize: "50kb"
        )
        app = Application(.testing)
        try configurator.configure(app, config)
    }

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try setUpApp(mode: .read))
        XCTAssertEqual(app.routes.defaultMaxBodySize, 51200)
    }

    override func tearDown() {
        app.shutdown()
        super.tearDown()
    }
}

// MARK: - RequestTestCase

class RequestTestCase: AppTestCase {
    private(set) lazy var request = Request(application: app, on: app.eventLoopGroup.next())
}
