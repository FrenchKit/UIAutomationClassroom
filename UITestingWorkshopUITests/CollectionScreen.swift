//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

struct CollectionScreen {

    struct Cell {
        var element: XCUIElement
        var image: XCUIElement
        var title: String
        var price: String
    }

    static let app = Application.xcApp
    let collection = app.collectionViews["collection"]
    var cells: [Cell] {
        let cells = collection.cells.allElementsBoundByIndex
            .filter {
                // when a collection item is partly visible the static texts are not accessible to XCTest
                // hence the staticTexts["name"] fails to find the name element.
                $0.images.count > 0 &&
                $0.staticTexts.count == 2
            }.map { element in
                Cell(element: element,
                     image: element.images.element,
                     title: element.staticTexts["name"].label,
                     price: element.staticTexts["price"].label)
        }
        return cells
    }
    
}
