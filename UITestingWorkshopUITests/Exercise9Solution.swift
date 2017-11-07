//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class Exercise9Solution: XCTestCase {

    let mainScreen = MainScreen()
    let tableScreen = TableScreen()
    let collectionScreen = CollectionScreen()

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

    // TODO: STEP 9: write a test that opens collection view screen and scrolls till 10th item
    func test_scrollCollectionView() {
        mainScreen.showCollectionButton.tap()
        waitUntil(collectionScreen.collection, is: .exists)

        func cell(at index: Int) -> CollectionScreen.Cell? {
            return collectionScreen.cells.first(where: { $0.element.identifier == "cell\(index)" })
        }
        let offset = 10
        var collectionCell: CollectionScreen.Cell? = cell(at: offset)
        let maxRepeatCount = 50
        var repeatCount = 0
        while repeatCount < maxRepeatCount && collectionCell == nil {
            collectionScreen.collection.swipeUp()
            collectionCell = cell(at: offset)
            repeatCount += 1
        }
        XCTAssertEqual(collectionCell?.title, "Item #11")
    }
}
