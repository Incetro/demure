import DemureAPI

// MARK: - ResponseViewModel

struct ResponseViewModel: Encodable {

    // MARK: - Properties

    let status: Int
    let headers: [HeaderItemViewModel]
    let body: String?

    // MARK: - Initializers

    init(data: ResponseSpecification) {
        status = data.status
        headers = data.headers.map { HeaderItemViewModel($0) }.sorted()
        if let bodyData = data.body, !bodyData.isEmpty {
            body = String(data: bodyData, encoding: .utf8) ?? "[Some binary data]"
        } else {
            body = nil
        }
    }
}
