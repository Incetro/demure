@testable import DemureApp
import XCTest

// MARK: - AppConfigurationTests

final class AppConfigurationTests: XCTestCase {

    // MARK: - Tests

    func testRead() throws {
        let config = try AppConfiguration.obtain(from: [:])
        XCTAssertEqual(config.mode, .read)
        XCTAssertEqual(config.mocksDirectory.absoluteString, AppConfiguration.sourceDir)
        XCTAssertEqual(config.maxBodySize, AppConfiguration.defaultMaxBodySize)
    }

    func testWrite() throws {
        let maxBodySize = "1kb"
        let config = try AppConfiguration.obtain(from: [
            "DEMURE_PROXY_URL": "/",
            "DEMURE_MAX_BODY_SIZE": maxBodySize
        ])
        XCTAssertEqual(config.mode, .write(URL(string: "/").unwrap()))
        XCTAssertEqual(config.mocksDirectory.absoluteString, AppConfiguration.sourceDir)
        XCTAssertEqual(config.maxBodySize, maxBodySize)
    }

}
