//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class Exercise567: XCTestCase {

    let app = Application.xcApp
    let mainScreen = MainScreen()
    let tableScreen = TableScreen()
    let itemScreen = ItemScreen()
//    let otherTabScreen = OtherTabScreen()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        Application.launch()
    }

    override func tearDown() {
        super.tearDown()
        // here you can reset your changes, for example, logout the current user.
    }

    func test_allInOne() {
        mainScreen.showTableButton.tap()

        let cell = app.tables["table"].cells.allElementsBoundByIndex.first

        cell?.tap()

        waitUntil(app.staticTexts["Item"], is: .exists)

        // TODO: STEP 5: Introduce a bug in the app that breaks this test
        XCTAssertExist(app.staticTexts["Item #1"])

        app.buttons["Back"].tap()
        waitUntil(app.staticTexts["Table"], is: .exists)

        app.buttons["Back"].tap()
        waitUntil(app.staticTexts["First Tab"], is: .exists)

        // TODO: STEP 6: extract the following steps into a separate test method
        app.buttons["Second"].tap()
        waitUntil(app.staticTexts["Second Tab"], is: .exists)

        XCTAssertExist(app.staticTexts["OTHER TAB"])
    }

    // TODO: STEP 7: refactor the code using screen objects.

}
