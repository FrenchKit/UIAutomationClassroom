//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class Exercise4Solution: XCTestCase {

    let main = MainScreen()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["ui_testing"]
        app.launch()
    }

    func test_customAssertions() {
        XCTAssertExist(main.testingLabel)
        XCTAssertExist(main.showTableButton)
        XCTAssertHittable(main.showCollectionButton)
        XCTAssertNotHittable(main.testingLabel)
    }

    // TODO: STEP 4: write a test method that asserts that second tab button is hittable after app enters collection view.
    func testTabBarButtonHittable() {
        main.showCollectionButton.tap()
        XCTAssertHittable(Application.app.secondTab)
    }

}
