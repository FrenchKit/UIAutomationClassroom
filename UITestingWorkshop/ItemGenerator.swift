//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

class ItemGenerator {

    static let imageNamePool = ["ic-1", "ic-2", "ic-3", "ic-4", "ic-5"]
    static let itemCount = 50
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()

    static func generate() -> [TableItem] {
        return (0..<itemCount).map { index in
            TableItem(title: "Item #\(index + 1)",
                imageName: randomImageName())
        }
    }

    private static func randomImageName() -> String {
        return imageNamePool[Int(arc4random_uniform(UInt32(imageNamePool.count)))]
    }

    static func generate() -> [CollectionItem] {
        return (0..<itemCount).map { index in
            CollectionItem(name: "Item #\(index + 1)",
                imageName: randomImageName(),
                price: randomPrice())
        }
    }

    private static func randomPrice() -> String {
        let minPriceCents = 1 * 100
        let priceRangeCents: UInt32 = 100 * 100
        let priceCents = minPriceCents + Int(arc4random_uniform(priceRangeCents))
        let price: NSDecimalNumber = NSDecimalNumber(decimal: Decimal(floatLiteral: Double(priceCents) / 100.0))
        return priceFormatter.string(from: price) ?? "1.00"
    }
    
}
