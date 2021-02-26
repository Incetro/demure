import struct DemureAPI.Pattern
import XCTest

// MARK: - PatternTests

final class PatternTests: XCTestCase {

    // MARK: - JSON
    
    private enum JSON: String {

        case equal    = #"{"kind":"equal","value":"some"}"#
        case wildcard = #"{"kind":"wildcard","value":"some*"}"#
        case regexp   = #"{"kind":"regexp","value":"^some$"}"#

        var data: Data { Data(rawValue.utf8) }
    }

    // MARK: - Tests
    
    func testEncodingEqual() throws {
        let pattern = Pattern.equal("some")
        let data = try JSONEncoder().encode(pattern)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, JSON.equal.rawValue)
    }
    
    func testEncodingWildcard() throws {
        let pattern = Pattern.wildcard("some*")
        let data = try JSONEncoder().encode(pattern)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, JSON.wildcard.rawValue)
    }
    
    func testEncodingRegexp() throws {
        let pattern = Pattern.regexp("^some$")
        let data = try JSONEncoder().encode(pattern)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, JSON.regexp.rawValue)
    }
    
    func testDecodingEqual() throws {
        let data = JSON.equal.data
        let pattern = try JSONDecoder().decode(Pattern.self, from: data)
        let reference = Pattern.equal("some")
        XCTAssertEqual(pattern, reference)
    }
    
    func testDecodingWildcard() throws {
        let data = JSON.wildcard.data
        let pattern = try JSONDecoder().decode(Pattern.self, from: data)
        let reference = Pattern.wildcard("some*")
        XCTAssertEqual(pattern, reference)
    }
    
    func testDecodingRegexp() throws {
        let data = JSON.regexp.data
        let pattern = try JSONDecoder().decode(Pattern.self, from: data)
        let reference = Pattern.regexp("^some$")
        XCTAssertEqual(pattern, reference)
    }
}
