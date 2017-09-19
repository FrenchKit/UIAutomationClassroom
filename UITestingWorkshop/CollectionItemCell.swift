//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

class CollectionItemCell: UICollectionViewCell, UIAccessibleContainer {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        itemImageView.accessibilityIdentifier = "image"
        itemNameLabel.accessibilityIdentifier = "name"
        itemPriceLabel.accessibilityIdentifier = "price"
        accessibilityElements = [itemImageView, itemNameLabel, itemPriceLabel]
    }

    func configure(_ item: CollectionItem) {
        itemImageView.image = UIImage(named: item.imageName)
        itemNameLabel.text = item.name
        itemPriceLabel.text = item.price
    }

    override func accessibilityElementCount() -> Int {
        return accessibilityCount()
    }

    override func index(ofAccessibilityElement element: Any) -> Int {
        return indexOfAccessibilityElement(element)
    }

    override func accessibilityElement(at index: Int) -> Any? {
        return accessibilityElementAtIndex(index)
    }
    
}
