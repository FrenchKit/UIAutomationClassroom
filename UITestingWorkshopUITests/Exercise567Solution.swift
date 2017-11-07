//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class Exercise567Solution: XCTestCase {

    let app = Application.xcApp
    let mainScreen = MainScreen()
    let tableScreen = TableScreen()
    let itemScreen = ItemScreen()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        Application.launch()
    }

    override func tearDown() {
        super.tearDown()
        // here you can reset your changes, for example, logout the current user.
    }

    func test_whenTableOpened_itHasItems() {
        mainScreen.showTableButton.tap()

        XCTAssertFalse(tableScreen.cells.isEmpty)
    }

    func test_whenTableItemOpened_detailsHasInformation() {
        mainScreen.showTableButton.tap()
        let cells = tableScreen.cells

        cells.first?.element.tap()

        waitUntil(itemScreen.title, is: .exists)
        XCTAssertExist(itemScreen.header(itemNumber: 1))
    }

    // TODO: STEP 6: extract the following steps into a separate test method
    func test_secondTabScreen() {
        Application.app.secondTab.tap()
        waitUntil(Application.app.secondTabText, is: .exists)
    }
    
}
