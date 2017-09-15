//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class BasicAssertions: XCTestCase {

    let main = MainScreen()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["ui_testing"]
        app.launch()
    }

    func test_standardAssertions() {
        XCTAssertTrue(main.testingLabel.exists)
        XCTAssertEqual(main.showTableButton.label, "Show TableView")
        XCTAssertNotEqual(main.showCollectionButton.value as? String, "")
        // TODO: assert that testing label's text is "UI test in progress"
    }

    func test_waitAssertions() {
        main.showTableButton.tap()
        waitUntil(Application.xcApp.tables["table"], is: .exists)
        // doesNotExist
        // selected
        // hittable
        // notHittable
        // waitUntilTrue(main.testingLabel.label == "Not testing", 2)
    }

    // TODO: write a test method that opens collection view screen

    func test_customAssertions() {
        XCTAssertNotExist(main.testingLabel)
        XCTAssertExist(main.showTableButton)
        XCTAssertHittable(main.showCollectionButton)
        XCTAssertNotHittable(main.testingLabel)
    }

    // TODO: write a test method that asserts that second tab button is hittable after app enters collection view.

}
