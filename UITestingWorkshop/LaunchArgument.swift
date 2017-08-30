//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public struct LaunchArgument {

    public static let mockServerAddress = "-serverAddress"
    public static let uiTestArgument = "-testID"

    public static var serverAddress: String? {
        return nextArgumentAfter(LaunchArgument.mockServerAddress)
    }

    private static func nextArgumentAfter(_ argument: String) -> String? {
        let arguments = ProcessInfo.processInfo.arguments
        if let argumentIndex = arguments.index(of: argument) {
            let nextArgumentIndex = argumentIndex + 1
            assert(nextArgumentIndex < arguments.count)
            return arguments[nextArgumentIndex]
        }
        return nil
    }

    public static var uiTestID: String? {
        return nextArgumentAfter(LaunchArgument.uiTestArgument)
    }
    
}
