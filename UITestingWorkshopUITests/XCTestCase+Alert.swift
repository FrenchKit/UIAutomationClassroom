//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

extension XCTestCase {

    func configureToCancelAllAlerts() {
        addUIInterruptionMonitor(withDescription: "Alert", handler: { alert in
            alert.tap()
            let allowButton = alert.buttons["Allow"]
            let cancelButton = alert.buttons["Cancel"]
            if allowButton.exists {
                allowButton.tap()
                return true
            } else if cancelButton.exists {
                cancelButton.tap()
                return true
            }
            return false
        })
    }

}
