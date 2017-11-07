//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class Exercise2: XCTestCase {

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
        // TODO: STEP 2: assert that testing label's text is "UI test in progress"
        XCTAssertEqual(main.testingLabel.label, "UI test in progress")
    }

}
