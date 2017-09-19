//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

class LocalizationExample: XCTestCase {

    let mainScreen = MainScreen()
    let languageCode = "fr"
    let locale = "fr_FR"
    var bundle: Bundle!

    override func setUp() {
        super.setUp()
        bundle = localizationBundle()
        Application.launch(arguments: .languages, .languagesValue([languageCode]),
                           .locale, .localeValue(locale),
                           .uiTest)
    }

    func test_localizedValues() {
        XCTAssertEqual(mainScreen.showTableButton.label, XCLocalizedString("main.table.button"))
        XCTAssertEqual(mainScreen.showCollectionButton.label, XCLocalizedString("main.collection.button"))
        XCTAssertEqual(mainScreen.testingLabel.label, XCLocalizedString("main.testing"))
    }

    // TODO: STEP 10: write a test method that asserts second tab's text is in French
    func test_tabText() {
        Application.app.secondTab.tap()
        XCTAssertEqual(Application.xcApp.navigationBars.staticTexts.element.label, XCLocalizedString("tab.second"))
    }
}

extension LocalizationExample {

    func XCLocalizedString(_ key: String) -> String {
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }

    func localizationBundle() -> Bundle {
        let testBundle = Bundle(for: type(of: self))
        let localizedBundle: Bundle
        if let path = testBundle.path(forResource: languageCode, ofType: "lproj"), let bundle = Bundle(path: path) {
            localizedBundle = bundle
        } else {
            localizedBundle = testBundle
        }
        return localizedBundle
    }

}
