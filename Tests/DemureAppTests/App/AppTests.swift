import DemureAPI
import DemureApp
import XCTVapor

// MARK: - AppTests

final class AppTests: AppTestCase {

    func testReadFileMock() throws {
        try app.test(.GET, "/api/contacts/1", afterResponse: { response in
            XCTAssertEqual(response.status.code, 200)
            XCTAssertEqual(response.body.string, "first contact\n")
        })
    }

    func testWriteFileMock() throws {

        /// given

        let api = TodoAPI()
        XCTAssertNoThrow(
            try setUpApp(mode: .write(api.host)),
            "Launch the app in redirect mode to \(api.host) and write files to a folder \(mocksDirectory)"
        )
        addTeardownBlock {
            let path = self.mocksDirectory + api.root
            XCTAssertNotNil(
                try! FileManager.default.removeItem(atPath: path),
                "Remove created files and directories at \(path)"
            )
        }

        /// when

        for todo in api.todos {
            try app.test(.GET, todo.path, headers: api.headers, afterResponse: { response in
                XCTAssertEqual(response.status.code, 200)
                XCTAssertEqual(
                    try response.content.decode(TodoAPI.Todo.self).title,
                    todo.title,
                    "Returned the todo by index \(todo.id)"
                )
            })
        }

        /// then

        for todo in api.todos {
            let path = mocksDirectory + todo.path
            let data = try String(contentsOfFile: path).data(using: .utf8).unwrap()
            let decoded = try JSONDecoder().decode(TodoAPI.Todo.self, from: data)
            XCTAssertEqual(
                decoded.title,
                todo.title,
                "The todo by \(todo.id) was saved to a file at path \(path)"
            )
        }
    }

    func testAddMock() throws {

        /// given

        let mock = ResponseSpecification(status: 300, headers: ["X": "Y"], body: Data("hello".utf8))
        let request = RequestSpecification(method: .GET, url: "/contacts", headers: ["X-Test": "1"])

        /// when

        try app.perform(.update(request, mock))

        /// then

        try app.test(.GET, "/contacts", afterResponse: { response in
            XCTAssertEqual(response.status, .notFound, "Missing header")
        })
        try app.test(.POST, "/contacts", afterResponse: { response in
            XCTAssertEqual(response.status, .notFound, "Not correct method")
        })
        try app.test(.GET, "/contacts", headers: ["X-Test": "1"], afterResponse: { response in
            XCTAssertEqual(response.status.code, 300)
            XCTAssertEqual(response.headers.first(name: "X"), "Y")
            XCTAssertEqual(response.body.string, "hello")
        })
    }

    func testAddMockOverStaticFile() throws {

        /// given

        let mock = ResponseSpecification(status: 200, body: Data("dynamic mock".utf8))
        let request = RequestSpecification(method: .GET, url: "/api/contacts/1")

        try app.test(.GET, "/api/contacts/1", afterResponse: { response in
            XCTAssertEqual(response.status.code, 200)
            XCTAssertEqual(response.body.string, "first contact\n")
        })

        /// when

        try app.perform(.update(request, mock))

        /// then

        try app.test(.GET, "/api/contacts/1", afterResponse: { response in
            XCTAssertEqual(response.status.code, 200)
            XCTAssertEqual(response.body.string, "dynamic mock")
        })
    }

    func testUpdateMock() throws {

        /// given

        var mock = ResponseSpecification(status: 200, body: Data("first".utf8))
        let request = RequestSpecification(method: .GET, url: "/contacts/2")
        try app.perform(.update(request, mock))

        /// when

        mock.body = Data("second".utf8)
        try app.perform(.update(request, mock))

        /// then

        try app.test(.GET, "/contacts/2", headers: ["X-Test": "1"], afterResponse: { response in
            XCTAssertEqual(response.status.code, 200)
            XCTAssertEqual(response.body.string, "second", "Updated body")
        })
    }

    func testRemoveMock() throws {

        /// given

        let mock = ResponseSpecification(body: Data("John".utf8))
        let request = RequestSpecification(method: .GET, url: "api/users/1")
        try app.perform(.update(request, mock))

        /// when

        try app.perform(.remove(request))

        /// then

        try app.test(.POST, "api/users/1", afterResponse: { response in
            XCTAssertEqual(response.status, .notFound, "Mock not found")
        })
    }

    func testRemoveAllMocks() throws {

        /// given

        let mock = ResponseSpecification(body: Data("Kid".utf8))
        try app.perform(.update(RequestSpecification(method: .GET, url: "/users/1"), mock))
        try app.perform(.update(RequestSpecification(method: .GET, url: "/users/2"), mock))
        try app.perform(.update(RequestSpecification(method: .GET, url: "/users/3"), mock))

        /// when

        try app.perform(.clear)

        /// then

        try app.test(.POST, "/users/1", afterResponse: { response in
            XCTAssertEqual(response.status, .notFound, "Mock not found")
        })
        try app.test(.POST, "/users/2", afterResponse: { response in
            XCTAssertEqual(response.status, .notFound, "Mock not found")
        })
        try app.test(.POST, "/users/3", afterResponse: { response in
            XCTAssertEqual(response.status, .notFound, "Mock not found")
        })
    }
}
