//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

struct Application {

    static let app = Application()
    static let xcApp = XCUIApplication()

    enum Arguments: CustomStringConvertible {
        case uiTest
        case languages
        case languagesValue([String])
        case locale
        case localeValue(String)

        var description: String {
            switch self {
            case .uiTest: return "ui_testing"
            case .languages: return "-AppleLanguages"
            case .languagesValue(let values): return "(" + values.joined(separator: ",") + ")"
            case .locale: return "-AppleLocale"
            case .localeValue(let value): return value
            }
        }
    }

    static func launch(arguments: Arguments...) {
        xcApp.launchArguments = arguments.map { $0.description }
        xcApp.launch()
    }
    
}
