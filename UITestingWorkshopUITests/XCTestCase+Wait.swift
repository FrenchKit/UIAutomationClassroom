//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

extension XCTestCase {

    func waitUntilTrue(_ condition: @autoclosure () -> Bool,
                       _ timeout: TimeInterval = 1,
                       file: String = #file,
                       line: UInt = #line) {
        var time: TimeInterval = 0
        let step: TimeInterval = 0.1
        let loop = RunLoop.current
        var result = condition()
        while !result && time < timeout {
            loop.run(until: Date().addingTimeInterval(step))
            time += step
            result = condition()
        }
        if !result {
            recordFailure(withDescription: "Waiting failed", inFile: file, atLine: line, expected: true)
        }
    }

    func waitUntil(_ element: XCUIElement,
                   _ timeout: TimeInterval = 15,
                   _ file: String = #file,
                   _ line: UInt = #line,
                   `is` conditions: Predicate ...) {
        let predicate = NSPredicate(format: conditions.map { $0.rawValue }.joined(separator: " AND "))
        let expectation = self.expectation(for: predicate, evaluatedWith: element, handler: nil)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        switch result {
        case .completed:
            return
        default:
            recordFailure(withDescription: "Conditions \(predicate) failed for \(element) after \(timeout) seconds",
                inFile: file, atLine: line, expected: true)
        }
    }
}

enum Predicate: String {
    case exists = "exists == true"
    case doesNotExist = "self.exists == false"
    case selected = "isSelected == true"
    case hittable = "isHittable == true"
    case notHittable = "isHittable == false"
}
