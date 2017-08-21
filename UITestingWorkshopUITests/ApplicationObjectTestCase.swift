//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class ApplicationObjectTestCase: XCTestCase {

    let mainScreen = MainScreen()

    override func setUp() {
        super.setUp()
        Application.launch(arguments: .uiTest,
                           .languages, .languagesValue(["en", "fr"]),
                           .locale, .localeValue("fr_FR"))
    }

    func test_empty() {
        XCTAssertTrue(mainScreen.testingLabel.exists)
    }

}
