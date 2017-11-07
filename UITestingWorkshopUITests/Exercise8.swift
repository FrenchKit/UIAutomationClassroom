//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class Exercise8: XCTestCase {

    let mainScreen = MainScreen()

    override func setUp() {
        super.setUp()
        // TODO: STEP 8: Write a test that expects seeing a 🇫🇷 emoji on the main screen
        // TODO: modify the app so that it displays a French flag when uiTest flag is passed to it.
        Application.launch(arguments: .uiTest,
                           .languages, .languagesValue(["en", "fr"]),
                           .locale, .localeValue("fr_FR"))
    }

}
