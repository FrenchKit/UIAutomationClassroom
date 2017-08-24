//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

extension XCUIElementQuery {

    func anyElement(identifier: String) -> XCUIElement {
        return XCUIApplication().descendants(matching: .any).element(matching: .any, identifier: identifier)
    }
    
}
