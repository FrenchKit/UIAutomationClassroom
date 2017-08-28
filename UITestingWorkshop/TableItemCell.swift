//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

protocol TableItemCellDelegate: class {
    func tableItemCellMoreInfo(_ cell: TableItemCell)
}

class TableItemCell: UITableViewCell, UIAccessibleContainer {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemButton: UIButton!
    weak var delegate: TableItemCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        itemImageView.accessibilityIdentifier = "image"
        itemTitle.accessibilityIdentifier = "title"
        itemButton.accessibilityIdentifier = "button"
        accessibilityElements = [itemImageView, itemTitle, itemButton]
    }

    func configure(_ item: TableItem) {
        itemImageView.image = UIImage(named: item.imageName)
        itemTitle.text = item.title
    }

    @IBAction
    func moreInfo(_ sender: Any) {
        delegate?.tableItemCellMoreInfo(self)
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
