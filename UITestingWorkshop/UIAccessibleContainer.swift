//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

protocol UIAccessibleContainer {

    func accessibilityCount() -> Int
    func indexOfAccessibilityElement(_ element: Any) -> Int
    func accessibilityElementAtIndex(_ index: Int) -> Any?

}

extension UIAccessibleContainer where Self: UIView {

    func accessibilityCount() -> Int {
        return accessibilityElements?.count ?? 0
    }

    func indexOfAccessibilityElement(_ element: Any) -> Int {
        return (accessibilityElements as NSArray?)?.index(of: element) ?? NSNotFound
    }

    func accessibilityElementAtIndex(_ index: Int) -> Any? {
        return accessibilityElements?[index]
    }

}
