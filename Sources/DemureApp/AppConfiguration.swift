import DemureAPI
import Foundation

// MARK: - AppConfiguration

/// Application configuration
public struct AppConfiguration {

    // MARK: - Properties

    /// Application work mode
    public enum Mode: Equatable {
        case write(URL)
        case read
    }

    /// Application work mode
    public let mode: Mode

    /// The directory with mocks
    public let mocksDirectory: URL

    public let maxBodySize: String

    // MARK: - Static

    public static let defaultMaxBodySize = "50mb"

    /// Source directory path
    public static var sourceDir: String {
        #file.components(separatedBy: "/Sources")[0]
    }

    /// Detect application configuration.
    public static func obtain(
        from enviroment: [String: String] = ProcessInfo.processInfo.environment
    ) throws -> AppConfiguration {

        let mocksDirectory = try { () throws -> URL in
            let path = enviroment["DEMURE_MOCKS_DIR", default: sourceDir]
            let url = URL(string: path).unwrap("Invalid URL DEMURE_MOCKS_DIR=\(path)")
            return url
        }()

        let maxBodySize = enviroment["DEMURE_MAX_BODY_SIZE", default: defaultMaxBodySize]

        if
            let path = enviroment["DEMURE_PROXY_URL"],
            let url = URL(string: path)
        {
            return AppConfiguration(
                mode: .write(url),
                mocksDirectory: mocksDirectory,
                maxBodySize: maxBodySize
            )
        }
        return AppConfiguration(
            mode: .read,
            mocksDirectory: mocksDirectory,
            maxBodySize: maxBodySize
        )
    }
}
