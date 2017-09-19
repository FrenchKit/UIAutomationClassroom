//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var item: TableItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title

        imageView.accessibilityIdentifier = "image"
        titleLabel.accessibilityIdentifier = "title"
        descriptionText.accessibilityIdentifier = "description"
    }

}
