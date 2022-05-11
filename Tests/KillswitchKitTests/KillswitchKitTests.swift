import XCTest
@testable import KillswitchKit

final class KillswitchKitTests: XCTestCase {
    func testUrlQueryBuild() {
        let service = KillSwitchApiService()
        
        guard let url = service.buildUrlQuery(from: "someurl.com", scheme: "http", path: "path", parameters: ["123":"456"]) else {
            XCTFail()
            return
        }

        XCTAssertEqual(url.absoluteString, "http://someurl.com/path?123=456")
    }
}
