//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class ExampleMockServerTests: XCTestCase {

    private var server: MockServer!
    private var serverTestID: String = ""
    private var currentTestName: String {
        return invocation?.selector.description ?? UUID().uuidString
    }

    override func setUp() {
        super.setUp()
        serverTestID = "\(currentTestName)_\(UUID().uuidString)"
        server = MockServer(address: "http://0.0.0.0:4567", testID: serverTestID)
        server.startTest()
        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()
        server.stopTest()
    }

    func x_test_example() {
        server.mockFromArchive(HarArchive(fixtureName: "<YOUR HAR FILENAME>",
                                          subdirectory: nil,
                                          bundle: Bundle(for: type(of: self)))!)
        Application.launch(arguments: .serverAddress, .serverAddressValue(server.address),
                           .testID, .testIDValue(serverTestID))

        // do your normal UI testing here
    }

}
