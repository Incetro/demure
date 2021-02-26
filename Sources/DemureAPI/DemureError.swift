import Foundation

// MARK: - DemureError

public struct DemureError: LocalizedError, CustomNSError {

    // MARK: - Properties

    /// Error domani
    public static var errorDomain = "com.incetro.demure.Error"

    /// HTTP status code
    public let errorCode: Int

    /// Reason of the failure
    public let failureReason: String?

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - response: network response
    ///   - data: result data
    init?(response: HTTPURLResponse, data: Data?) {
        guard !(200..<300).contains(response.statusCode) else { return nil }
        errorCode = response.statusCode
        failureReason = data.flatMap { (body: Data) in
            try? JSONDecoder().decode(ErrorResponse.self, from: body).reason
        }
    }

    // MARK: - Public

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        HTTPURLResponse.localizedString(forStatusCode: errorCode)
    }

    /// User-info dictionary
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        userInfo[NSLocalizedFailureReasonErrorKey] = failureReason
        return userInfo
    }
}

// MARK: - ErrorResponse

private struct ErrorResponse: Codable {

    /// Always `true` to indicate this is a non-typical JSON response.
    let error: Bool

    /// The reason for the error.
    let reason: String
}
