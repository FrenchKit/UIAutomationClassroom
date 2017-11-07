//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

struct ItemScreen {

    static let app = Application.xcApp
    let title = app.staticTexts["Item"]

    func header(itemNumber: Int) -> XCUIElement {
        return ItemScreen.app.staticTexts["Item #\(itemNumber)"]
    }
}
