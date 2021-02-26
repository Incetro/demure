import DemureAPI

// MARK: - PatternViewModel

struct PatternViewModel: Encodable {

    // MARK: - Properties

    let id: Int
    let method: String
    let url: String
    let headers: [HeaderItemViewModel]
    let response: ResponseViewModel

    // MARK: - Initializers

    init(id: Int, request: RequestSpecification, response: ResponseSpecification) {
        self.id = id
        method = request.method.rawValue
        url = request.url.value
        headers = request.headers.map { HeaderItemViewModel($0) }.sorted()
        self.response = ResponseViewModel(data: response)
    }
}
