//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

struct TableScreen {

    struct Cell {
        var element: XCUIElement
        var image: XCUIElement
        var title: String
        var button: XCUIElement
    }

    static let app = Application.xcApp
    let table = app.tables["table"]
    var cells: [Cell] {
        let cells = table.cells.allElementsBoundByIndex.map { element in
            Cell(element: element,
                 image: element.images.element,
                 title: element.staticTexts["title"].label,
                 button: element.buttons["button"])
        }
        return cells
    }

}
