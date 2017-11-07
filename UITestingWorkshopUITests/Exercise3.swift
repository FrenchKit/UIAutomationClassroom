//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class Exercise3: XCTestCase {

    let main = MainScreen()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["ui_testing"]
        app.launch()
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

    // TODO: STEP 3: write a test method that opens collection view screen
    func test_openingCollectionView() {
    }

}
