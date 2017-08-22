//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

class CollectionItemCell: UICollectionViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
    }

    func configure(_ item: CollectionItem) {
        itemImageView.image = UIImage(named: item.imageName)
        itemNameLabel.text = item.name
        itemPriceLabel.text = item.price
    }
    
}
