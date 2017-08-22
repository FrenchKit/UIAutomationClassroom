//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

protocol TableItemCellDelegate: class {
    func tableItemCellMoreInfo(_ cell: TableItemCell)
}

class TableItemCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemButton: UIButton!
    weak var delegate: TableItemCellDelegate?

    func configure(_ item: TableItem) {
        itemImageView.image = UIImage(named: item.imageName)
        itemTitle.text = item.title
    }

    @IBAction
    func moreInfo(_ sender: Any) {
        delegate?.tableItemCellMoreInfo(self)
    }

}
