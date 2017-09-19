//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class ScrollTillVisibleTests: XCTestCase {

    let mainScreen = MainScreen()
    let tableScreen = TableScreen()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        Application.launch()
    }

    func test_scroll20Elements() {
        mainScreen.showTableButton.tap()
        waitUntil(tableScreen.table, is: .exists)

        func cell(at index: Int) -> TableScreen.Cell? {
            return tableScreen.cells.first(where: { $0.element.identifier == "cell\(index)" })
        }
        let offset = 20
        var tableCell: TableScreen.Cell? = cell(at: offset)
        let maxRepeatCount = 50
        var repeatCount = 0
        while repeatCount < maxRepeatCount && (tableCell == nil || !tableCell!.button.isHittable) {
            tableScreen.table.swipeUp()
            tableCell = cell(at: offset)
            repeatCount += 1
        }
        XCTAssertEqual(tableCell?.title, "Item #21")
    }

    // TODO: STEP 9: write a test that opens collection view screen and scrolls till 11th item

}
